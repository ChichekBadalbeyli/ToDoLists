//
//  ToDoListCoordinator.swift
//  ToDoList
//
//  Created by Chichek on 18.02.25.
//

import UIKit

final class ToDoListCoordinator: Coordinator {
    var navigator: UINavigationController
    
    init(navigator: UINavigationController) {
        self.navigator = navigator
    }
    
    func start(onAddNewTodo: @escaping (Todo) -> Void, toDoList: Todo?) {
        let controller = ToDoActionController()
        controller.todo = toDoList
        controller.completionHandler = onAddNewTodo
        navigator.pushViewController(controller, animated: true)
    }
}
