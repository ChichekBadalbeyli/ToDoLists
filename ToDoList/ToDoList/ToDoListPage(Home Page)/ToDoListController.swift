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
    
    var topSafeArea: UIView = {
       var topView = UIView()
        topView.backgroundColor = .black
        return topView
    }()
    
    var bottomSafeArea: UIView = {
       var bottomView = UIView()
        bottomView.backgroundColor = .gray
      
        return bottomView
    }()
    
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
        search.clipsToBounds = true
        return search
    }()
    
    //    var searchBar: UISearchBar = {
    //        var search = UISearchBar()
    //        search.layer.cornerRadius = 10
    //        search.barTintColor = .gray
    //        search.clipsToBounds = true
    //
    //        let microphoneButton = UIButton(type: .custom)
    //        microphoneButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
    //        microphoneButton.tintColor = .white
    //        microphoneButton.addTarget(self, action: #selector(microphoneTapped), for: .touchUpInside)
    //
    //        // Adding the microphone button to the search bar
    //        search.addSubview(microphoneButton)
    //
    //        // Setting up constraints for the microphone button
    //        microphoneButton.translatesAutoresizingMaskIntoConstraints = false
    //        NSLayoutConstraint.activate([
    //            microphoneButton.trailingAnchor.constraint(equalTo: search.trailingAnchor, constant: -10),
    //            microphoneButton.centerYAnchor.constraint(equalTo: search.centerYAnchor)
    //        ])
    //
    //        return search
    //    }()
    
    var footerCountLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        return label
    }()
    var footer: UIView = {
        var footer = UIView()
        footer.backgroundColor = .gray
        return footer
    }()
    
    @objc func microphoneTapped() {
        
    }
    
    
    func configureUI() {
        view.addSubview(topSafeArea)
        topSafeArea.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomSafeArea)
        bottomSafeArea.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headLabel)
        headLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(footer)
        footer.translatesAutoresizingMaskIntoConstraints = false
        footer.addSubview(footerCountLabel)
        footerCountLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureConstraints() {
        topSafeArea.anchor(
            top: view.topAnchor,
            bottom: view.safeAreaLayoutGuide.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            constraint: (top: 0, bottom: 0, leading: 0, trailing: 0)
        )
        
        bottomSafeArea.anchor(
            top: footer.bottomAnchor,
            bottom: tableView.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            constraint: (top: 0, bottom: -60, leading: 0, trailing: 0)
        )
        
        
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
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            constraint: (top: 16, bottom: -60, leading: 20, trailing: 20)
        )
        
        footer.anchor(
            top: tableView.bottomAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            constraint: (top: 94, bottom: 0, leading: 0, trailing: 0)
        )
        
        footerCountLabel.anchor(
            top: footer.topAnchor,
            bottom: footer.bottomAnchor,
            leading: footer.leadingAnchor,
            trailing: footer.trailingAnchor,
            constraint: (top: 20.5, bottom: 15.5, leading: 158, trailing: 158)
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
                    self?.tableView.reloadData() // ✅ Verileri güncelle
                }
            }

            viewModel.error = { error in
                print("Error: \(error)")
            }

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
    
//    func editItem(at indexPath: IndexPath) {
//        var selectedTodo = viewModel.toDoList[indexPath.row]
//        
//        let actionController = ActionViewController()
//        navigationController?.pushViewController(actionController, animated: true)
        
//        let actionController = ActionViewController()
//
//        // Передаем ToDoEntity в ActionViewController
//        if let todoEntity = CoreDataManager.shared.loadToDos().first(where: { $0.id == Int64(selectedTodo.id) }) {
//            actionController.todoEntity = todoEntity
//        }
//
//        actionController.completionHandler = { [weak self] updatedTodoEntity in
//            // Передаем обратно объект ToDoEntity
//            CoreDataManager.shared.updateTodoInCoreData(updatedTodoEntity)
//
//            // Обновляем отображаемую задачу
//            selectedTodo.todo = updatedTodoEntity.todo ?? ""
//            selectedTodo.descriptionText = updatedTodoEntity.descriptionText ?? ""
//            selectedTodo.createdDate = updatedTodoEntity.createdDate ?? Date()
//
//            self?.viewModel.toDoList[indexPath.row] = selectedTodo
//
//            DispatchQueue.main.async {
//                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
//            }
//        }

   //     navigationController?.pushViewController(actionController, animated: true)
        
        
   // }



    func editItem(at indexPath: IndexPath) {
        let selectedTodo = viewModel.toDoList[indexPath.row]

        let actionController = ToDoActionController()
        actionController.todo = selectedTodo

        // ✅ Güncelleme tamamlandığında CoreData’dan açıklama ve tarih al
        actionController.completionHandler = { [weak self] updatedTodo in
            guard let self = self else { return }

            // ✅ CoreData’dan ilgili `ToDoEntity`'yi bul ve verileri çek
            if let todoEntity = CoreDataManager.shared.loadToDos().first(where: { $0.id == updatedTodo.id }) {
                let description = todoEntity.descriptionText ?? "" // CoreData'dan gelen açıklama
                let createdDate = todoEntity.createdDate ?? Date() // CoreData'dan gelen tarih

                self.viewModel.updateTodoInCoreData(updatedTodo, description: description, createdDate: createdDate)
            }

            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }

        navigationController?.pushViewController(actionController, animated: true)
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
//        let coordinator = ToDoListCoordinator(navigator: self.navigationController ?? UINavigationController())
//        coordinator.start(
//            onAddNewTodo: { [weak self] newToDo in
//                
//                DispatchQueue.main.async {
//                    self?.tableView.reloadData()
//                }
//            },
//            toDoList: nil,
//            onEditTodo: { _ in }
//        )
    }
    
}

