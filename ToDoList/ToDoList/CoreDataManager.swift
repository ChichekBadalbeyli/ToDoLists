//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Chichek on 06.12.24.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func saveToDo(_ newTodo: Todo) {
        let todoEntity = ToDoEntity(context: context)
        todoEntity.todo = newTodo.todo
        todoEntity.completed = newTodo.completed
        todoEntity.userId = Int64(newTodo.userID)
        todoEntity.createdDate = Date()
        todoEntity.descriptionText = ""
        todoEntity.isDelete = false
        saveContext()
    }

    func updateToDoInCoreData(_ updatedTodo: Todo) {
        let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", updatedTodo.id)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let todoEntity = results.first {
                todoEntity.todo = updatedTodo.todo
                todoEntity.completed = updatedTodo.completed
                todoEntity.userId = Int64(updatedTodo.userID)
                todoEntity.createdDate = Date()
                todoEntity.descriptionText = ""
                todoEntity.isDelete = false
                
                saveContext()
            }
        } catch {
            print("Ошибка обновления задачи: \(error)")
        }
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Не удалось сохранить контекст: \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func loadToDos() -> [ToDoEntity] {
        let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        
        do {
            let todos = try context.fetch(fetchRequest)
            return todos
        } catch {
            print("Ошибка загрузки задач: \(error)")
            return []
        }
    }
    
    func mergeToDos(apiToDos: [Todo]) {
        for apiTodo in apiToDos {
            saveToDo(apiTodo)
        }
    }
    
    func deleteToDoEntity(_ todoEntity: ToDoEntity) {
        context.delete(todoEntity)

        do {
            try context.save()
        } catch {
            print("Error deleting ToDoEntity: \(error)")
        }
    }


}
