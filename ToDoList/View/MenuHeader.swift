//
//  MenuHeader.swift
//  ToDoList
//
//  Created by Giorgi on 2/8/21.
//


import UIKit
import SDWebImage

class MenuHeader: UIView {
    
    // MARK: - Properties
    
    var user: User? {
        didSet{
            configure()
        }
    }
        
    private lazy var profileImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .black
        view.clipsToBounds = true

        return view
    }()
    

    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "test test"
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "test@gmail.com"

        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor,
                                paddingTop: 32, paddingLeft: 12,
                                width: 64, height: 64)
        profileImageView.layer.cornerRadius = 64 / 2
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, emailLabel])
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.axis = .vertical
        
        addSubview(stack)
        stack.centerY(inView: profileImageView,
                      leftAnchor: profileImageView.rightAnchor,
                      paddingLeft: 12)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
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
            } else {
                self.profileImageView.image = UIImage(systemName:"person.circle")
            }
        }
    }
}
