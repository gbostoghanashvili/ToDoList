//
//  RecoverPasswordView.swift
//  ToDoList
//
//  Created by Giorgi on 2/12/21.
//

import UIKit

protocol RecoverPasswordViewDelegate: class {
    func handleBackButtonAction()
    func handleRecoverPassword(email: String)
}

class RecoverPasswordView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: RecoverPasswordViewDelegate?
    
    private let emailTextfield = CustomTextField(placeholder: "Enter your email", type: .emailAddress)
    private let resetPasswordButton = AuthenticationButton(title: "Reset")
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        let image = UIImage(systemName: "chevron.left")
        button.setImage(image, for: .normal)
        button.setDimensions(height: 30, width: 30)
        button.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    var email: String?
    
    private var formIsValid: Bool {
        return email?.isEmpty == false
    }
    
    private var buttonBackgroundColor: UIColor {
        return formIsValid ? UIColor.systemBlue : UIColor.systemBlue.withAlphaComponent(0.5)
    }
    
    private var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.7)
    }
    
    
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backButton)
        backButton.anchor(top: safeAreaLayoutGuide.topAnchor,
                          left: leftAnchor,
                          paddingTop: 16, paddingLeft: 16)
        let stack = configureStack()
        addSubview(stack)
        stack.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, right: rightAnchor,
                                        paddingTop: 100, paddingLeft: 16, paddingRight: 16)
        
        emailTextfield.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        resetPasswordButton.addTarget(self, action: #selector(handleReset), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureStack() -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [emailTextfield, resetPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        return stack
    }
    
    
    //MARK: - Actions
    
    @objc func handleBackButtonTapped() {
        delegate?.handleBackButtonAction()
    }
    
    @objc func handleReset() {
        guard let email = emailTextfield.text else {return}
        delegate?.handleRecoverPassword(email: email)
    }
    
    @objc func textDidChange (sender: UITextField) {
        if sender == emailTextfield {
            email = sender.text
        }
        resetPasswordButton.backgroundColor = buttonBackgroundColor
        resetPasswordButton.setTitleColor(buttonTitleColor, for: .normal)
        resetPasswordButton.isEnabled = formIsValid
        }
    }
    

