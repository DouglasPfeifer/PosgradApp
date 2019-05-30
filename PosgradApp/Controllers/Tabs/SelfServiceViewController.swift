//
//  SelfServiceViewController.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 18/02/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import UIKit
import Firebase

class SelfServiceViewController: UIViewController, UIScrollViewDelegate, ClassSelfServiceCellDelegate {
    
    var scrollView = UIScrollView()
    var courseImageView = UIImageView()
    var ciclesStackView = [UIView]()
    
    let segment: UISegmentedControl = UISegmentedControl(items: ["DSS-BI", "ESPGTI"])
    
    var database : Firestore!
    var storage : Storage?
    var storageRef : StorageReference?
    
    var courses = [Course]()
    
    var segueEmphasis : String?
    var segueCicle : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        
        initFirebase()
        initScrollView()
        
        retrieveSelfServiceData(completion: {
            (completed) in
            if completed {
                self.initSegmentedControl()
                self.setCourseImageView()
                self.setCourseCiclesView()
            } else {
                
            }
        })
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        let subViews = self.scrollView.subviews
//        for subview in subViews{
//            subview.removeFromSuperview()
//        }
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        retrieveSelfServiceData(completion: {
//            (completed) in
//            if completed {
//                self.initSegmentedControl()
//                self.setCourseImageView()
//                self.setCourseCiclesView()
//            } else {
//
//            }
//        })
//    }
    
    func initFirebase () {
        storage = Storage.storage()
        storageRef = storage!.reference()
        
        database = Firestore.firestore()
        let settings = database.settings
        settings.areTimestampsInSnapshotsEnabled = true
        database.settings = settings
    }
    
    func initSegmentedControl () {
        for (index, course) in self.courses.enumerated() {
            self.segment.setTitle(course.description!, forSegmentAt: index)
        }
        self.segment.sizeToFit()
        self.segment.tintColor = UIColor.black
        self.segment.selectedSegmentIndex = 0
        self.segment.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : UIColor.white], for: .normal)
        self.segment.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : UIColor.white], for: .selected)
        
        self.segment.addTarget(self, action: #selector(self.segmentChanged), for: .valueChanged)
        
        self.navigationItem.titleView = self.segment
    }
    
    func initScrollView () {
        self.view.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func setCourseImageView () {
        self.scrollView.addSubview(self.courseImageView)
        self.courseImageView.translatesAutoresizingMaskIntoConstraints = false
        self.courseImageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 16).isActive = true
        self.courseImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        self.courseImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        self.courseImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.courseImageView.contentMode = .scaleAspectFit
        self.courseImageView.image = nil
        let imageURL = self.courses[self.segment.selectedSegmentIndex].image!
        self.courseImageView.downloaded(from: imageURL)
    }
    
    func setCourseCiclesView () {
        self.ciclesStackView.removeAll()
        for index in 1...self.courses[self.segment.selectedSegmentIndex].cicles! {
            let newCicleView = SelfServiceCourseCicleView()
            
            newCicleView.initSubviews(cicle: index, emphases: self.courses[self.segment.selectedSegmentIndex].emphasis!)
            
            scrollView.addSubview(newCicleView)
            
            newCicleView.translatesAutoresizingMaskIntoConstraints = false
            
            if ciclesStackView.isEmpty {
                newCicleView.topAnchor.constraint(equalTo: self.courseImageView.bottomAnchor, constant: 16).isActive = true
                newCicleView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
                newCicleView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
                newCicleView.heightAnchor.constraint(equalToConstant: 180).isActive = true
                //newCicleView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16).isActive = true
            } else if index != self.courses[self.segment.selectedSegmentIndex].cicles {
                newCicleView.topAnchor.constraint(equalTo: self.ciclesStackView.last!.bottomAnchor, constant: 8).isActive = true
                newCicleView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
                newCicleView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
                newCicleView.heightAnchor.constraint(equalToConstant: 180).isActive = true
            } else {
                newCicleView.topAnchor.constraint(equalTo: self.ciclesStackView.last!.bottomAnchor, constant: 8).isActive = true
                newCicleView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
                newCicleView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
                newCicleView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -16).isActive = true
                newCicleView.heightAnchor.constraint(equalToConstant: 180).isActive = true
            }
            
            newCicleView.backgroundColor = UIColor.white
            newCicleView.layer.cornerRadius = 6
            newCicleView.layer.shadowColor = UIColor.black.cgColor
            newCicleView.layer.shadowRadius = 3
            newCicleView.layer.shadowOpacity = 0.25
            newCicleView.layer.shadowOffset = CGSize.zero
            
            newCicleView.delegate = self
            
            ciclesStackView.append(newCicleView)
        }
    }
    
    @objc func segmentChanged(sender: UISegmentedControl) {
        let subViews = self.scrollView.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        
        retrieveSelfServiceData(completion: {
            (completed) in
            if completed {
                self.setCourseImageView()
                self.setCourseCiclesView()
            } else {
                
            }
        })
    }
    
    func retrieveSelfServiceData (completion: @escaping (Bool) -> ()) {
        database.collection(SelfServiceKeys.collectionKey).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(false)
            } else {
                self.courses.removeAll()
                for document in querySnapshot!.documents {
                    if let documentData = document.data() as? [String : Any] {
                        let newAdmins = documentData[SelfServiceKeys.adminsKey] as? [String]
                        let newCourses = documentData[SelfServiceKeys.coursesKey] as? [Any]
                        for course in newCourses! {
                            let dictCourse = course as! [String: Any]
                            let newCicles = dictCourse[SelfServiceKeys.CoursesKeys.cicles] as? Int
                            let newDescription = dictCourse[SelfServiceKeys.CoursesKeys.description] as? String
                            let newEmphasis = dictCourse[SelfServiceKeys.CoursesKeys.emphasis] as? [String]
                            let newImage = dictCourse[SelfServiceKeys.CoursesKeys.image] as? String
                            let newMissions = dictCourse[SelfServiceKeys.CoursesKeys.missions] as? Int
                            let newSeasons = dictCourse[SelfServiceKeys.CoursesKeys.seasons] as? Int
                            self.courses.append(Course(cicles: newCicles, description: newDescription, emphasis: newEmphasis, image: newImage, missions: newMissions, seasons: newSeasons))
                        }
                    }
                }
                completion(true)
            }
        }
    }
    
    func segueToEmphasis(cicle: Int, emphasis: String) {
        self.segueCicle = cicle
        self.segueEmphasis = emphasis
        performSegue(withIdentifier: "selfServiceToEmphasis", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selfServiceToEmphasis" {
            let destinationVC = segue.destination as! EmphasisViewController
            destinationVC.selectedCicle = segueCicle
            destinationVC.selectedEmphasis = segueEmphasis
            destinationVC.selectedCourse = self.segment.titleForSegment(at: segment.selectedSegmentIndex)
        }
    }
}
