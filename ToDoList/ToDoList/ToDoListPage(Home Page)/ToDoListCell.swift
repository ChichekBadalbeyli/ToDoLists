//
//  ToDoListCell.swift
//  ToDoList
//
//  Created by Chichek on 03.12.24.
//

import UIKit

class ToDoListCell: UITableViewCell {
    
    var isCompleted = false
    
    var completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
       // button.layer.borderColor  = UIColor.darkGray.cgColor
        button.tintColor = .gray
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var title: UILabel = {
        var titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        return titleLabel
    }()
    
    var descriptions: UILabel = {
        var descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.textColor = .white
        return descriptionLabel
    }()
    
    var dates: UILabel = {
        var dateLabel = UILabel()
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
            constraint: (top: 12, bottom: 6, leading: 8, trailing:0)
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
        isCompleted.toggle()
        let imageName = isCompleted ? "checkmark.circle.fill" : "circle"
        completeButton.setImage(UIImage(systemName: imageName), for: .normal)
        completeButton.tintColor = isCompleted ? .yellow  : .gray
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "ToDoListCell")
        configureUI()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with todo: Todo) {
        title.text = todo.todo
           descriptions.text = CoreDataManager.shared.loadToDos()
               .first(where: { $0.id == todo.id })?.descriptionText ?? "Açıklama yok" // ✅ Açıklama CoreData'dan çekiliyor

           let formatter = DateFormatter()
           formatter.dateStyle = .medium
           formatter.timeStyle = .none

           let createdDate = CoreDataManager.shared.loadToDos()
               .first(where: { $0.id == todo.id })?.createdDate ?? Date()
           
           dates.text = formatter.string(from: createdDate)
    }
    
}
