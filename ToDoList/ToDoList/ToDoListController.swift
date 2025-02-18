//
//  ToDoListController.swift
//  ToDoList
//
//  Created by Chichek on 03.12.24.
//

import UIKit
import Alamofire
class ToDoListController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { _ in
              //  print("Edit task \(self.viewModel.toDoList[indexPath.row])")
            }
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
             //   print("Delete task \(self.viewModel.toDoList[indexPath.row])")
              //  self.viewModel.deleteTodoFromCoreData(self.viewModel.toDoList[indexPath.row])
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
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

    

 
    
    @IBOutlet var tableView: UITableView!
    var viewModel = ToDoListViewModel()
     override func viewDidLoad() {
            super.viewDidLoad()

         tableView.dataSource = self
         tableView.delegate = self
         tableView.allowsSelection = true
         tableView.allowsMultipleSelection = false


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
            // Загружаем задачи
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
     @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
         let point = gestureRecognizer.location(in: tableView)
         if let indexPath = tableView.indexPathForRow(at: point) {
             print("Long press on row: \(indexPath.row)")
             // Вызываем контекстное меню
             tableView.delegate?.tableView?(tableView, contextMenuConfigurationForRowAt: indexPath, point: point)
         }}
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
                cell.configure(with: viewModel.toDoList[indexPath.row])
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
                print("Удаление задачи: \(todo.todo)")
                viewModel.deleteTodoFromCoreData(todo)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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

