//
//  CoordinatorProtocol.swift
//  ToDoList
//
//  Created by Chichek on 18.02.25.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigator: UINavigationController {get set}
 func start(onAddNewTodo: @escaping (Todo) -> Void, toDoList:Todo?)
}
