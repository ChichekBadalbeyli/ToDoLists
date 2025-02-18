//
//  ToDoListViewModel.swift
//  ToDoList
//
//  Created by Chichek on 04.12.24.
//

import Foundation

class ToDoListViewModel {
    var toDoList = [Todo]()
    var toDoListManager = ToDoListManager()
    var success: (() -> Void)?
    var error: ((String) -> Void)?

    func getAndSaveTodos() {
        toDoListManager.fetchToDoList(endpoint: .toDoListEndpoint) { data, errorMessage in
            if let errorMessage = errorMessage {
                self.error?(errorMessage)
            } else if let data = data {
                ToDoCoreDataManager.shared.mergeToDos(apiToDos: data.todos)
                self.fetchToDos {
                    self.success?()  // Обновление UI на главном потоке
                }
            }
        }
    }

    func fetchToDos(completion: @escaping () -> Void) {
        self.toDoList = ToDoCoreDataManager.shared.loadToDos()
        DispatchQueue.main.async {
            completion()
        }
        print("Fetching todos, current count: \(toDoList.count)")
    }

    func addTodoToCoreData(_ newTodo: Todo) {
        ToDoCoreDataManager.shared.saveToDo(newTodo)
        fetchToDos {
            self.success?() // Обновление UI после загрузки данных
        }
    }

    func updateTodoInCoreData(_ updatedTodo: Todo) {
        ToDoCoreDataManager.shared.updateToDoInCoreData(updatedTodo)
        fetchToDos {
            self.success?() // Обновление UI после загрузки данных
        }
    }

    func deleteTodoFromCoreData(_ todo: Todo) {
        ToDoCoreDataManager.shared.deleteToDo(todo)
        fetchToDos {
            self.success?() // Обновление UI после загрузки данных
        }
    }
}
