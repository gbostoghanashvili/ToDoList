//
//  UserProfileView.swift
//  ToDoList
//
//  Created by Giorgi on 2/8/21.
//

import UIKit
import SDWebImage

protocol UserProfileViewDelegate: class {
    func handleBackButtonTapped()
    func handleShowImagePicker()
    func handleEditUsername()
    func handleEditEmail()
}

class UserProfileView: UIView {
    
    //MARK: - Properties
    
    var user: User? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: UserProfileViewDelegate?
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        let image = UIImage(systemName: "chevron.left")
        button.setImage(image, for: .normal)
        button.setDimensions(height: 30, width: 30)
        button.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
     var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setDimensions(height: 150, width: 150)
        imageView.tintColor = .lightGray
        imageView.layer.cornerRadius = 150/2
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
     lazy var addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleAddPhoto), for: .touchUpInside)
        
        return button
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)

        return label
    }()
    
    private lazy var editUsernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("edit", for: .normal)
        button.addTarget(self, action: #selector(handleEditUsername), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var editEmailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("edit", for: .normal)
        button.addTarget(self, action: #selector(handleEditEmail), for: .touchUpInside)
        
        return button
    }()
    
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backButton)
        backButton.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor,
                          paddingTop: 16, paddingLeft: 16)
        
        addSubview(profileImageView)
        profileImageView.centerX(inView: self)
        profileImageView.anchor(top: topAnchor, paddingTop: 100)
        
        addSubview(addPhotoButton)
        addPhotoButton.centerX(inView: profileImageView)
        addPhotoButton.anchor(top: profileImageView.bottomAnchor, paddingTop: 8)
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: addPhotoButton.bottomAnchor, left: leftAnchor, paddingTop: 40, paddingLeft: 40)
        
        addSubview(editUsernameButton)
        editUsernameButton.centerY(inView: usernameLabel)
        editUsernameButton.anchor(right: rightAnchor, paddingRight: 40)
        
        addSubview(emailLabel)
        emailLabel.anchor(top: usernameLabel.bottomAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 40)
        
        addSubview(editEmailButton)
        editEmailButton.centerY(inView: emailLabel)
        editEmailButton.anchor(right: rightAnchor, paddingRight: 40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    
   
    
    func configure() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self ,
                  let user = self.user,
                  let url = user.profileImageUrl else {return}
            
            self.usernameLabel.text = "Username: \(user.username)"
            self.emailLabel.text = "Email: \(user.email)"
            
            if user.profileImageUrl != "" {
                self.profileImageView.sd_setImage(with: URL(string: url))
                self.addPhotoButton.setTitle("Change Photo", for: .normal)
            } else {
                self.profileImageView.image = UIImage(systemName:"person.circle")
                self.addPhotoButton.setTitle("Add Photo", for: .normal)
            }
        }
    }
    
    
    //MARK: - Actions
    
    @objc func handleBackButtonTapped() {
        guard let delegate = self.delegate else {return}
        delegate.handleBackButtonTapped()
    }
    
    @objc func handleAddPhoto() {
        guard let delegate = self.delegate else {return}
        delegate.handleShowImagePicker()
    }
    
    @objc func handleEditUsername() {
        delegate?.handleEditUsername()
    }
    
    @objc func handleEditEmail() {
        delegate?.handleEditEmail()
    }
}
