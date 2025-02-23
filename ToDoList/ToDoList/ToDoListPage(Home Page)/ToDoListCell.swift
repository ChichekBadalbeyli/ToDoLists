//
//  ToDoListCell.swift
//  ToDoList
//
//  Created by Chichek on 18.02.25.
//
//
import UIKit

class ToDoListCell: UITableViewCell {
    var isCompleted: Bool = false
    private   var todo: Todo?
    var completionHandler: ((Int, Bool) -> Void)?
    
    let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        return button
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    private let descriptions: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    private let dates: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "ToDoListCell")
        configureUI()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(title)
        contentView.addSubview(descriptions)
        contentView.addSubview(dates)
        contentView.addSubview(completeButton)
        
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        title.translatesAutoresizingMaskIntoConstraints = false
        descriptions.translatesAutoresizingMaskIntoConstraints = false
        dates.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureConstraints() {
        title.anchor(
            top: contentView.topAnchor,
            bottom: descriptions.topAnchor,
            leading: completeButton.trailingAnchor,
            trailing: contentView.trailingAnchor,
            constraint: (top: 12, bottom: 6, leading: 8, trailing: 0)
        )
        
        descriptions.anchor(
            top: title.bottomAnchor,
            bottom: dates.topAnchor,
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor,
            constraint: (top: 6, bottom: 6, leading: 32, trailing: 0)
        )
        
        dates.anchor(
            top: descriptions.bottomAnchor,
            bottom: contentView.bottomAnchor,
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor,
            constraint: (top: 6, bottom: 12, leading: 32, trailing: 0)
        )
        
        completeButton.anchor(
            top: nil,
            bottom: nil,
            leading: contentView.leadingAnchor,
            trailing: nil,
            constraint: (top: 0, bottom: 0, leading: 12, trailing: 0),
            width: 24,
            height: 24
        )
        
        completeButton.centerYAnchor.constraint(equalTo: title.centerYAnchor).isActive = true
    }
    
    @objc private func completeButtonTapped() {
        guard let todo = todo else { return }
        
        let newCompletedStatus = !isCompleted
        isCompleted = newCompletedStatus
        
        DispatchQueue.main.async {
            self.completionHandler?(todo.id, newCompletedStatus)
            self.updateUI(isCompleted: newCompletedStatus)
        }
    }
    
    private func updateUI(isCompleted: Bool) {
        let imageName = isCompleted ? "TickIcon" : "Circle"
        
        self.completeButton.setImage(UIImage(named: imageName), for: .normal)
        self.completeButton.tintColor = isCompleted ? .yellow : .white
        
    }
    
    func configure(with todo: Todo, completionHandler: @escaping (Int, Bool) -> Void) {
        title.text = todo.todo
        self.todo = todo
        self.completionHandler = completionHandler
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        if let todoEntity = CoreDataManager.shared.loadToDos().first(where: { $0.id == todo.id }) {
            descriptions.text = todoEntity.descriptionText ?? ""
            let createdDate = todoEntity.createdDate ?? Date()
            dates.text = formatter.string(from: createdDate)
        } else {
            descriptions.text = ""
            dates.text = formatter.string(from: Date())
        }
        
        isCompleted = todo.completed
        updateUI(isCompleted: isCompleted)
    }
    
    
}
