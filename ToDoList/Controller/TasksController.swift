//
//  ViewController.swift
//  ToDoList
//
//  Created by Giorgi on 2/4/21.
//

import UIKit

class TasksController: UIViewController {
    
    private let tableView = UITableView()
    
    private let addTaskTextfield = CustomTextField(placeholder: "Add task")
    
    private var tasks = [Task]()
    
    //MARK: - Properties
    
    private let cellId = "TasksCell"
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    //MARK: - Helper Methods
    
    func configureUi() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        view.addSubview(addTaskTextfield)
        addTaskTextfield.centerX(inView: view)
        addTaskTextfield.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                                paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        addTaskTextfield.delegate = self
        
        configureTableView()
        
        }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.anchor(top: addTaskTextfield.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,  paddingTop: 16)
        
        tableView.register(TaskCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = true
        
        tableView.rowHeight = 80
//        tableView.estimatedRowHeight = 600
        
        tableView.tableFooterView = UIView()
        
    }
    
    //MARK: - Actions

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


//MARK: - Textfield Delegate

extension TasksController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let title = textField.text!
        let uuid = NSUUID().uuidString
        
        let task = Task(title: title, uid: uuid)
        tasks.insert(task, at: 0)
        tableView.reloadData()
        
        textField.text = nil
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard range.location == 0 else {
                return true
            }
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
            return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }
}

//MARK: - TaskCellDelegate

extension TasksController: TaskCellDelegate {
    
    func cell(_ cell: TaskCell, wantsToDeleteTask task: Task) {
        if let index = tasks.firstIndex(where: { $0.uid == task.uid}) {
            tasks.remove(at: index)
            tableView.reloadData()
        }
    }
    
    func cell(_ cell: TaskCell, wantToMarkTaskCompleted task: Task) {
        cell.task?.isCompleted.toggle()
    }
}
