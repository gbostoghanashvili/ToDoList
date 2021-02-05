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
    
    //MARK: - Lifecycle
    
   override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints(stack: configureStack())
        addTargetsToButtons()
        
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
    
    func addTargetsToButtons() {
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(handleRecoverPassword), for: .touchUpInside)
        dontHaveAccountButton.addTarget(self, action: #selector(handleShowSignUpPage), for: .touchUpInside)
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
}
