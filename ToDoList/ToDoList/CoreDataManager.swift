
import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func saveToDo(_ newTodo: Todo, description: String, createdDate: Date) {
        let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", newTodo.id)

        do {
            let results = try context.fetch(fetchRequest)
            if let existingTodo = results.first {
                print("🔄 Mevcut not güncelleniyor: \(newTodo.todo)")
                existingTodo.todo = newTodo.todo
                existingTodo.completed = newTodo.completed
                existingTodo.userId = Int64(newTodo.userID)
                existingTodo.createdDate = createdDate
                existingTodo.descriptionText = description
            } else {
                print("✅ Yeni not ekleniyor: \(newTodo.todo)")
                let todoEntity = ToDoEntity(context: context)
                todoEntity.id = Int64(newTodo.id)
                todoEntity.todo = newTodo.todo
                todoEntity.completed = newTodo.completed
                todoEntity.userId = Int64(newTodo.userID)
                todoEntity.createdDate = createdDate
                todoEntity.descriptionText = description
                todoEntity.isDelete = false
            }
            saveContext()
        } catch {
            print(" \(error)")
        }
    }

    func updateToDoDescriptionAndDate(byID id: Int, newDescription: String, newDate: Date) {
        let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            let results = try context.fetch(fetchRequest)
            if let todoEntity = results.first {
                todoEntity.descriptionText = newDescription
                todoEntity.createdDate = newDate
                saveContext()
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func updateToDoCompletionStatus(byID id: Int, isCompleted: Bool) {
        let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            let results = try context.fetch(fetchRequest)
            if let todoEntity = results.first {
                todoEntity.completed = isCompleted
                saveContext()
            }
        } catch {
            print(" \(error)")
        }
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
            }
        }
    }


    func loadToDos() -> [ToDoEntity] {
        let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let todos = try context.fetch(fetchRequest)
            return todos
        } catch {
            return []
        }
    }


    func mergeToDos(apiToDos: [Todo]) {
        for apiTodo in apiToDos {
            let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", apiTodo.id)

            do {
                let results = try context.fetch(fetchRequest)
                if let existingTodo = results.first {
                    existingTodo.todo = apiTodo.todo
                    if existingTodo.completed == false {
                        existingTodo.completed = apiTodo.completed
                    }
                } else {
                    let newTodo = ToDoEntity(context: context)
                    newTodo.id = Int64(apiTodo.id)
                    newTodo.todo = apiTodo.todo
                    newTodo.completed = apiTodo.completed
                    newTodo.userId = Int64(apiTodo.userID)
                    newTodo.createdDate = Date()
                    newTodo.descriptionText = "Varsayılan açıklama"
                    newTodo.isDelete = false
                }
            } catch {
                print(" \(error)")
            }
        }
        saveContext()
    }

    func deleteToDoEntity(_ todoEntity: ToDoEntity) {
        context.delete(todoEntity)

        do {
            try context.save()
        } catch {
            print("\(error)")
        }
    }


    
}
