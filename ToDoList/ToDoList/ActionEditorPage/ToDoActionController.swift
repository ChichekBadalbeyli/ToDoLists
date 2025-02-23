
//
//  ToDoActionController.swift
//  ToDoList
//
//  Created by Chichek on 20.02.25.
//

import UIKit
import Alamofire

class ToDoActionController: ExtensionCofigureController {
    
    var todo: Todo?
    var completionHandler: ((Todo) -> Void)?
    
    private var heading: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode = .byWordWrapping
        return textView
    }()
    
    private var date: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        dateLabel.textColor = .white
        return dateLabel
    }()
    
    private var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        textView.textColor = .white
        textView.backgroundColor = .black
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveChanges()
    }
    
    private func loadData() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        if let todo = todo, let todoEntity = CoreDataManager.shared.loadToDos().first(where: { $0.id == todo.id }) {
            heading.text = todo.todo
            descriptionTextView.text = todoEntity.descriptionText ?? ""
            let createdDate = todoEntity.createdDate ?? Date()
            let formattedDate = formatter.string(from: createdDate)
            date.text = formattedDate
        } else {
            heading.text = ""
            descriptionTextView.text = ""
            let formattedDate = formatter.string(from: Date())
            date.text = formattedDate
        }
    }
    
    
    override func configureUI() {
        view.addSubview(heading)
        view.addSubview(date)
        view.addSubview(descriptionTextView)
        
        heading.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func configureConstraints() {
        heading.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            bottom: date.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            constraint: (top: 8, bottom: 8, leading: 20, trailing: 20)
        )
        
        date.anchor(
            top: heading.bottomAnchor,
            bottom: descriptionTextView.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            constraint: (top: 8, bottom: 16, leading: 20, trailing: 269)
        )
        
        descriptionTextView.anchor(
            top: date.bottomAnchor,
            bottom: view.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            constraint: (top: 16, bottom: 20, leading: 20, trailing: 20)
        )
    }
    
    @objc private func saveChanges() {
        let title = heading.text ?? ""
        let description = descriptionTextView.text ?? ""
        
        if var todo = todo {
            let existingEntity = CoreDataManager.shared.loadToDos().first(where: { $0.id == todo.id })
            let existingDate = existingEntity?.createdDate ?? Date()
            CoreDataManager.shared.updateToDoDescriptionAndDate(byID: todo.id, newDescription: description, newDate: existingDate)
            
            if let updatedTodo = CoreDataManager.shared.loadToDos().first(where: { $0.id == todo.id }) {
                todo.todo = title
                completionHandler?(todo)
            }
        } else {
            let newID = Int.random(in: 1000...9999)
            let newTodo = Todo(id: newID, todo: title, completed: false, userID: 1)
            
            let now = Date()
            CoreDataManager.shared.saveToDo(newTodo, description: description, createdDate: now)
            
            completionHandler?(newTodo)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
}

