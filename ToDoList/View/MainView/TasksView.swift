//
//  TasksControllerView.swift
//  ToDoList
//
//  Created by Giorgi on 2/12/21.
//

import UIKit

protocol TasksViewDelegate: class {
    func showSideMenu()
    func textDidChange(_ textfield: UITextField, label: UILabel)
}

class TasksView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: TasksViewDelegate?
    
    let tableView = UITableView()
    
     let addTaskTextfield = CustomTextField(placeholder: "Add task")
     let characterCountLabel: UILabel = {
        let label = UILabel()
         label.textColor = .lightGray
         label.font = UIFont.systemFont(ofSize: 14)
         label.text = "0/50"
       
       return label
   }()
    
    private lazy var sideMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "line.horizontal.3.circle"), for: .normal)
        button.addTarget(self, action: #selector(handleShowSideMenu), for: .touchUpInside)
        button.tintColor = .black
        
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraintsForViews()
        configureTableView() 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
    }
    
    //MARK: - Helpers
    
    func setConstraintsForViews() {
        
        addSubview(sideMenuButton)
        sideMenuButton.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor,
                            paddingTop: 16, paddingLeft: 12, width: 80, height: 30)
        
        
        addSubview(addTaskTextfield)
        addTaskTextfield.centerX(inView: self)
        addTaskTextfield.anchor(top: sideMenuButton.bottomAnchor, left: leftAnchor, right: rightAnchor,
                                paddingTop: 20, paddingLeft: 32, paddingRight: 32)

        
        addSubview(characterCountLabel)
        characterCountLabel.anchor(bottom: addTaskTextfield.bottomAnchor, right: addTaskTextfield.rightAnchor, paddingBottom: -18)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange),
                                               name: UITextField.textDidChangeNotification, object: nil)
    }
    
    func configureTableView() {
        addSubview(tableView)
        tableView.anchor(top: addTaskTextfield.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,  paddingTop: 16)
        
        tableView.register(TaskCell.self, forCellReuseIdentifier: Constants.tasksCellId)
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        
        tableView.rowHeight = 60
        
        tableView.tableFooterView = UIView()
    }
    
    //MARK: - Actions
    
    @objc func textDidChange() {
        delegate?.textDidChange(addTaskTextfield,
                                label: characterCountLabel)
    }
    
    @objc func handleShowSideMenu() {
        delegate?.showSideMenu()
    }
}
