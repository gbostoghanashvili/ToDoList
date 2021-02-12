//
//  MenuController.swift
//  ToDoList
//
//  Created by Giorgi on 2/8/21.
//

import UIKit

protocol MenuControllerDelegate: class {
    func didSelect(option: MenuOptions)
}

class MenuController: UITableViewController {
    
    //MARK: - Properties
    
    private let cellId = "MenuCell"
    
    weak var delegate: MenuControllerDelegate?

    private lazy var menuHeader = MenuHeader(frame: CGRect(x: 0, y: 0,
                                                           width: self.view.frame.width,
                                                           height: 140))
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
    }
    
    //MARK: - API
    
    func fetchUser(){
        Service.fetchUser { user in
            self.menuHeader.user = user
        }
    }
    
    //MARK: - Helpers
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 60
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.tableHeaderView = menuHeader
    }
}

// MARK: - UITableViewDelegate

extension MenuController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let option = MenuOptions(rawValue: indexPath.row) else { return }
        delegate?.didSelect(option: option)
    }
}

// MARK: - UITableView DataSource

extension MenuController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        guard let option = MenuOptions(rawValue: indexPath.row) else { return UITableViewCell() }
        cell.textLabel?.text = option.description
        
        return cell
    }
}
