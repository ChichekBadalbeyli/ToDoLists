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

    func saveToDo(_ newTodo: Todo, description: String, createdDate: Date) {
        let todoEntity = ToDoEntity(context: context)
        todoEntity.todo = newTodo.todo
        todoEntity.completed = newTodo.completed
        todoEntity.userId = Int64(newTodo.userID)
        todoEntity.createdDate = createdDate // ✅ Tarih kaydediliyor
        todoEntity.descriptionText = description // ✅ Açıklama kaydediliyor
        todoEntity.isDelete = false
        saveContext()
    }




    func updateToDoInCoreData(updatedTodo: Todo, description: String, createdDate: Date, isDelete: Bool) {
        let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", updatedTodo.id)

        do {
            let results = try context.fetch(fetchRequest)
            if let todoEntity = results.first {
                todoEntity.todo = updatedTodo.todo
                todoEntity.descriptionText = description
                todoEntity.createdDate = createdDate
                todoEntity.completed = updatedTodo.completed
                todoEntity.isDelete = isDelete // ✅ Dışarıdan gelen değeri kullan
                saveContext()
            }
        } catch {
            print("❌ Hata: Görev güncellenemedi - \(error)")
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
            let description = "Varsayılan açıklama" // 🔹 API açıklama göndermiyorsa varsayılan değer
            let createdDate = Date() // 🔹 Şu anki tarihi kullan

            saveToDo(apiTodo, description: description, createdDate: createdDate) // ✅ Doğru çağrı
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
