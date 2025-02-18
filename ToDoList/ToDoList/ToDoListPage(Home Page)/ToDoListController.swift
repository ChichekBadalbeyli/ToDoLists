//
//  ToDoListController.swift
//  ToDoList
//
//  Created by Chichek on 03.12.24.
//

import UIKit
import Alamofire
class ToDoListController: UIViewController{
    
    var tableView = UITableView()
    var headLabel: UILabel = {
        var heading = UILabel()
        heading.text = "Задачи"
        heading.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        heading.textColor = .white
        return heading
    }()
    
    func configureUI() {
        view.addSubview(headLabel)
        headLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureConstraints() {
        
        headLabel.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            bottom: tableView.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            constraint: (top: 10, bottom: 62, leading: 20, trailing: 20)
        )
        
        tableView.anchor(
            top: headLabel.bottomAnchor,
            bottom: view.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            constraint: (top: 10, bottom: 0, leading: 20, trailing: 20)
            
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
    var viewModel = ToDoListViewModel()
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
         tableView.gestureRecognizers?.forEach { recognizer in
             print("Gesture: \(recognizer)")
         }
         viewModel.fetchToDos { [weak self] in
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }

                viewModel.getAndSaveTodos()
         let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
            tableView.addGestureRecognizer(longPressGesture)
         tableView.addInteraction(UIContextMenuInteraction(delegate: self))
            }

}


extension ToDoListController: UITableViewDelegate, UITableViewDataSource,UIContextMenuInteractionDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let interaction = UIContextMenuInteraction(delegate: self)
        cell.addInteraction(interaction)
    }

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = tableView.indexPathForRow(at: location) else {
            return nil
        }

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { _ in
                self.navigateToEditScreen(with: self.viewModel.toDoList[indexPath.row])
            }

            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.deleteTask(self.viewModel.toDoList[indexPath.row])
            }

            return UIMenu(title: "", children: [editAction, deleteAction])
        }
    }


        // Методы делегата для анимации меню
        func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformWithAnimator animator: UIContextMenuInteractionAnimating?) {
            print("Context Menu is about to appear.")
        }

        func contextMenuInteraction(_ interaction: UIContextMenuInteraction, didEndAnimatingWithAnimator animator: UIContextMenuInteractionAnimating?) {
            print("Context Menu has ended.")
        }

    

    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        let point = gestureRecognizer.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            print("Long press on row: \(indexPath.row)")
            // Вызываем контекстное меню
            tableView.delegate?.tableView?(tableView, contextMenuConfigurationForRowAt: indexPath, point: point)
        }
    }
     func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
         return true
     }


     func tableView(_ tableView: UITableView, canHandleMenuActionAt indexPath: IndexPath) -> Bool {
         return true
     }
//     func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//         print("contextMenuConfigurationForRowAt called for row \(indexPath.row)")
//         return nil
//     }


            // MARK: - UITableView DataSource & Delegate

            func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                return 100
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

            // MARK: - Context Menu Configuration

//     func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//         print("contextMenuConfigurationForRowAt called for row \(indexPath.row)")
//         tableView.reloadData()
//         return UIContextMenuConfiguration(
//             identifier: nil,
//             previewProvider: nil
//         ) { _ in
//             let editAction = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { _ in
//               //  print("Edit \(self.todos[indexPath.row])")
//             }
//             let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
//                 //print("Delete \(self.todos[indexPath.row])")
//             }
//             return UIMenu(title: "", children: [editAction, deleteAction])
//         }
//     }

            // Действия для редактирования и удаления
            func navigateToEditScreen(with todo: Todo) {
                print("Переход на экран редактирования для задачи: \(todo.todo)")
                // Реализуйте переход на экран редактирования
            }

    func deleteTask(_ todo: Todo) {
        viewModel.deleteTodoFromCoreData(todo)
        viewModel.fetchToDos {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    
        
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            viewModel.toDoList.count
//        }
//        
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath) as! ToDoListCell
//            cell.configure(with: viewModel.toDoList[indexPath.row])
//            cell.backgroundColor = .black
//            cell.tintColor = .white
//            return cell
//        }
//        
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            let selectedTodo = viewModel.toDoList[indexPath.row]
//            let coordinator = ToDoListCoordinator(navigator: self.navigationController ?? UINavigationController())
//            
//            coordinator.start(
//                onAddNewTodo: { [weak self] newToDo in
//                    self?.viewModel.addTodoToCoreData(newToDo)
//                },
//                toDoList: selectedTodo, // Передаем выбранную задачу для редактирования
//                onEditTodo: { [weak self] updatedTodo in
//                    self?.viewModel.updateTodoInCoreData(updatedTodo) // Обновляем задачу в Core Data
//                }
//            )
//        }
        
        
    @IBAction func newActionButton(_ sender: Any) {
        let coordinator = ToDoListCoordinator(navigator: self.navigationController ?? UINavigationController())
            coordinator.start(
                onAddNewTodo: { [weak self] newToDo in
                    self?.viewModel.addTodoToCoreData(newToDo)
                    DispatchQueue.main.async {
                        self?.tableView.reloadData() // Обновляем таблицу после добавления нового задания
                    }
                },
                toDoList: nil,
                onEditTodo: { _ in } // Пустое замыкание для редактирования
            )
    }
        
    }

