//
//  SettingsControllerView.swift
//  ToDoList
//
//  Created by Giorgi on 2/9/21.
//

import UIKit

class SettingsView: UIView {
    
    //MARK: - Properties
    
    let backButton = BackButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    
    private var enabled = false
    
    private let pushNotificationsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var pushNotificationsSwitch: UISwitch = {
        let s = UISwitch()
        s.isOn = true
        s.tintColor = .white
        s.onTintColor = .systemGreen
        s.addTarget(self, action: #selector(handlePushNotificationsChanged), for: .valueChanged)
        
        return s
    }()

    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backButton)
        backButton.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor,
                          paddingTop: 16, paddingLeft: 16)
        
        configureSwitch(enabled: enabled)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    func configureSwitch(enabled: Bool) {
            addSubview(pushNotificationsLabel)
            pushNotificationsLabel.anchor(top: backButton.bottomAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
            
            addSubview(pushNotificationsSwitch)
            pushNotificationsSwitch.centerY(inView: pushNotificationsLabel)
            pushNotificationsSwitch.anchor( right: rightAnchor, paddingRight: 16)
                    
            pushNotificationsSwitch.isOn = enabled
            pushNotificationsLabel.text = enabled ? "Push Notifications Enabled" : "Push Notifications Disabled"
        
    }
    
    
    //MARK: - Actions
    
    @objc func handlePushNotificationsChanged() {
        enabled.toggle()
        configureSwitch(enabled: enabled)
    }
}
