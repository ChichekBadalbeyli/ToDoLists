//
//  ToDoListViewModel.swift
//  ToDoList
//
//  Created by Chichek on 18.02.25.
//

import Foundation
import CoreData

final class ToDoListViewModel {
    var toDoListManager = ToDoListManager()
    var toDoList = [Todo]()
    var filteredToDoList = [Todo]()
    var isSearching = false
    var searchQuery: String = ""
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    func getAndSaveTodos() {
        DispatchQueue.global(qos: .background).async {
            self.toDoListManager.fetchToDoList(endpoint: .toDoListEndpoint) { [weak self] data, errorMessage in
                guard let self = self else { return }
                
                if let errorMessage = errorMessage {
                    DispatchQueue.main.async {
                        self.error?(errorMessage)
                    }
                    return
                }
                guard let data = data, !data.todos.isEmpty else { return }
                
                CoreDataManager.shared.mergeToDos(apiToDos: data.todos)
                let todos = self.convertToDoEntitiesToTodos(CoreDataManager.shared.loadToDos())
                
                DispatchQueue.main.async {
                    self.toDoList = todos
                    self.success?()
                }
            }
        }
    }
    
    func searchTodos(query: String) {
        searchQuery = query
        
        DispatchQueue.global(qos: .userInitiated).async {
            let filtered = query.isEmpty ? [] : self.toDoList.filter { $0.todo.lowercased().contains(query.lowercased()) }
            
            DispatchQueue.main.async {
                self.isSearching = !query.isEmpty
                self.filteredToDoList = filtered
                self.success?()
            }
        }
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
    
    func convertToDoEntitiesToTodos(_ entities: [ToDoEntity]) -> [Todo] {
        return entities.map { entity in
            return Todo(id: Int(entity.id),
                        todo: entity.todo ?? "",
                        completed: entity.completed,
                        userID: Int(entity.userId))
        }
    }
    func toggleCompletionStatus(for todoID: Int, isCompleted: Bool) {
        DispatchQueue.main.async {
            if let index = self.toDoList.firstIndex(where: { $0.id == todoID }) {
                self.toDoList[index].completed = isCompleted
            }
            if self.isSearching {
                self.filteredToDoList = self.toDoList.filter { $0.todo.lowercased().contains(self.searchQuery.lowercased()) }
            }
            self.success?()
        }
        DispatchQueue.global(qos: .background).async {
            CoreDataManager.shared.updateToDoCompletionStatus(byID: todoID, isCompleted: isCompleted)
        }
    }
    
    func updateTodoInCoreData(_ updatedTodo: Todo, description: String, createdDate: Date) {
        CoreDataManager.shared.updateToDo(
            id: updatedTodo.id,
            title: updatedTodo.todo,
            description: description,
            createdDate: createdDate
        )
        self.toDoList = convertToDoEntitiesToTodos(CoreDataManager.shared.loadToDos())
        if isSearching {
            self.filteredToDoList = self.toDoList.filter { $0.todo.lowercased().contains(searchQuery.lowercased()) }
        }
        
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
