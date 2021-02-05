//
//  LoginController.swift
//  ToDoList
//
//  Created by Giorgi on 2/5/21.
//

import UIKit

class LoginController: UIViewController {
    
    //MARK: - Properties
    
    private lazy var loginView = LoginView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
    
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
        view.addSubview(loginView)
        loginView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                         bottom: view.bottomAnchor, right: view.rightAnchor)
        loginView.delegate = self
    }
    
    

    //MARK: - API
    
}

extension LoginController: LoginViewDelegate {
    func handleLogin() {
        print("DEBUG: handle login here")
        
        guard let email = loginView.emailTextField.text,
              let password = loginView.passwordTextField.text else {return}
        
        AuthService.logUserIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.showMessage(withTitle: "Error", message: error.localizedDescription, dissmissalText: "Ok")
                return
            }
            self.dismiss(animated: true)
        }
    }
    
    func handleRecoverPassword() {
        print("DEBUG: handle recover password here")
    }
    
    func handleShowSignUpPage() {
        let controller = SignUpController()
        navigationController?.pushViewController(controller, animated: true)
    }
}
