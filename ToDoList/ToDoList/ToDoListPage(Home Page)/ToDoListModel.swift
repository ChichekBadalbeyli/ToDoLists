//
//  ToDoListModel.swift
//  ToDoList
//
//  Created by Chichek on 03.12.24.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let todos: [Todo]
    let total, skip, limit: Int
}

// MARK: - Todo
struct Todo: Codable {
    var id: Int  // Change to var
    var todo: String  // Change to var
    var completed: Bool  // Change to var
    var userID: Int  // Change to var

    enum CodingKeys: String, CodingKey {
        case id, todo, completed
        case userID = "userId"
    }
}


