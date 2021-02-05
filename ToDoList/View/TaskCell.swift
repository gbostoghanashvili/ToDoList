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
                
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func setupButtons(isCompleted: Bool) {
        
        if isCompleted {
            checkMarkButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            checkMarkButton.tintColor = .systemGreen
        } else {
            checkMarkButton.setImage(UIImage(systemName: "square"), for: .normal)
            checkMarkButton.tintColor = .black
        }
    }
    
    func setupTitleLabel(isCompleted: Bool) {
        guard let task = self.task else {return}
        
        let attributedString: NSMutableAttributedString =  NSMutableAttributedString(string: task.title)
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
        
        if isCompleted {
                taskLabel.attributedText = attributedString
                taskLabel.textColor = .lightGray
        } else {
                taskLabel.attributedText = nil
                taskLabel.text = task.title
                taskLabel.textColor = .black
        }
    }
    
    
    func configure() {
        guard let task = self.task else {return}
        DispatchQueue.main.async {
            self.setupButtons(isCompleted: task.isCompleted)
            self.setupTitleLabel(isCompleted: task.isCompleted)
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


