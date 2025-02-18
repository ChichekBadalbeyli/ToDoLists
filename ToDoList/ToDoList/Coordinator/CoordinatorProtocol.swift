//
//  CoordinatorProtocol.swift
//  ToDoList
//
//  Created by Chichek on 05.12.24.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigator: UINavigationController {get set}
 func start(onAddNewTodo: @escaping (Todo) -> Void, toDoList:Todo?)
}
