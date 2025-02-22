//
//  NetworkManager.swift
//  ToDoList
//
//  Created by Chichek on 04.12.24.
//
//
//import Foundation
//import Alamofire
//
//class NetworkManager {
//    static func request <T: Codable> (model: T.Type,
//                                      endpoint: String,
//                                      method: HTTPMethod = .get,
//                                      parametrs: Parameters? = nil,
//                                      encoding: ParameterEncoding = URLEncoding.default,
//                                      completion: @escaping((T?,String?)-> Void)) {
//        AF.request("\(BaseManager.getURL(with: endpoint))",
//        method: method,
//        parameters: parametrs,
//                   encoding: encoding).responseDecodable(of: T.self){ response in
//            switch response.result{
//            case .success(let data):
//                completion (data,nil)
//            case .failure(let error):
//                completion(nil, error.localizedDescription)
//            }
//        }
//        
//    }
// 
//}

//
//  NetworkManager.swift
//  ToDoList
//
//  Created by Chichek on 04.12.24.
//

import Foundation
import Alamofire

class NetworkManager {
    static func request <T: Codable> (model: T.Type,
                                      endpoint: String,
                                      method: HTTPMethod = .get,
                                      parametrs: Parameters? = nil,
                                      encoding: ParameterEncoding = URLEncoding.default,
                                      completion: @escaping((T?,String?)-> Void)) {
        AF.request("\(BaseManager.getURL(with: endpoint))",
        method: method,
        parameters: parametrs,
                   encoding: encoding).responseDecodable(of: T.self){ response in
            switch response.result{
            case .success(let data):
                completion (data,nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
        
    }
 
}
