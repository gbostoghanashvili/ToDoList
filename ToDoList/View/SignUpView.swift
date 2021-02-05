//
//  SignUpView.swift
//  ToDoList
//
//  Created by Giorgi on 2/5/21.
//

import UIKit

protocol SignUpViewDelegate: class {
    func handleSignUp()
    func handleShowLoginPage()
}

class SignUpView: UIView {
    
    //MARK: - Properties
        
    weak var delegate: SignUpViewDelegate?
    
    private let signUpButton = AuthenticationButton(title: "Sign Up")
    private let alreadyHaveAccountButton = AttributedButton(text: "Already an account", boldText: "Sign Up")
            let emailTextField = CustomTextField(placeholder: "Email", type: .emailAddress)
            let usernameTextField = CustomTextField(placeholder: "Username")
            let passwordTextField = CustomTextField(placeholder: "Password", secureTextEntry: true)
    
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
        
        addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: self)
        alreadyHaveAccountButton.anchor(bottom: safeAreaLayoutGuide.bottomAnchor, paddingBottom: 18)
    }
    
    func configureStack() -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton, UIView()])
        stack.axis = .vertical
        stack.spacing = 12
        
        return stack
    }
    
    func addTargets() {
        signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        alreadyHaveAccountButton.addTarget(self, action: #selector(handleShowLoginPage), for: .touchUpInside)
    }
    
    //MARK: - Actions
    
    @objc func handleSignUp() {
        delegate?.handleSignUp()
    }
    
    @objc func handleShowLoginPage() {
        delegate?.handleShowLoginPage()
    }
}
