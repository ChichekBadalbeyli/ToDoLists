//
//  ToDoListViewModel.swift
//  ToDoList
//
//  Created by Chichek on 04.12.24.
//

//import Foundation

//class ToDoListViewModel {
//    var toDoList = [Todo]()
//    var toDoListManager = ToDoListManager()
//    var success: (() -> Void)?
//    var error: ((String) -> Void)?
//
//    func getAndSaveTodos() {
//        toDoListManager.fetchToDoList(endpoint: .toDoListEndpoint) { data, errorMessage in
//            if let errorMessage = errorMessage {
//                self.error?(errorMessage)
//            } else if let data = data {
//                ToDoCoreDataManager.shared.mergeToDos(apiToDos: data.todos)
//                self.fetchToDos {
//                    self.success?()  
//                }
//            }
//        }
//    }
//
//    func fetchToDos(completion: @escaping () -> Void) {
//        self.toDoList = ToDoCoreDataManager.shared.loadToDos()
//        print("Loaded ToDos: \(self.toDoList)") // Это должно вывести все задачи, включая описание
//        DispatchQueue.main.async {
//            completion()
//        }
//    }
//
//
//    func addTodoToCoreData(_ newTodo: Todo) {
//        ToDoCoreDataManager.shared.saveToDo(newTodo)
//        fetchToDos {
//            self.success?()
//        }
//    }
//
//    func updateTodoInCoreData(_ updatedTodo: Todo) {
//        ToDoCoreDataManager.shared.updateToDoInCoreData(updatedTodo)
//        fetchToDos {
//            self.success?()
//        }
//    }
//
//    func deleteTodoFromCoreData(_ todo: Todo) {
//        ToDoCoreDataManager.shared.deleteToDo(todo)
//        fetchToDos {
//            self.success?()
//        }
//    }
//}
import Foundation
import CoreData

//import Foundation
//import CoreData

//class ToDoListViewModel {
//    var toDoList = [Todo]()
//    var toDoListManager = ToDoListManager()
//    var success: (() -> Void)?
//    var error: ((String) -> Void)?
//
//    // Получаем задачи из API и сохраняем их в CoreData
//    func getAndSaveTodos() {
//        toDoListManager.fetchToDoList(endpoint: .toDoListEndpoint) { [weak self] data, errorMessage in
//            guard let self = self else { return }
//            
//            if let errorMessage = errorMessage {
//                self.error?(errorMessage)
//                return
//            }
//            
//            guard let data = data, !data.todos.isEmpty else {
//                print("API вернул пустой список задач или nil")
//                return
//            }
//            
//            ToDoCoreDataManager.shared.mergeToDos(apiToDos: data.todos)
//            self.toDoList = ToDoCoreDataManager.shared.loadToDos()
//            
//            DispatchQueue.main.async {
//                self.success?()
//            }
//        }
//    }
//
//    // Загружаем задачи из CoreData
//    func fetchToDos(completion: (() -> Void)? = nil) {
//        toDoList = ToDoCoreDataManager.shared.loadToDos()
//        print("Loaded ToDos: \(toDoList)")
//        
//        DispatchQueue.main.async {
//            completion?()
//            self.success?()
//        }
//    }
//
//    // Добавляем новую задачу
//    func addTodoToCoreData(_ newTodo: Todo) {
//        ToDoCoreDataManager.shared.saveToDo(newTodo)
//        fetchToDos()
//    }
//
//    // Обновляем задачу
//    func updateTodoInCoreData(_ updatedTodo: Todo) {
//        ToDoCoreDataManager.shared.updateToDoInCoreData(updatedTodo)
//        fetchToDos()
//    }
//
//    // Удаляем задачу
////// Удаляем задачу из CoreData
//    func deleteTodoFromCoreData(_ todo: Todo) {
//        let context = CoreDataManager.shared.context
//        let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %d", todo.id)
//
//        do {
//            let results = try context.fetch(fetchRequest)
//            if let todoEntity = results.first {
//                context.delete(todoEntity) // Удаляем задачу
//                try context.save()
//            }
//        } catch {
//            print("Failed to delete todo: \(error)")
//        }
//
//        // Загружаем обновленный список задач
//        fetchToDos()
//    }
//
//
//    // Загрузка задач из CoreData с правильным контекстом
//    // Загрузка задач из CoreData с правильным контекстом
//    // Загрузка задач из CoreData с правильным контекстом и сортировкой
//    func loadToDos() {
//        let context = CoreDataManager.shared.context // Используем контекст из CoreDataManager
//        let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
//        
//        // Добавляем сортировку по ID или дате (в зависимости от вашего случая)
//        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true) // Сортировка по ID, по возрастанию
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        
//        do {
//            let results = try context.fetch(fetchRequest)
//            let updatedToDos = results.map { result in
//                Todo(
//                    id: Int(result.id),
//                    todo: result.todo ?? "",
//                    completed: result.completed,
//                    userID: Int(result.userId)
//                )
//            }
//            
//            // Обновляем список задач в модели
//            self.toDoList = updatedToDos
//            
//        } catch {
//            print("Failed to fetch todos: \(error)")
//        }
//    }
//
//
//}

class ToDoListViewModel {
    var toDoListManager = ToDoListManager()
    var toDoList = [Todo]()
    var success: (() -> Void)?
    var error: ((String) -> Void)?

    func getAndSaveTodos() {
        toDoListManager.fetchToDoList(endpoint: .toDoListEndpoint) { [weak self] data, errorMessage in
            guard let self = self else { return }

            if let errorMessage = errorMessage {
                self.error?(errorMessage)
                return
            }

            guard let data = data, !data.todos.isEmpty else {
                return
            }

            CoreDataManager.shared.mergeToDos(apiToDos: data.todos)

            self.toDoList = self.convertToDoEntitiesToTodos(CoreDataManager.shared.loadToDos())

            DispatchQueue.main.async {
                self.success?()
            }
        }
    }

    private func convertToDoEntitiesToTodos(_ entities: [ToDoEntity]) -> [Todo] {
        return entities.map { entity in
            return Todo(id: Int(entity.id), todo: entity.todo ?? "", completed: entity.completed, userID: Int(entity.userId))
        }
    }


    func deleteTodoFromCoreData(_ todo: Todo) {
        if let todoEntity = CoreDataManager.shared.loadToDos().first(where: { $0.id == Int64(todo.id) }) {
            CoreDataManager.shared.deleteToDoEntity(todoEntity)
        }
    }
}
