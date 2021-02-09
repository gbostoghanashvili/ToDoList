//
//  ContainerController.swift
//  ToDoList
//
//  Created by Giorgi on 2/8/21.
//

import Firebase

class ContainerController: UIViewController {
    
    //MARK: - Properties
    
    private var tasksController = TasksController()
    private var menuController = MenuController()
    
    private var isExpanded = false
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTasksController()
        configureMenuController()
    }
    
    
    //MARK: - Helpers
    
    func configureTasksController() {
        addChild(tasksController)
        tasksController.view.frame = self.view.frame
        view.addSubview(tasksController.view)
        tasksController.didMove(toParent: self)
        tasksController.delegate = self
    }
    
    func configureMenuController() {
        addChild(menuController)
        menuController.didMove(toParent: self)
        menuController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        menuController.delegate = self
        view.insertSubview(menuController.view, at: 0)
    }
    
    func animateMenu(shouldExpand: Bool, completion: ((Bool) -> Void)? = nil) {
        if shouldExpand {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.tasksController.view.frame.origin.x = self.view.frame.width - 150
        }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.tasksController.view.frame.origin.x = 0
            }, completion: nil)
        }
    }
    func presentLoginController() {
        let controller = LoginController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        tasksController.tasks.removeAll()

        
        present(nav, animated: true)
    }
    
    func presentLogoutAlert(){
        let alert = UIAlertController(title: "Log out?", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let logoutAction = UIAlertAction(title: "Log out", style: .default) { _ in
            do {
                try Auth.auth().signOut()
                self.presentLoginController()
                
            } catch {
                print("DEBUG: Failed to sign out")
            }
        }
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    //MARK: -  Actions
}

// MARK: - TasksControllerDelegate

extension ContainerController: TasksControllerDelegate {
    func handleMenuToggle() {
        isExpanded.toggle()
        animateMenu(shouldExpand: isExpanded)
    }
}


// MARK: - MenuControllerDelegate

extension ContainerController: MenuControllerDelegate {
    func didSelect(option: MenuOptions) {
        print("tapped")
        
            switch option {
            case .settings:
                print("DEBUG: Handle show settings here")
            case .userProfile:
                let controller = UserProfileController()
                handleMenuToggle()
                navigationController?.pushViewController(controller, animated: true)
                
            case .logout:
                handleMenuToggle()
                presentLogoutAlert()
        }
    }
}
