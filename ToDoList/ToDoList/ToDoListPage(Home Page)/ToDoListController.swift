//
//  ToDoListController.swift
//  ToDoList
//
//  Created by Chichek on 03.12.24.
//

import UIKit
import Alamofire
class ToDoListController: UIViewController{
    
    var viewModel = ToDoListViewModel()
    
    var tableView: UITableView = {
        var table = UITableView()
        table.separatorColor = .gray
        table.separatorStyle = .singleLine
        return table
        }()
    
    var headLabel: UILabel = {
        var heading = UILabel()
        heading.text = "Задачи"
        heading.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        heading.textColor = .white
        return heading
    }()
    
    var searchBar: UISearchBar = {
       var search = UISearchBar()
        search.layer.cornerRadius = 10
        search.barTintColor = .gray
    //    search.layer.borderColor = UIColor.black.cgColor
        search.clipsToBounds = true
        return search
    }()
    
    func configureUI() {
        view.addSubview(headLabel)
        headLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureConstraints() {
        headLabel.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            bottom: searchBar.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            constraint: (top: 10, bottom: 10, leading: 20, trailing: 20)
        )
        
        searchBar.anchor(
            top: headLabel.bottomAnchor,
            bottom: tableView.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            constraint: (top: 10, bottom: 16, leading: 20, trailing: 20),
            width: 320,
            height: 36
        )
        
        tableView.anchor(
            top: searchBar.bottomAnchor,
            bottom: view.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            constraint: (top: 16, bottom: -60, leading: 20, trailing: 20)
            
        )
        
    }
    
    func configureTableView() {
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
        configureUI()
        configureConstraints()
        configureTableView()
        
        viewModel.success = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.error = { error in
            print("Error: \(error)")
        }
//        tableView.gestureRecognizers?.forEach { recognizer in
//            print("Gesture: \(recognizer)")
//        }
//        viewModel.fetchToDos { [weak self] in
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//            }
//        }
        
        viewModel.getAndSaveTodos()
    }
    
}


extension ToDoListController: UITableViewDelegate, UITableViewDataSource {
    
    
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
        let todo = viewModel.toDoList[indexPath.row]
        print("Редактируем задачу: \(todo.todo)")
        navigateToEditScreen(with: todo)
    }
    
    func shareItem(at indexPath: IndexPath) {
        let todo = viewModel.toDoList[indexPath.row]
        let activityVC = UIActivityViewController(activityItems: [todo.todo], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    func deleteItem(at indexPath: IndexPath) {
        let todo = viewModel.toDoList[indexPath.row]
        viewModel.deleteTodoFromCoreData(todo)
        viewModel.toDoList.remove(at: indexPath.row)
        DispatchQueue.main.async {
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath) as! ToDoListCell
        let todo = viewModel.toDoList[indexPath.row]
        cell.configure(with: todo)
        cell.backgroundColor = .black
        cell.selectionStyle = .none
        return cell
    }
    
    func navigateToEditScreen(with todo: Todo) {
        print("Переход на экран редактирования для задачи: \(todo.todo)")
 
    }
    
    @IBAction func newActionButton(_ sender: Any) {
        let coordinator = ToDoListCoordinator(navigator: self.navigationController ?? UINavigationController())
        coordinator.start(
            onAddNewTodo: { [weak self] newToDo in

                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            },
            toDoList: nil,
            onEditTodo: { _ in }
        )
    }
    
}

