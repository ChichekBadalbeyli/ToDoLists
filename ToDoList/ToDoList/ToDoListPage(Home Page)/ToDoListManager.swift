//
//  ToDoListManager.swift
//  ToDoList
//
//  Created by Chichek on 04.12.24.
//

//import Foundation
//
//class ToDoListManager: NetworkProtocol {
//
//    func fetchToDoList(endpoint: ToDoListEndpoint, completion: @escaping (Welcome?, String?) -> Void) {
//        NetworkManager.request(model: Welcome.self, endpoint: endpoint.rawValue, completion: completion)
//    }
//}

//  ToDoListManager.swift
//  ToDoList
//
//  Created by Chichek on 04.12.24.
//

import Foundation

class ToDoListManager: NetworkProtocol {

    func fetchToDoList(endpoint: ToDoListEndpoint, completion: @escaping (Welcome?, String?) -> Void) {
        NetworkManager.request(model: Welcome.self, endpoint: endpoint.rawValue, completion: completion)
    }
}
