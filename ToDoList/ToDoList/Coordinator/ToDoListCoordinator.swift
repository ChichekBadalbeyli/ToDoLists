//
//  ToDoListCoordinator.swift
//  ToDoList
//
//  Created by Chichek on 05.12.24.
//

import UIKit
//
//class ToDoListCoordinator: Coordinator {
//    var navigator: UINavigationController
//    
//    init(navigator: UINavigationController) {
//        self.navigator = navigator
//    }
//    
//    func start(onAddNewTodo: @escaping (Todo) -> Void, toDoList: Todo?) {
//        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ActionViewController") as! ActionViewController
//        navigator.show(controller, sender: nil)
//    }
//    

    
//    func start(onAddNewTodo: @escaping (Todo) -> Void, toDoList: Todo?, onEditTodo: @escaping (Todo) -> Void) {
//        let actionVC = ActionViewController()
//        
//        actionVC.toDoList = toDoList
//        actionVC.editAction = { updatedTodo in
//            onEditTodo(updatedTodo)
//            self.navigator.popViewController(animated: true)
//        }
//        
//        navigator.pushViewController(actionVC, animated: true)
//    }

//}



class ToDoListCoordinator: Coordinator {
    var navigator: UINavigationController
    
    init(navigator: UINavigationController) {
        self.navigator = navigator
    }
    
    func start(onAddNewTodo: @escaping (Todo) -> Void, toDoList: Todo?) {
        let controller = ToDoActionController() // ✅ Storyboard yerine direkt başlat
        controller.todo = toDoList
        navigator.pushViewController(controller, animated: true)
    }

}
