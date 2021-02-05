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
    private let task: Task
    private let characterCountLabel: UILabel = {
       let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/100"
       
       return label
   }()
  
    //MARK: - Lifecycle
    
    init(task: Task) {
        editTaskTextfield.text = task.title
        self.task = task
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
    }
    
        //MARK: - Helper Methods
    
    func configureNavBar() {
        navigationController?.navigationBar.isHidden = false
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSaveTask))
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
        checkMaxLength(editTaskTextfield)
        guard let count = editTaskTextfield.text?.count else {return}
        characterCountLabel.text = "\(count)/100"
    }
    
    @objc func handleSaveTask () {
        navigationController?.popViewController(animated: true)
        guard let newTitle = editTaskTextfield.text else {return}
        Service.editTask(title: newTitle, taskUid: task.uid)
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
            restrictWhiteSpaces(textField: textField, range: range, replacementString: string)
        }
    }

