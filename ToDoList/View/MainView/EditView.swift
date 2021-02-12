//
//  EditView.swift
//  ToDoList
//
//  Created by Giorgi on 2/12/21.
//

import UIKit

protocol EditViewDelegate: class {
    func textDidChange(_ textField: UITextField, label: UILabel)
}

class EditView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: EditViewDelegate?
    
    let editTextfield = CustomTextField(placeholder: "Add task")
    var text: String? {
        didSet {
            self.editTextfield.text = text
        }
    }
    
    private let characterCountLabel: UILabel = {
       let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/50"
       
       return label
   }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(editTextfield)
        editTextfield.centerX(inView: self)
        editTextfield.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, right: rightAnchor,
                                paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        addSubview(characterCountLabel)
        characterCountLabel.anchor(bottom: editTextfield.bottomAnchor, right: editTextfield.rightAnchor, paddingBottom: -18)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange),
                                               name: UITextField.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
    }

    //MARK: - Actions
    
    @objc func textDidChange() {
        delegate?.textDidChange(editTextfield, label: characterCountLabel)
    }
}
