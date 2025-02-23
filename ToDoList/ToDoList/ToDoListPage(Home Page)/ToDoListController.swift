//
//  ToDoListController.swift
//  ToDoList
//
//  Created by Chichek on 18.02.25.
//

import UIKit
import Alamofire

class ToDoListController: ExtensionCofigureController  {
    
    var viewModel = ToDoListViewModel()
    
    var topSafeArea: UIView = {
        let topView = UIView()
        topView.backgroundColor = .black
        return topView
    }()
    
    var bottomSafeArea: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = .gray
        return bottomView
    }()
    
    var tableView: UITableView = {
        let table = UITableView()
        table.separatorColor = .gray
        table.separatorStyle = .singleLine
        return table
    }()
    
    var headLabel: UILabel = {
        let heading = UILabel()
        heading.text = "Задачи"
        heading.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        heading.textColor = .white
        return heading
    }()
    
    var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search"
        search.layer.cornerRadius = 10
        search.barTintColor = .gray
        search.clipsToBounds = true
        
        if let textField = search.value(forKey: "searchField") as? UITextField {
            let micButton = UIButton(type: .system)
            micButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
            micButton.tintColor = .white
            micButton.addTarget(self, action: #selector(micButtonTapped), for: .touchUpInside)
            
            textField.rightView = micButton
            textField.rightViewMode = .always
        }
        
        return search
    }()
    
    var microphone: UIButton = {
        let microphoneButton = UIButton()
        return microphoneButton
    }()
    
    var footerCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        return label
    }()
    var addTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "NewActionButton"), for: .normal)
        button.tintColor = .yellow
        button.addTarget(self, action: #selector(addTaskTapped), for: .touchUpInside)
        return button
    }()
    
    var footer: UIView = {
        let footer = UIView()
        footer.backgroundColor = .gray
        return footer
    }()
    
    override func configureUI() {
        view.addSubview(topSafeArea)
        view.addSubview(bottomSafeArea)
        view.addSubview(headLabel)
        view.addSubview(tableView)
        view.addSubview(searchBar)
        view.addSubview(footer)
        footer.addSubview(footerCountLabel)
        footer.addSubview(addTaskButton)
        
        topSafeArea.translatesAutoresizingMaskIntoConstraints = false
        bottomSafeArea.translatesAutoresizingMaskIntoConstraints = false
        headLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        footer.translatesAutoresizingMaskIntoConstraints = false
        footerCountLabel.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func configureConstraints() {
        topSafeArea.anchor(
            top: view.topAnchor,
            bottom: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            constraint: (top: 0, bottom: 0, leading: 0, trailing: 0)
        )
        
        bottomSafeArea.anchor(
            top: footer.bottomAnchor,
            bottom: view.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            constraint: (top: 0, bottom: 0, leading: 0, trailing: 0)
        )
        
        headLabel.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            bottom: searchBar.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            constraint: (top: 15, bottom: 10, leading: 20, trailing: 20)
        )
        
        searchBar.anchor(
            top: headLabel.bottomAnchor,
            bottom: tableView.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            constraint: (top: 10, bottom: 16, leading: 20, trailing: 20),
            height: 36
            
        )
        
        tableView.anchor(
            top: searchBar.bottomAnchor,
            bottom: footer.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            constraint: (top: 16, bottom: 0, leading: 20, trailing: 20)
            
        )
        
        footer.anchor(
            top: tableView.bottomAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            constraint: (top: 0, bottom: 0, leading: 0, trailing: 0)
            
        )
        
        footerCountLabel.anchor(
            top: footer.topAnchor,
            bottom: footer.bottomAnchor,
            leading: footer.leadingAnchor,
            trailing: addTaskButton.leadingAnchor,
            constraint: (top: 20.5, bottom: 15.5, leading: 158, trailing: 92)
        )
        addTaskButton.anchor(
            top: footer.topAnchor,
            bottom: footer.bottomAnchor,
            leading: footerCountLabel.trailingAnchor,
            trailing: nil,
            constraint: (top: 13, bottom: 8, leading: 92,trailing:0),
            width: 68,
            height: 28
        )
        
    }
    
    override func configureTableView() {
        tableView.register(ToDoListCell.self, forCellReuseIdentifier: "ToDoListCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 106
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        if viewModel.toDoList.isEmpty {
            viewModel.getAndSaveTodos()
        } else {
            tableView.reloadData()
        }
        
        viewModel.success = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        searchBar.delegate = self
        configureCountLabelText()
    }
    
    private func configureCountLabelText() {
        viewModel.success = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.footerCountLabel.text = "\(self?.viewModel.toDoList.count ?? 0) Задач"
            }
        }
        viewModel.error = { errorMessage in
            print(" \(errorMessage)")
        }
    }
    
    @objc func addTaskTapped() {
        let coordinator = ToDoListCoordinator(navigator: self.navigationController ?? UINavigationController())

        coordinator.start(onAddNewTodo: { [weak self] newTodo in
            guard let self = self else { return }
            
            if self.viewModel.toDoList.contains(where: { $0.todo == newTodo.todo }) {
                return
            }
            
            self.viewModel.addNewTodo(title: newTodo.todo, description: "")
            self.viewModel.toDoList = self.viewModel.convertToDoEntitiesToTodos(CoreDataManager.shared.loadToDos())

            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.footerCountLabel.text = "\(self.viewModel.toDoList.count) Задач"
            }
        }, toDoList: nil)
    }

    @objc func micButtonTapped() {
        
    }
}

extension ToDoListController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in
                self.editItem(at: indexPath)
            }
            let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                self.shareItem(at: indexPath)
            }
            let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.deleteItem(at: indexPath)
            }
            return UIMenu(title: "Действия", children: [editAction, shareAction, deleteAction])
        }
    }
    
    func editItem(at indexPath: IndexPath) {
        let isSearchActive = viewModel.isSearching
        let selectedTodo = isSearchActive ? viewModel.filteredToDoList[indexPath.row] : viewModel.toDoList[indexPath.row]
        
        let coordinator = ToDoListCoordinator(navigator: self.navigationController ?? UINavigationController())

        coordinator.start(onAddNewTodo: { [weak self] updatedTodo in
            guard let self = self else { return }

            if let index = self.viewModel.toDoList.firstIndex(where: { $0.id == updatedTodo.id }) {
                self.viewModel.toDoList[index] = updatedTodo
            }

            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }, toDoList: selectedTodo)
    }
    
    func shareItem(at indexPath: IndexPath) {
        let todo = viewModel.toDoList[indexPath.row]
        let activityVC = UIActivityViewController(activityItems: [todo.todo], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    private func updateFooterCount() {
        footerCountLabel.text = "\(viewModel.toDoList.count) Задач"
    }
    
    func deleteItem(at indexPath: IndexPath) {
        let isSearchActive = viewModel.isSearching
        let todo = isSearchActive ? viewModel.filteredToDoList[indexPath.row] : viewModel.toDoList[indexPath.row]
        
        viewModel.deleteTodoFromCoreData(todo)
        
        DispatchQueue.main.async {
            if isSearchActive {
                self.viewModel.filteredToDoList.remove(at: indexPath.row)
            }
            self.viewModel.toDoList = self.viewModel.convertToDoEntitiesToTodos(CoreDataManager.shared.loadToDos())
            
            if isSearchActive {
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                self.tableView.reloadData()
            }
            
            self.updateFooterCount()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.isSearching ? viewModel.filteredToDoList.count : viewModel.toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath) as! ToDoListCell
        
        let isSearchActive = viewModel.isSearching
        let dataSource = isSearchActive ? viewModel.filteredToDoList : viewModel.toDoList
        let todo = dataSource[indexPath.row]
        cell.configure(with: todo) { [weak self] todoID, isCompleted in
            guard let self = self else { return }
            
            
            self.viewModel.toggleCompletionStatus(for: todoID, isCompleted: isCompleted)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                
                if isSearchActive {
                    self.viewModel.searchTodos(query: self.viewModel.searchQuery)
                    cell.isUserInteractionEnabled = true
                    cell.contentView.isUserInteractionEnabled = true
                    
                    self.tableView.reloadData()
                } else {
                    if let originalIndex = self.viewModel.toDoList.firstIndex(where: { $0.id == todoID }) {
                        let originalIndexPath = IndexPath(row: originalIndex, section: 0)
                        self.tableView.reloadRows(at: [originalIndexPath], with: .automatic)
                    } else {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        cell.backgroundColor = .black
        cell.selectionStyle = .none
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchTodos(query: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
