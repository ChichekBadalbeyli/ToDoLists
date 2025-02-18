//
//  NetworkProtocol.swift
//  ToDoList
//
//  Created by Chichek on 04.12.24.
//

import Foundation

protocol NetworkProtocol {
    func fetchToDoList (endpoint: ToDoListEndpoint, completion: @escaping(Welcome?,String?)-> Void)
}
