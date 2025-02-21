//
//  ToDoActionController.swift
//  ToDoList
//
//  Created by Chichek on 20.02.25.
//

import UIKit
import Alamofire

class ToDoActionController: UIViewController, UITextViewDelegate {
    
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
        textView.backgroundColor = .clear
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.cornerRadius = 10
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureUI()
        configureConstraints()
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveChanges()
    }
    
    private func loadData() {
        guard let todo = todo else { return }
        
        heading.text = todo.todo
        
        if let todoEntity = CoreDataManager.shared.loadToDos().first(where: { $0.id == todo.id }) {
            descriptionTextView.text = todoEntity.descriptionText ?? ""
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            
            if let createdDate = todoEntity.createdDate {
                date.text = formatter.string(from: createdDate)
            } else {
                date.text = formatter.string(from: Date())
            }
        } else {
            descriptionTextView.text = ""
            date.text = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)
        }
    }
    
    private func configureUI() {
        view.addSubview(heading)
        view.addSubview(date)
        view.addSubview(descriptionTextView)
        
        heading.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureConstraints() {
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
        guard var todo = todo else { return }
        
        let updatedDescription = descriptionTextView.text ?? ""
        let updatedDate = Date()
        
        CoreDataManager.shared.updateToDoDescriptionAndDate(byID: todo.id, newDescription: updatedDescription, newDate: updatedDate)
        
        if let updatedEntity = CoreDataManager.shared.loadToDos().first(where: { $0.id == todo.id }) {
            todo.todo = heading.text ?? todo.todo
            completionHandler?(todo)
        }
        
        navigationController?.popViewController(animated: true)
    }
}

//1.editleyib geri qayidanda birinci sehifedeki heading update olsun
//2.description geriqayidanda gorunsun
//3. ui i duzelt
//4.naming problemi
