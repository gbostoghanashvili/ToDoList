//
//  ViewController.swift
//  ToDoList
//
//  Created by Giorgi on 2/4/21.
//

import UIKit
import Firebase

protocol TasksControllerDelegate: class {
    func handleMenuToggle()
}

class TasksController: UIViewController {
    
    //MARK: - Properties
    
    weak var delegate: TasksControllerDelegate?
    private lazy var tasksView = TasksView(frame: CGRect(x: 0, y: 0,
                                                         width: view.frame.width, height: view.frame.height))

    private lazy var tableView = tasksView.tableView

     var tasks = [Task]() {
        didSet {self.tableView.reloadData()}
    }

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dismissKeyboard()
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
    
        view.addSubview(tasksView)
        tasksView.delegate = self
        navigationController?.navigationBar.isHidden = true
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: false)
        }

        tasksView.addTaskTextfield.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        fetchTasks()
        configureRefresher()
    }
    
    func configureRefresher() {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
    }
    
    func presentLoginController() {
        let controller = LoginController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        tasks.removeAll()


        present(nav, animated: true)
    }
  
    //MARK: - Actions
    
    @objc func handleRefresh() {
        tasks.removeAll()
        fetchTasks()
        }
    }

//MARK: - TableViewDataSource

extension TasksController: UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tasksCellId, for: indexPath) as! TaskCell
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
        let controller = EditController(field: .task, text: task.title, taskID: task.uid)
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
        tasksView.characterCountLabel.text = "0/50"
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

//MARK: - TasksViewDelegate

extension TasksController: TasksViewDelegate {
    func showSideMenu() {
        guard let delegate = self.delegate else {return}
        delegate.handleMenuToggle()
        }
    
    func textDidChange(_ textfield: UITextField, label: UILabel) {
        
        checkMaxLength(textfield)
        guard let count = textfield.text?.count else {return}
        label.text = "\(count)/50"
        }
    }
    
    

