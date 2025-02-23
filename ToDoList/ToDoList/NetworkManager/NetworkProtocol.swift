//
//  NetworkProtocol.swift
//  ToDoList
//
//  Created by Chichek on 18.02.25.
//

import Foundation

protocol NetworkProtocol {
    func fetchToDoList (endpoint: ToDoListEndpoint, completion: @escaping(Welcome?,String?)-> Void)
}
