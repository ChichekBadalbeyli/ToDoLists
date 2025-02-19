//
//  ToDoListCell.swift
//  ToDoList
//
//  Created by Chichek on 03.12.24.
//

import UIKit

class ToDoListCell: UITableViewCell {
    
    var
    
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
        
        title.translatesAutoresizingMaskIntoConstraints = false
        descriptions.translatesAutoresizingMaskIntoConstraints = false
        dates.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func configureConstraints() {
        title.anchor(
            top: contentView.topAnchor,
            bottom: descriptions.topAnchor,
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor,
            constraint: (top: 12, bottom: 6, leading: 32, trailing:0)
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
        //   descriptions.text = todo.description
        //   print("Description: \(todo.description ?? "No description")")
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        //   dates.text = formatter.string(from: todo.createdDate ?? Date())
        
        title.textColor = .white
        descriptions.textColor = .white
        dates.textColor = .white
    }
    
}
