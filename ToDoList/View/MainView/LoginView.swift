//
//  LoginView.swift
//  ToDoList
//
//  Created by Giorgi on 2/5/21.
//

import UIKit

protocol LoginViewDelegate: class {
    func handleLogin()
    func handleRecoverPassword()
    func handleShowSignUpPage()
}

class LoginView: UIView {
    
    //MARK: - Properties
        
    weak var delegate: LoginViewDelegate?
    
    let emailTextField = CustomTextField(placeholder: "Email", type: .emailAddress)
    let passwordTextField = CustomTextField(placeholder: "Password", secureTextEntry: true)
    private let loginButton = AuthenticationButton(title: "Login")
    private let dontHaveAccountButton = AttributedButton(text: "Don't have an account", boldText: "Sign Up")
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Forgot password?", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        return button
    }()
    
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? UIColor.systemBlue : UIColor.systemBlue.withAlphaComponent(0.5)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.7)
    }

    
    //MARK: - Lifecycle
    
   override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints(stack: configureStack())
        addTargets()
    
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureConstraints(stack: UIStackView) {
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor,
                     paddingTop: 100, paddingLeft: 16, paddingRight: 16,
                     width: frame.width, height: 400)
        
        addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: self)
        dontHaveAccountButton.anchor(bottom: safeAreaLayoutGuide.bottomAnchor, paddingBottom: 18)
        
    }
    
    func configureStack() -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, forgotPasswordButton, UIView()])
        stack.axis = .vertical
        stack.spacing = 12
        
        return stack
    }
    
    func addTargets() {
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(handleRecoverPassword), for: .touchUpInside)
        dontHaveAccountButton.addTarget(self, action: #selector(handleShowSignUpPage), for: .touchUpInside)
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    
    
    
    //MARK: - Actions
    
    @objc func handleLogin() {
        delegate?.handleLogin()
    }
    
    @objc func handleRecoverPassword() {
        delegate?.handleRecoverPassword()
    }
    
    @objc func handleShowSignUpPage() {
        delegate?.handleShowSignUpPage()
    }
    
    @objc func textDidChange (sender: UITextField) {
        if sender == emailTextField {
            email = sender.text
        } else {
            password = sender.text
        }
        loginButton.backgroundColor = buttonBackgroundColor
        loginButton.setTitleColor(buttonTitleColor, for: .normal)
        loginButton.isEnabled = formIsValid
    }
}
