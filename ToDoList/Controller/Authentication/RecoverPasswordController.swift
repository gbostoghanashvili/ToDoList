
//
//  RecoverPasswordController.swift
//  ToDoList
//
//  Created by Giorgi on 2/8/21.
//

import UIKit

class RecoverPasswordController: UIViewController {
    
    //MARK: - Properties
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUi()
    }
    
    //MARK: - Helpers
    
    func configureUi() {
        guard let email = email else {return}
        emailTextfield.text = email
        view.backgroundColor = .white
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                          paddingTop: 16, paddingLeft: 16)
        let stack = configureStack()
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                                        paddingTop: 100, paddingLeft: 16, paddingRight: 16)

        emailTextfield.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        resetPasswordButton.addTarget(self, action: #selector(handleReset), for: .touchUpInside)
    }
    
    func configureStack() -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [emailTextfield, resetPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        return stack
    }
    
    //MARK: - Actions
    
    @objc func handleBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleReset() {
        guard let email = emailTextfield.text else {return}
        showLoader(true)
        AuthService.resetPassword(withEmail: email) { error in
            self.showLoader(false)
            if let error = error {
                self.showMessage(withTitle: "Error", message: error.localizedDescription, dissmissalText: "Ok")
                return
            }
            self.showMessage(withTitle: "Success", message: "We sent a link to your email to reset your password", dissmissalText: "ok")
        }
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

    

