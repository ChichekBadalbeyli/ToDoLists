//
//  ToDoListModel.swift
//  ToDoList
//
//  Created by Chichek on 18.02.2025.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let todos: [Todo]
    let total, skip, limit: Int
}

// MARK: - Todo
struct Todo: Codable {
    var id: Int
    var todo: String
    var completed: Bool
    var userID: Int
    
    enum CodingKeys: String, CodingKey {
        case id, todo, completed
        case userID = "userId"
    }
}


