//
//  TasksCell.swift
//  ToDoList
//
//  Created by Giorgi on 2/4/21.
//

import UIKit

protocol TaskCellDelegate: class {
    func cell(_ cell: TaskCell, wantsToDeleteTask task: Task)
    func cell(_ cell: TaskCell, wantToMarkTaskCompleted task: Task)
}

class TaskCell: UITableViewCell {
    
    //MARK: - Properties
    
    weak var delegate: TaskCellDelegate?
    
    var task: Task? {
        didSet {
            configure()
        }
    }
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bin.xmark"), for: .normal)
        button.setDimensions(height: 30, width: 30)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        
        return button
    }()
    

    lazy var checkMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleMarkAsComplete), for: .touchUpInside)
        button.setDimensions(height: 30, width: 30)
    
        return button
    }()
    
        let divider = UIView()

    
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        contentView.addSubview(checkMarkButton)
        checkMarkButton.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 22)
        
        contentView.addSubview(deleteButton)
        deleteButton.centerY(inView: self)
        deleteButton.anchor(right: rightAnchor, paddingRight: 16)
        
        addSubview(taskLabel)
        taskLabel.anchor(top: topAnchor, left: checkMarkButton.rightAnchor , bottom: bottomAnchor,
                         right: deleteButton.leftAnchor, paddingLeft: 8, paddingRight: 8)
        
        divider.backgroundColor = .lightGray
        
        addSubview(divider)
        divider.centerY(inView: self)
        divider.anchor( left: leftAnchor, right: rightAnchor,
                        paddingLeft: 60, paddingRight: 60,
                        height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func setupCheckmarkButton(withImageTitle title: String, tintColor: UIColor, textColor: UIColor, buttonIsHidden: Bool) {
        checkMarkButton.setImage(UIImage(systemName: title), for: .normal)
        checkMarkButton.tintColor = tintColor
        taskLabel.textColor = textColor
        deleteButton.isHidden = buttonIsHidden
        divider.isHidden = !buttonIsHidden
    }
    
    func configure() {
        guard let task = self.task else {return}
        taskLabel.text = task.title
        
        if task.isCompleted {
            setupCheckmarkButton(withImageTitle: "checkmark", tintColor: .systemGreen, textColor: .lightGray, buttonIsHidden: true)
            divider.isHidden = false
        } else {
            setupCheckmarkButton(withImageTitle: "square", tintColor: .black, textColor: .black, buttonIsHidden: false)
        }
    }
    
    //MARK: - Actions
    
    @objc func handleDelete() {
        guard let delegate = self.delegate,
              let task = self.task else {return}
        delegate.cell(self, wantsToDeleteTask: task)
    }
    
    @objc func handleMarkAsComplete() {
        guard let delegate = self.delegate,
              let task = self.task else {return}
        delegate.cell(self, wantToMarkTaskCompleted: task)
    }
    
    
}


