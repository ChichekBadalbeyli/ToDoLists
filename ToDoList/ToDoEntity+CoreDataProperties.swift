//
//  ToDoEntity+CoreDataProperties.swift
//  ToDoList
//
//  Created by Chichek on 19.02.25.
//
//

import Foundation
import CoreData


extension ToDoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoEntity> {
        return NSFetchRequest<ToDoEntity>(entityName: "ToDoEntity")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var createdDate: Date?
    @NSManaged public var descriptionText: String?
    @NSManaged public var id: Int64
    @NSManaged public var todo: String?
    @NSManaged public var userId: Int64
    @NSManaged public var isDelete: Bool

}

extension ToDoEntity : Identifiable {

}
