//
//  ToDoListViewModel.swift
//  ToDoList
//
//  Created by Chichek on 18.02.25.
//

import Foundation
import CoreData

class ToDoListViewModel {
    var toDoListManager = ToDoListManager()
    var toDoList = [Todo]()
    var filteredToDoList = [Todo]()
    var isSearching = false
    var searchQuery: String = ""
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    func getAndSaveTodos() {
        toDoListManager.fetchToDoList(endpoint: .toDoListEndpoint) { [weak self] data, errorMessage in
            guard let self = self else { return }
            
            if let errorMessage = errorMessage {
                self.error?(errorMessage)
                return
            }
            
            guard let data = data, !data.todos.isEmpty else { return }
            
            CoreDataManager.shared.mergeToDos(apiToDos: data.todos)
            self.toDoList = self.convertToDoEntitiesToTodos(CoreDataManager.shared.loadToDos())
            
            DispatchQueue.main.async {
                self.success?()
            }
        }
    }
    
    func searchTodos(query: String) {
        searchQuery = query
        if query.isEmpty {
            isSearching = false
            filteredToDoList = []
        } else {
            isSearching = true
            filteredToDoList = toDoList.filter { $0.todo.lowercased().contains(query.lowercased()) }
        }
        success?()
    }
    

    func addNewTodo(title: String, description: String) {
        let newID = Int.random(in: 1000...9999)

        let existingTodos = convertToDoEntitiesToTodos(CoreDataManager.shared.loadToDos())
        if existingTodos.contains(where: { $0.todo == title }) {

            return
        }

        let newTodo = Todo(id: newID, todo: title, completed: false, userID: 1)

        CoreDataManager.shared.saveToDo(newTodo, description: description, createdDate: Date())

        self.toDoList = convertToDoEntitiesToTodos(CoreDataManager.shared.loadToDos())

        DispatchQueue.main.async {

            self.success?()
        }
    }


//    
//    func toggleCompletionStatus(for todoID: Int, isCompleted: Bool) {
//        if let index = toDoList.firstIndex(where: { $0.id == todoID }) {
//            toDoList[index].completed = isCompleted
//            CoreDataManager.shared.updateToDoCompletionStatus(byID: todoID, isCompleted: isCompleted)
//            
//            DispatchQueue.main.async {
//                self.success?()
//            }
//        }
//    }
    
    func toggleCompletionStatus(for todoID: Int, isCompleted: Bool) {
        print("🔄 toggleCompletionStatus çağrıldı - ID: \(todoID), Yeni Durum: \(isCompleted)")

        // ✅ CoreData içinde tamamlanma durumunu değiştir
        CoreDataManager.shared.updateToDoCompletionStatus(byID: todoID, isCompleted: isCompleted)

        // ✅ Ana `toDoList` içinde ilgili görevi güncelle
        if let index = toDoList.firstIndex(where: { $0.id == todoID }) {
            toDoList[index].completed = isCompleted
        }

        // ✅ Eğer arama yapılıyorsa, `filteredToDoList` içinde de güncelle
        if isSearching {
            filteredToDoList = filteredToDoList.map { todo in
                if todo.id == todoID {
                    var updatedTodo = todo
                    updatedTodo.completed = isCompleted
                    return updatedTodo
                }
                return todo
            }
        }

        DispatchQueue.main.async {
            print("✅ UI güncelleniyor, TableView'u refresh ediyoruz...")
            self.success?()
        }
    }



    
    
     func convertToDoEntitiesToTodos(_ entities: [ToDoEntity]) -> [Todo] {
        return entities.map { entity in
            return Todo(id: Int(entity.id),
                        todo: entity.todo ?? "",
                        completed: entity.completed,
                        userID: Int(entity.userId))
        }
    }
    
    func updateTodoInCoreData(_ updatedTodo: Todo, description: String, createdDate: Date) {
        CoreDataManager.shared.updateToDoDescriptionAndDate(byID: updatedTodo.id,
                                                            newDescription: description,
                                                            newDate: createdDate)
        self.toDoList = convertToDoEntitiesToTodos(CoreDataManager.shared.loadToDos())
        
        DispatchQueue.main.async {
            self.success?()
        }
    }
    
    func deleteTodoFromCoreData(_ todo: Todo) {
        guard let todoEntity = CoreDataManager.shared.loadToDos().first(where: { $0.id == Int64(todo.id) }) else { return }

        CoreDataManager.shared.deleteToDoEntity(todoEntity)

        self.toDoList = convertToDoEntitiesToTodos(CoreDataManager.shared.loadToDos())

        DispatchQueue.main.async {
            self.success?()
        }
    }


}
