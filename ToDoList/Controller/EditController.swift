//
//  EditTaskController.swift
//  ToDoList
//
//  Created by Giorgi on 2/4/21.
//

import UIKit

enum Editable {
    case task, email, username
}

class EditController: UIViewController {
    
    //MARK: - Properties

    private lazy var editView = EditView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
    
    private let changeingField: Editable
    
    let text: String
    let taskId: String?
  
    private lazy var saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSave))

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUi()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
    }

    
    init(field: Editable, text: String, taskID: String? = nil) {
        self.changeingField = field
        self.text = text
        self.taskId = taskID
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        //MARK: - Helper Methods
    
    func configureNavBar() {
        navigationController?.navigationBar.isHidden = false
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
        
    func configureUi() {
        view.backgroundColor = .white
        view.addSubview(editView)
        editView.text = text
        editView.delegate = self
        editView.editTextfield.delegate = self
    }
    
        //MARK: - Actions

    @objc func handleSave () {
        guard let newTitle = editView.editTextfield.text else {return}
        
        switch changeingField {
        case .task:
            guard let taskId = self.taskId else {return}
            Service.editTask(title: newTitle, taskUid: taskId)
            
        case .email:
            Service.updateUser(email: newTitle) { error in
                if let error = error {
                    print("DEBUG: Error while updateing user email\(error.localizedDescription)")
                    return
                }
            }
            
        case .username:
            Service.updateUser(username: newTitle)
        }
        navigationController?.popViewController(animated: true)
    }

    @objc func handleCancel () {
        navigationController?.popViewController(animated: true)
    }
}

    //MARK: - Textfield Delegate

extension EditController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        restrictWhiteSpaces(textField: textField, range: range, replacementString: string)
    }
}

extension EditController: EditViewDelegate {
    func textDidChange(_ textField: UITextField, label: UILabel) {
        checkMaxLength(textField)
        guard let count = textField.text?.count else {return}
        label.text = "\(count)/50"
        }
    }
    
    

