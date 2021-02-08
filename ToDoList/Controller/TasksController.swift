//
//  ViewController.swift
//  ToDoList
//
//  Created by Giorgi on 2/4/21.
//

import UIKit
import Firebase

class TasksController: UIViewController {
    
    //MARK: - Properties

    private let cellId = "TasksCell"
    
    private var tasks = [Task]() {
        didSet {self.tableView.reloadData()}
    }
    private let tableView = UITableView()
    
    private let addTaskTextfield = CustomTextField(placeholder: "Add task")
    private let characterCountLabel: UILabel = {
        let label = UILabel()
         label.textColor = .lightGray
         label.font = UIFont.systemFont(ofSize: 14)
         label.text = "0/50"
       
       return label
   }()
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var userProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "person.circle"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleShowUserProfile), for: .touchUpInside)
        button.setDimensions(height: 30, width: 30)
        
        return button
    }()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIfUserIsLoggedIn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
    }
    
    //MARK: - API
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            presentLoginController()
        } else {
            configureUi()
            }
        }
    
    func setData(uid: String, title: String) {
        Service.setData(taskUid: uid, title: title)
    }
    
    //MARK: - Helper Methods
    
    func fetchTasks() {
        Service.fetchData { tasks in
            self.tasks = tasks
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func configureUi() {
        navigationController?.navigationBar.isHidden = true
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: false)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange),
                                               name: UITextField.textDidChangeNotification, object: nil)
        fetchTasks()

        configureRefresher()
        setConstraintsForViews()
        configureTableView()
    }
    
    func configureRefresher() {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
    }
    
    func setConstraintsForViews() {
        view.addSubview(logoutButton)
        logoutButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,paddingTop: 12, paddingLeft: 12)
        
        view.addSubview(userProfileButton)
        userProfileButton.centerY(inView: logoutButton)
        userProfileButton.anchor(right: view.rightAnchor, paddingRight: 12)
        
        
        view.addSubview(addTaskTextfield)
        addTaskTextfield.centerX(inView: view)
        addTaskTextfield.anchor(top: logoutButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                                paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        addTaskTextfield.delegate = self
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(bottom: addTaskTextfield.bottomAnchor, right: addTaskTextfield.rightAnchor, paddingBottom: -18)
        
        
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.anchor(top: addTaskTextfield.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,  paddingTop: 16)
        
        tableView.register(TaskCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        
        tableView.rowHeight = 60
        
        tableView.tableFooterView = UIView()
    }
    
    func presentLoginController() {
        let controller = LoginController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        tasks.removeAll()

        
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
  
    //MARK: - Actions
    
    @objc func textDidChange() {
        checkMaxLength(addTaskTextfield)
        guard let count = addTaskTextfield.text?.count else {return}
        characterCountLabel.text = "\(count)/50"
    }
    
    @objc func handleLogout() {
        presentLogoutAlert()
    }
    
    @objc func handleRefresh() {
        tasks.removeAll()
        fetchTasks()
        }
    
    @objc func handleShowUserProfile() {
        let controller = UserProfileController()
        navigationController?.pushViewController(controller, animated: true)
        }
    }

//MARK: - TableViewDataSource

extension TasksController: UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TaskCell
        let task = tasks[indexPath.row]
        cell.task = task
        cell.delegate = self
        
        return cell
    }
}

//MARK: - TableviewDelegate

extension TasksController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        let controller = EditTaskController(task: task)
        navigationController?.pushViewController(controller, animated: true)
    }
}


//MARK: - UITextfield Delegate

extension TasksController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let title = textField.text else {return false}
        let uuid = NSUUID().uuidString
        setData(uid: uuid, title: title)

        textField.text = nil
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        restrictWhiteSpaces(textField: textField, range: range, replacementString: string)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        characterCountLabel.text = "0/50"
    }
}

//MARK: - TaskCellDelegate

extension TasksController: TaskCellDelegate {
    
    func cell(_ cell: TaskCell, wantsToDeleteTask task: Task) {
            Service.deleteTaks(withUid: task.uid) { error in
                if let error = error {
                    print("error while deleting task \(error.localizedDescription)")
                    return
                }
                self.tasks.removeAll()
                self.fetchTasks()
    }
}
    
    func cell(_ cell: TaskCell, wantToMarkTaskCompleted task: Task) {
        var completionStatus = task.isCompleted
        completionStatus.toggle()
        
        showLoader(true)
        Service.changeCompletionStatus(forTaskId: task.uid, completionStatus: completionStatus)
        cell.task?.isCompleted = completionStatus
        showLoader(false)
    }
}
