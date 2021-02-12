
//
//  RecoverPasswordController.swift
//  ToDoList
//
//  Created by Giorgi on 2/8/21.
//

import UIKit

class RecoverPasswordController: UIViewController {
    
    //MARK: - Properties
    
    private var email: String
    private lazy var recoverPasswordView = RecoverPasswordView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUi()
    }
    
    init(email: String) {
        self.email = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureUi() {
        view.backgroundColor = .white
        view.addSubview(recoverPasswordView)
        recoverPasswordView.email = email
        recoverPasswordView.delegate = self
    }
}

    
extension RecoverPasswordController: RecoverPasswordViewDelegate {
    func handleBackButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func handleRecoverPassword(email: String) {
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
}

