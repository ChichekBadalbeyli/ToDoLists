//
//  ActionViewController.swift
//  ToDoList
//
//  Created by Chichek on 05.12.24.
//

import UIKit
import Alamofire

class ActionViewController: UIViewController {
    
    @IBOutlet var actionName: UITextField!
    
    @IBOutlet var actionDefiniition: UITextField!
    
    @IBOutlet var date: UILabel!
   // var viewModel = ToDoListViewModel(context: <#NSManagedObjectContext#>)
        var addNewToDo: ((Todo) -> Void)?
        var toDoList: Todo? // Опциональное значение
        var editAction: ((Todo) -> Void)?

    override func viewDidLoad() {
          super.viewDidLoad()

          guard let toDo = toDoList else {
              actionName.text = ""
              actionDefiniition.text = ""
              print("No todo to edit.")
              return
          }
          
          // Если toDoList существует, безопасно извлекаем его свойства
          actionName.text = toDo.todo
         // actionDefiniition.text = toDo.description
      }

      override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
          
          guard let todoText = actionName.text, !todoText.isEmpty,
                let definition = actionDefiniition.text, !definition.isEmpty else {
              print("Fields are empty, skipping todo update.")
              return
          }
          
          // Создаем новый объект Todo с безопасным извлечением значений
//          let updatedTodo = Todo(
//              id: toDoList?.id ?? UUID().hashValue, // Если id нет, генерируем новый
//              todo: todoText,
//              completed: toDoList?.completed ?? false, // Если completed нет, по умолчанию false
//              userID: toDoList?.userID ?? 1, // Если userID нет, по умолчанию 1
//              createdDate: toDoList?.createdDate ?? Date(), // Если дата нет, используем текущую
//              description: definition
//          )
          
          // Передаем обновленный объект в замыкание
        //  editAction?(updatedTodo)
      }
  }
