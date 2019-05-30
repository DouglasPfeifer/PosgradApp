//
//  EmphasisViewController.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 22/05/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import UIKit
import Firebase

class EmphasisViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var subjectsColectionView: UICollectionView!
    
    var selectedCourse: String?
    var selectedEmphasis : String?
    var selectedCicle : Int?
    
    var database: Firestore!
    
    var subjects = [Subject]()
    var selectedSubject : Int?
    
    var firstCollectionViewLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subjectsColectionView.delegate = self
        subjectsColectionView.dataSource = self
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        initFirebase()
        initNavigationBar()
        
        retrieveSubjectsByCourseCicleEmphasis { (completed) in
            if completed {
                self.subjectsColectionView.reloadData()
            }
        }
    }
    
    func initFirebase () {
        database = Firestore.firestore()
        let settings = database.settings
        settings.areTimestampsInSnapshotsEnabled = true
        database.settings = settings
    }
    
    func initNavigationBar () {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: String(format: "%dª onda", (selectedCicle! + 1)), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        navigationItem.title = selectedEmphasis!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = self.subjectsColectionView.frame.width
        return CGSize(width: (collectionViewWidth/2 - 24), height: (collectionViewWidth/2 - 24))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if firstCollectionViewLoad {
            firstCollectionViewLoad = false
            let loadingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: subjectsColectionView.bounds.size.width, height: subjectsColectionView.bounds.size.height))
            loadingLabel.text = "Carregando..."
            loadingLabel.textColor = UIColor.gray
            loadingLabel.textAlignment = .center
            loadingLabel.numberOfLines = 0
            loadingLabel.font = UIFont.systemFont(ofSize: 18)
            subjectsColectionView.backgroundView = loadingLabel
            return 0
        } else {
            if subjects.count == 0 {
                let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: subjectsColectionView.bounds.size.width, height: subjectsColectionView.bounds.size.height))
                noDataLabel.text = "Sem informações."
                noDataLabel.textColor = UIColor.gray
                noDataLabel.textAlignment = .center
                noDataLabel.numberOfLines = 0
                noDataLabel.font = UIFont.systemFont(ofSize: 18)
                subjectsColectionView.backgroundView = noDataLabel
                return 0
            } else {
                subjectsColectionView.backgroundView = nil
                return 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subjectCell", for: indexPath) as! SubjectCollectionViewCell
        if let imageURL = subjects[indexPath.row].image {
            cell.subjectImageView.downloaded(from: imageURL)
        } else {
            cell.subjectImageView.image = UIImage(named: "noimage")
        }
        cell.subjectImageView.contentMode = .scaleAspectFit
        cell.sucjectTItleLabel.text = subjects[indexPath.row].name
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSubject = indexPath.row
        performSegue(withIdentifier: "emphasisToSubject", sender: self)
    }
    
    func retrieveSubjectsByCourseCicleEmphasis (completion: @escaping (Bool) -> ()) {
        let cicleFirestoreString = String(format: "Ciclo %d", (self.selectedCicle! + 1))
        database.collection(SubjectsKeys.collectionKey).whereField(SubjectsKeys.formation, isEqualTo: self.selectedCourse!).whereField(SubjectsKeys.cicleKey, isEqualTo: cicleFirestoreString).whereField(SubjectsKeys.emphasis, isEqualTo: self.selectedEmphasis!).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(false)
            } else {
                self.subjects.removeAll()
                for document in querySnapshot!.documents {
                    let newArrayLearningObject = document[SubjectsKeys.learningObjectKey] as? [Any]
                    let newImage = document[SubjectsKeys.image] as? String
                    let newName = document[SubjectsKeys.name] as? String
                    let newSubject = Subject.init(arrayLearningObject: newArrayLearningObject!, image: newImage!, name: newName!)
                    self.subjects.append(newSubject)
                }
                completion(true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "emphasisToSubject" {
            let destinationVC = segue.destination as! SubjectViewController
            destinationVC.subject = self.subjects[selectedSubject!]
        }
    }
}
