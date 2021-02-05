//
//  RegistrationController.swift
//  ToDoList
//
//  Created by Giorgi on 2/5/21.
//

import UIKit

class SignUpController: UIViewController {
    
    //MARK: - Properties
    
    private lazy var signUpView = SignUpView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUi()
        dismissKeyboard()
    }

    //MARK: - Actions
    
    func configureUi() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        view.addSubview(signUpView)
        signUpView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                         bottom: view.bottomAnchor, right: view.rightAnchor)
        signUpView.delegate = self
    }

    
    
}

extension SignUpController: SignUpViewDelegate {
    func handleSignUp() {
        print("sigup button tapped")
        guard let email = signUpView.emailTextField.text,
              let password = signUpView.passwordTextField.text,
              let username = signUpView.usernameTextField.text else {return}
        
        let credentials = AuthCredentials(email: email, password: password, username: username)
        
        AuthService.signUserUp(withCredentials: credentials) { error in
            
            if let error = error {
                self.showMessage(withTitle: "Error", message: error.localizedDescription, dissmissalText: "Ok")
                return
            }
            self.dismiss(animated: true)
        }
    }
    
    func handleShowLoginPage() {
        navigationController?.popViewController(animated: true)
    }
}
