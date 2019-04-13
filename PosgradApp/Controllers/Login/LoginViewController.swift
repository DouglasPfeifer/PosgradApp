//
//  LoginViewController.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 14/03/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var recoverPasswordButton: UIButton!
    
    var activeTextField: UITextField?
    
    let alert = UIAlertController(title: nil, message: "Autenticando...\n\n", preferredStyle: .alert)
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 110, y: 35, width: 50, height: 50))
    
    // MARK: - View life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        loginButton.layer.cornerRadius = 6
        recoverPasswordButton.layer.cornerRadius = 6
        
        // Both observers are crucial to adjust the view accordinly to the keyboard position
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.handleViewInteractionWithKeyboard), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.handleViewInteractionWithKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        initAlertView()
    }
    
    deinit {
        // make sure to remove the observer when this view controller is dismissed/deallocated
        NotificationCenter.default.removeObserver(self)
    }
    
    func initAlertView () {
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        loadingIndicator.color = UIColor.black
    }
    
    @IBAction func login(_ sender: Any) {
        let userEmail = emailTextField.text
        let userPassword = passwordTextField.text
        // Campos em branco
        if userEmail == "" || userPassword == "" {
            let alertController = UIAlertController(title: "Campos em branco", message: "Email ou senha não informados.", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        // Campos preenchidos
        } else {
            present(alert, animated: true)
            // Verificar credeciais e realizar login
            Auth.auth().signIn(withEmail: userEmail!, password: userPassword!) { (user, error) in
                if let error = error {
                    self.alert.dismiss(animated: true, completion: {
                        let alert = UIAlertController(title: "Aconteceu um erro", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true)
                    })
                } else if user != nil {
                    self.alert.dismiss(animated: true, completion: {
                        guard let userID = Auth.auth().currentUser?.uid else { return }
                        self.appDelegate.user.ID = userID
                        self.performSegue(withIdentifier: "successfulLogin", sender: self)
                    })
                }
            }
        }
    }
    
    // MARK: - Resolvendo o ajuste da view em relação ao teclado
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
        if textField == emailTextField {
            textField.resignFirstResponder()
            activeTextField = passwordTextField
            activeTextField?.becomeFirstResponder()
        } else {
            view.endEditing(true)
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "successfulLogin" {
            let destinationVC = segue.destination as! MainTabBarViewController
        }
    }
}
