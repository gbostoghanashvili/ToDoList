//
//  SettingsController.swift
//  ToDoList
//
//  Created by Giorgi on 2/9/21.
//

import UIKit

class SettingsController: UIViewController {
    
    //MARK: - Properties
    
    lazy var settingsView = SettingsView()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUi()
    }
  
    //MARK: - Helpers
    
    func configureUi(){
        view.backgroundColor = .white
        view.addSubview(settingsView)
        settingsView.fillSuperview()
        settingsView.backButton.delegate = self
    }
}

extension SettingsController: BackButtonDelegate {
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
