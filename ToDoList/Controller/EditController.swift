//
//  EditTaskController.swift
//  ToDoList
//
//  Created by Giorgi on 2/4/21.
//

import UIKit

class EditController: UIViewController {
    
    //MARK: - Properties

    let editTaskTextfield = CustomTextField(placeholder: "Add task")
    
    private let characterCountLabel: UILabel = {
       let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/50"
       
       return label
   }()
    
    var task: Task? {
        didSet {
            guard let task = self.task else {return}
            editTaskTextfield.text = task.title
        }
    }
  
    private lazy var saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSaveTask))

    //MARK: - Lifecycle
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUi()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
    }
    
        //MARK: - Helper Methods
    
    func configureNavBar() {
        navigationController?.navigationBar.isHidden = false
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange),
                                               name: UITextField.textDidChangeNotification, object: nil)
    }
        
    func configureUi() {
        view.backgroundColor = .white
        
        view.addSubview(editTaskTextfield)
        editTaskTextfield.centerX(inView: view)
        editTaskTextfield.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                                paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(bottom: editTaskTextfield.bottomAnchor, right: editTaskTextfield.rightAnchor, paddingBottom: -18)
        
        editTaskTextfield.becomeFirstResponder()
        editTaskTextfield.delegate = self
        
    }
    
        //MARK: - Actions
    
    @objc func textDidChange() {
        guard let text = editTaskTextfield.text else {return}
        if !text.isEmpty {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
        
        checkMaxLength(editTaskTextfield)
        guard let count = editTaskTextfield.text?.count else {return}
        characterCountLabel.text = "\(count)/50"
    }
    
    @objc func handleSaveTask () {
        
        guard let task = task,
              let newTitle = editTaskTextfield.text else {return}

        navigationController?.popViewController(animated: true)
        Service.editTask(title: newTitle, taskUid: task.uid)
        
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

