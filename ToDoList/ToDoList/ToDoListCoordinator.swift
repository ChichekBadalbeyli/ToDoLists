//
//  ToDoListCoordinator.swift
//  ToDoList
//
//  Created by Chichek on 05.12.24.
//

import UIKit

class ToDoListCoordinator {
    private let navigator: UINavigationController
    
    init(navigator: UINavigationController) {
        self.navigator = navigator
    }
    
    func start(onAddNewTodo: @escaping (Todo) -> Void, toDoList: Todo?, onEditTodo: @escaping (Todo) -> Void) {
        let actionVC = ActionViewController() // Можно создать через storyboard, если нужно
        
        actionVC.toDoList = toDoList // Передаем значение toDoList
        actionVC.editAction = { updatedTodo in
            onEditTodo(updatedTodo) // Вызовем редактирование задачи
            self.navigator.popViewController(animated: true) // Возвращаемся назад
        }
        
        navigator.pushViewController(actionVC, animated: true)
    }

}
