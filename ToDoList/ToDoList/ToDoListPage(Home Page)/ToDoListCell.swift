//
//  ToDoListCell.swift
//  ToDoList
//
//  Created by Chichek on 18.02.25.
//

import UIKit

class ToDoListCell: UITableViewCell {
    var isCompleted: Bool = false
    var todo: Todo?
        var completionHandler: ((Int, Bool) -> Void)?
    
    var completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.tintColor = .gray
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var title: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        return titleLabel
    }()
    
    var descriptions: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.textColor = .white
        return descriptionLabel
    }()
    
    var dates: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        dateLabel.textAlignment = .left
        dateLabel.textColor = .white
        return dateLabel
    }()
    
    func configureUI() {
        contentView.addSubview(title)
        contentView.addSubview(descriptions)
        contentView.addSubview(dates)
        contentView.addSubview(completeButton)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        descriptions.translatesAutoresizingMaskIntoConstraints = false
        dates.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureConstraints() {
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
    
    @objc func completeButtonTapped() {
        guard let todo = todo else { return }

        let newCompletedStatus = !isCompleted // ✅ Переключаем состояние
        isCompleted = newCompletedStatus // ✅ Сохраняем новое состояние

        completionHandler?(todo.id, newCompletedStatus) // ✅ Передаём во ViewModel
        
        updateUI(isCompleted: newCompletedStatus) // ✅ Обновляем UI
    }


    func updateUI(isCompleted: Bool) {
        let imageName = isCompleted ? "checkmark.circle.fill" : "circle"
        completeButton.setImage(UIImage(systemName: imageName), for: .normal)
        completeButton.tintColor = isCompleted ? .yellow : .gray
    }


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "ToDoListCell")
        configureUI()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func configure(with todo: Todo) {
//        title.text = todo.todo
//
//        if let todoEntity = CoreDataManager.shared.loadToDos().first(where: { $0.id == todo.id }) {
//            descriptions.text = todoEntity.descriptionText ?? "Açıklama yok"
//            let formatter = DateFormatter()
//            formatter.dateStyle = .medium
//            formatter.timeStyle = .none
//            let createdDate = todoEntity.createdDate ?? Date()
//            dates.text = formatter.string(from: createdDate)
//            isCompleted = todo.completed // ✅ Загружаем состояние из API
//            updateUI(isCompleted: isCompleted) // ✅ Обновляем UI
//
//            self.completionHandler = completionHandler
//        } else {
//            descriptions.text = "Açıklama bulunamadı"
//        }
//    }
    func configure(with todo: Todo, completionHandler: @escaping (Int, Bool) -> Void) {
        title.text = todo.todo
        self.todo = todo // ✅ Сохраняем `todo`
        self.completionHandler = completionHandler // ✅ Сохраняем обработчик

        if let todoEntity = CoreDataManager.shared.loadToDos().first(where: { $0.id == todo.id }) {
            descriptions.text = todoEntity.descriptionText ?? "Açıklama yok"
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            let createdDate = todoEntity.createdDate ?? Date()
            dates.text = formatter.string(from: createdDate)
        } else {
            descriptions.text = "Açıklama bulunamadı"
        }

        // ✅ Обновляем состояние из API
        isCompleted = todo.completed
        updateUI(isCompleted: isCompleted)
    }


    
//    func configure(with todo: Todo, completionHandler: @escaping (Int, Bool) -> Void) {
//        self.todo = todo
//        self.completionHandler = completionHandler
//
//        title.text = todo.todo
//
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .none
//        dates.text = formatter.string(from: Date())
//
//        isCompleted = todo.completed
//        updateUI(isCompleted: isCompleted) // 🔹 Устанавливаем корректное состояние кнопки
//    }

}

