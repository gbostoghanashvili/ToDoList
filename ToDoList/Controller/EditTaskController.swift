//
//  EditTaskController.swift
//  ToDoList
//
//  Created by Giorgi on 2/4/21.
//

import UIKit

class EditTaskController: UIViewController {
    
    //MARK: - Properties

    let editTaskTextfield = CustomTextField(placeholder: "Add task")
  
        
    //MARK: - Lifecycle
    
    init(task: Task) {
        editTaskTextfield.text = task.title
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUi()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
    }
    
        
        //MARK: - Helper Methods
    
    func configureNavBar() {
        navigationController?.navigationBar.isHidden = false
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSaveTask))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
        
    func configureUi() {
        view.backgroundColor = .white
        
        view.addSubview(editTaskTextfield)
        editTaskTextfield.centerX(inView: view)
        editTaskTextfield.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                                paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        editTaskTextfield.becomeFirstResponder()
        editTaskTextfield.delegate = self
        
    }
    
        //MARK: - Actions
    @objc func handleSaveTask () {
        navigationController?.popViewController(animated: true)
        print("DEBUG: handle save task here")
    }
    
    @objc func handleCancel () {
        navigationController?.popViewController(animated: true)
        print("DEBUG: handle cancel action here")
    }

}

    //MARK: - Textfield Delegate

    extension EditTaskController: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            
            return true
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard range.location == 0 else {
                    return true
                }

                let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
                return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
        }
    }

