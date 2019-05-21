//
//  ProfileViewController.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 11/04/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileEmailTextField: UITextField!
    @IBOutlet weak var profileNameTextField: UITextField!
    @IBOutlet weak var profileCourseTextField: UITextField!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    var activeTextField: UITextField?
    
    var database: Firestore!
    
    var avatarObserver : NSKeyValueObservation?
    var nameObserver : NSKeyValueObservation?
    var emailObserver : NSKeyValueObservation?
    var courseObserver : NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        profileEmailTextField.delegate = self
        profileNameTextField.delegate = self
        profileCourseTextField.delegate = self
        
        // Both observers are crucial to adjust the view accordingly to the keyboard position
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.handleViewInteractionWithKeyboard), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.handleViewInteractionWithKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        initUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        // make sure to remove the observer when this view controller is dismissed/deallocated
        NotificationCenter.default.removeObserver(self)
    }
    
    func initUI () {
        changePasswordButton.layer.cornerRadius = 6
        logoutButton.layer.cornerRadius = 6
        
        if let avatar = appDelegate.user.avatar {
            profileImageView.image = avatar
        } else {
            avatarObserver = appDelegate.user.observe(\.avatar) { (_, _) in
                if let avatarImage = self.appDelegate.user.avatar {
                    self.profileImageView.image = avatarImage
                }
            }
        }
        if let name = appDelegate.user.name {
            profileNameLabel.text = name
            profileNameTextField.placeholder = name
        } else {
            nameObserver = appDelegate.user.observe(\.name) { (_, _) in
                if let name = self.appDelegate.user.name {
                    self.profileNameTextField.placeholder = name
                }
            }
        }
        if let email = appDelegate.user.email {
            profileEmailTextField.placeholder = email
        } else {
            emailObserver = appDelegate.user.observe(\.email) { (_, _) in
                if let email = self.appDelegate.user.email {
                    self.profileEmailTextField.placeholder = email
                }
            }
        }
        if let course = appDelegate.user.course {
            profileCourseTextField.placeholder = course
        } else {
            courseObserver = appDelegate.user.observe(\.course) { (_, _) in
                if let course = self.appDelegate.user.course {
                    self.profileCourseTextField.placeholder = course
                }
            }
        }
    }
    
    // MARK: - Resolving the view adjustment in relation to the keyboard
    @objc func handleViewInteractionWithKeyboard (notification: NSNotification) {
        var keyboardFrame: CGRect?
        
        if let userInfo = notification.userInfo {
            keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect
        }
        
        let viewMinY = Float(self.view.frame.minY)
        let viewHeight = Float(self.view.frame.height)
        let textFieldY = Float((self.activeTextField?.frame.origin.y)!)
        let textFieldHeight = Float((self.activeTextField?.frame.height)!)
        let keyboardHeight = Float((keyboardFrame?.height)!)
        
        let topOfKeyboard = viewHeight - keyboardHeight
        let bottomOfTextField = textFieldY + textFieldHeight
        let differenceBetweenTopOfKeyboardAndBottomOfTextField = (bottomOfTextField - topOfKeyboard)
        if notification.name == NSNotification.Name.UIKeyboardWillShow && viewMinY == 0 {
            if differenceBetweenTopOfKeyboardAndBottomOfTextField > 0 {
                self.view.frame.origin.y -= CGFloat(differenceBetweenTopOfKeyboardAndBottomOfTextField + 5)
                //(keyboardFrame?.height)!
            }
        } else if notification.name == NSNotification.Name.UIKeyboardWillHide && viewMinY != 0 {
            if viewMinY != 0 {
                self.view.frame.origin.y -= self.view.frame.minY
            }
        }
    }
    
    // MARK: - Textfield delegate functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Downloading profile image from firestore
    func retrieveProfileImage (completion: @escaping (Bool) -> ()) {
        completion(true)
    }
    
    @IBAction func closeProfile(_ sender: Any) {
        performSegueToReturnBack()
    }
    
    @IBAction func logout(_ sender: Any) {
        try! Auth.auth().signOut()
        let cleanUser = User(avatar: nil, course: nil, email: nil, team: nil, name: nil, ID: nil)
        appDelegate.user = cleanUser
        
        if let storyboard = self.storyboard {
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
            self.present(loginViewController, animated: true, completion: nil)
        }
    }
}
