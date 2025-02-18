//
//  ToDoCoreDataManager.swift
//  ToDoList
//
//  Created by Chichek on 06.12.24.
//


import Foundation
import CoreData

class ToDoCoreDataManager {
    
    static let shared = ToDoCoreDataManager()
    
    let context = CoreDataManager.shared.context
    
    func saveToDo(_ todo: Todo) {
        if let entity = NSEntityDescription.entity(forEntityName: "Entity", in: context) {
            let newToDo = NSManagedObject(entity: entity, insertInto: context)
            
            newToDo.setValue(todo.id, forKey: "id")
            newToDo.setValue(todo.todo, forKey: "todo")
            newToDo.setValue(todo.completed, forKey: "completed")
            newToDo.setValue(todo.userID, forKey: "userId")
            newToDo.setValue(todo.createdDate, forKey: "createdDate")
            newToDo.setValue(todo.description, forKey: "descriptionText")
            
            CoreDataManager.shared.saveContext()
            print("Todo saved: \(todo.todo)")
        } else {
            print("Failed to create entity for Todo.")
        }
    }

    
    func updateToDoInCoreData(_ updatedTodo: Todo) {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Entity")
        fetchRequest.predicate = NSPredicate(format: "id == %d", updatedTodo.id)
        
        do {
            let results = try context.fetch(fetchRequest)
            print("Fetched results: \(results)") // Добавьте вывод результатов
            if let objectToUpdate = results.first {
                print("Updating Todo with id: \(updatedTodo.id)") // Подтвердите, что объект найден
                objectToUpdate.setValue(updatedTodo.todo, forKey: "todo")
                objectToUpdate.setValue(updatedTodo.completed, forKey: "completed")
                objectToUpdate.setValue(updatedTodo.description, forKey: "descriptionText")
                objectToUpdate.setValue(updatedTodo.createdDate, forKey: "createdDate")
                objectToUpdate.setValue(updatedTodo.userID, forKey: "userId")
                CoreDataManager.shared.saveContext()
                print("Todo updated: \(updatedTodo.todo)")
            } else {
                print("No Todo found with id \(updatedTodo.id)")
            }
        } catch {
            print("Failed to update todo: \(error)")
        }
    }
    // Для слияния данных из API с локальными данными
    func mergeToDos(apiToDos: [Todo]) {
        let existingToDos = loadToDos() // Загружаем локальные задачи
        
        for apiToDo in apiToDos {
            if existingToDos.contains(where: { $0.id == apiToDo.id }) {
                updateToDoInCoreData(apiToDo) // Обновляем задачу, если она уже существует
            } else {
                saveToDo(apiToDo) // Сохраняем новую задачу
            }
        }
    }



    func loadToDos() -> [Todo] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entity")
        do {
            let results = try context.fetch(fetchRequest)
            print("Loaded todos: \(results)") // Добавьте вывод в консоль
            return results.map { result in
                Todo(
                    id: result.value(forKey: "id") as? Int ?? 0,
                    todo: result.value(forKey: "todo") as? String ?? "",
                    completed: result.value(forKey: "completed") as? Bool ?? false,
                    userID: result.value(forKey: "userId") as? Int ?? 0,
                    createdDate: result.value(forKey: "createdDate") as? Date,
                    description: result.value(forKey: "descriptionText") as? String
                )
            }
        } catch {
            print("Failed to fetch todos: \(error)")
            return []
        }
    }

    func deleteToDo(_ todo: Todo) {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Entity")
        fetchRequest.predicate = NSPredicate(format: "id == %d", todo.id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let objectToDelete = results.first {
                context.delete(objectToDelete)
                CoreDataManager.shared.saveContext()
                print("Todo deleted with id: \(todo.id)")
            }
        } catch {
            print("Failed to delete todo: \(error)")
        }
    }

}


//class ToDoCoreDataManager {
//    
//    lazy var persistentContainer: NSPersistentContainer = {
//           let container = NSPersistentContainer(name: "YourModelName")
//           container.loadPersistentStores { storeDescription, error in
//               if let error = error {
//                   fatalError("Unresolved error \(error), \(error.localizedDescription)")
//               }
//           }
//           return container
//       }()
//       
//       var context: NSManagedObjectContext {
//           return persistentContainer.viewContext
//       }
//    
//    func saveToDo(toDo: Todo) {
//        if let entity = NSEntityDescription.entity(forEntityName: "Entity", in: context) {
//            let newToDo = NSManagedObject(entity: entity, insertInto: context)
//            
//            newToDo.setValue(toDo.id, forKey: "id")
//            newToDo.setValue(toDo.todo, forKey: "todo")
//            newToDo.setValue(toDo.completed, forKey: "completed")
//            newToDo.setValue(toDo.userID, forKey: "userId")
//            newToDo.setValue(toDo.createdDate, forKey: "createdDate")
//            newToDo.setValue(toDo.description, forKey: "descriptionText")
//            
//            saveContext()
//            print("Todo saved: \(toDo.todo)")
//        } else {
//            print("Failed to create entity for Todo.")
//        }
//    }
//    
//    
//    func loadToDos() -> [Todo] {
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entity")
//        do {
//            let results = try context.fetch(fetchRequest)
//            return results.map { result in
//                Todo(
//                    id: result.value(forKey: "id") as? Int ?? 0,
//                    todo: result.value(forKey: "todo") as? String ?? "",
//                    completed: result.value(forKey: "completed") as? Bool ?? false,
//                    userID: result.value(forKey: "userId") as? Int ?? 0,
//                    createdDate: result.value(forKey: "createdDate") as? Date,
//                    description: result.value(forKey: "descriptionText") as? String
//                )
//               
//            }
//        } catch {
//            print("Failed to fetch todos: \(error)")
//            return []
//        }
//    }
//    
//    func mergeToDos(apiToDos: [Todo]) {
//        var newActions = loadToDos()
//        var toDoList = newActions + apiToDos
//    }
//    
//    func deleteToDo(_ todo: Todo) {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
//        
//        do {
//            let results = try context.fetch(fetchRequest)
//            for object in results {
//                if let objectToDelete = object as? NSManagedObject {
//                    context.delete(objectToDelete)
//                }
//            }
//
//        } catch {
//            print("Failed to delete todo: \(error)")
//        }
//    }
//    
//
//    func loadAllToDos() {
//        // Создаем запрос для извлечения всех объектов из сущности "Entity"
//        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Entity")
//        
//        do {
//            // Выполняем запрос
//            let results = try CoreDataManager.shared.context.fetch(fetchRequest)
//            
//            // Проходим по всем результатам и выводим их в консоль
//            for result in results {
//                if let id = result.value(forKey: "id") as? Int,
//                   let todo = result.value(forKey: "todo") as? String,
//                   let completed = result.value(forKey: "completed") as? Bool,
//                   let  userID = result.value(forKey: "userId") as? Int,
//                   let createdDate = result.value(forKey: "createdDate") as? Date,
//                   let description = result.value(forKey: "descriptionText") as? String {
//                    
//                    print("ID: \(id), ToDo: \(todo), Completed: \(completed), UserID: \(userID), Created Date: \(createdDate), Description: \(description)")
//                }
//            }
//        } catch {
//            print("Error loading todos from Core Data: \(error)")
//        }
//    }
//    func updateToDoInCoreData(_ updatedTodo: Todo) {
//        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Entity")
//        fetchRequest.predicate = NSPredicate(format: "id == %d", updatedTodo.id)
//        
//        do {
//            let results = try context.fetch(fetchRequest)
//            print("Fetched results: \(results)") // Добавьте вывод результатов
//            if let objectToUpdate = results.first {
//                print("Updating Todo with id: \(updatedTodo.id)") // Подтвердите, что объект найден
//                objectToUpdate.setValue(updatedTodo.todo, forKey: "todo")
//                objectToUpdate.setValue(updatedTodo.completed, forKey: "completed")
//                objectToUpdate.setValue(updatedTodo.description, forKey: "descriptionText")
//                objectToUpdate.setValue(updatedTodo.createdDate, forKey: "createdDate")
//                objectToUpdate.setValue(updatedTodo.userID, forKey: "userId")
//                saveContext()
//                print("Todo updated: \(updatedTodo.todo)")
//            } else {
//                print("No Todo found with id \(updatedTodo.id)")
//            }
//        } catch {
//            print("Failed to update todo: \(error)")
//        }
//    }
//
// 
//}
