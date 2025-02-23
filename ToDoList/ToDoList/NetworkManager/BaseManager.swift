//
//  BaseManager.swift
//  ToDoList
//
//  Created by Chichek on 18.02.25.
//


import Foundation
import Alamofire

class BaseManager {
    static let baseURL = "https://dummyjson.com/"
    
    static func getURL (with endpoint: String) -> String {
        return "\(baseURL)\(endpoint)"
    }
    
}
