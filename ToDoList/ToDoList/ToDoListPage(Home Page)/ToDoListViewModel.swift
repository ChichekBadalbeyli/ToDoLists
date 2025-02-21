
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
            
            // ✅ Сохраняем в CoreData
            CoreDataManager.shared.mergeToDos(apiToDos: data.todos)

            // ✅ Загружаем из CoreData с актуальным `completed`
            self.toDoList = self.convertToDoEntitiesToTodos(CoreDataManager.shared.loadToDos())
            
            DispatchQueue.main.async {
                self.success?()
            }
        }
    }


    func toggleCompletionStatus(for todoID: Int, isCompleted: Bool) {
        if let index = toDoList.firstIndex(where: { $0.id == todoID }) {
            toDoList[index].completed = isCompleted
            
            // ✅ Обновляем данные в CoreData
            CoreDataManager.shared.updateToDoCompletionStatus(byID: todoID, isCompleted: isCompleted)

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
    
    func updateTodoInCoreData(_ updatedTodo: Todo, description: String, createdDate: Date) {
        CoreDataManager.shared.updateToDoDescriptionAndDate(byID: updatedTodo.id, newDescription: description, newDate: createdDate)
        self.toDoList = convertToDoEntitiesToTodos(CoreDataManager.shared.loadToDos())
        
        DispatchQueue.main.async {
            self.success?()
        }
    }
    
    func deleteTodoFromCoreData(_ todo: Todo) {
        if let todoEntity = CoreDataManager.shared.loadToDos().first(where: { $0.id == Int64(todo.id) }) {
            CoreDataManager.shared.deleteToDoEntity(todoEntity)
        }
    }
}
