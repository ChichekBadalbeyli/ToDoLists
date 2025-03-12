//  ToDoListManager.swift
//  ToDoList
//
//  Created by Chichek on 18.02.2025.
//

import Foundation

final class ToDoListManager: NetworkProtocol {

    func fetchToDoList(endpoint: ToDoListEndpoint, completion: @escaping (Welcome?, String?) -> Void) {
        NetworkManager.request(model: Welcome.self, endpoint: endpoint.rawValue, completion: completion)
    }
}
