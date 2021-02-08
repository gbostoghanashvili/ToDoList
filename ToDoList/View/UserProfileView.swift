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
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)

        return label
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
        usernameLabel.centerX(inView: addPhotoButton)
        usernameLabel.anchor(top: addPhotoButton.bottomAnchor, paddingTop: 20)
        
        addSubview(emailLabel)
        emailLabel.centerX(inView: usernameLabel)
        emailLabel.anchor(top: usernameLabel.bottomAnchor, paddingTop: 12)
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
            self.usernameLabel.text = user.username
            self.emailLabel.text = user.email
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
        print("DEBUG: add photo button tapped")
        guard let delegate = self.delegate else {return}
        delegate.handleShowImagePicker()
    }
    
}
