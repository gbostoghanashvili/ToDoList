//
//  BackButton.swift
//  ToDoList
//
//  Created by Giorgi on 2/9/21.
//

import UIKit

protocol BackButtonDelegate: class {
    func backButtonTapped()
}

class BackButton: UIButton {
    
    weak var delegate: BackButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tintColor = .black
        let image = UIImage(systemName: "chevron.left")
        setImage(image, for: .normal)
        setDimensions(height: 30, width: 30)
        addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func handleBackButtonTapped() {
        delegate?.backButtonTapped()
    }
}
