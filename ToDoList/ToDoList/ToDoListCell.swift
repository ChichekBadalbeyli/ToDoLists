//
//  ToDoListCell.swift
//  ToDoList
//
//  Created by Chichek on 03.12.24.
//

import UIKit

class ToDoListCell: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var action: UILabel!
    
    @IBOutlet var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(with todo: Todo) {
        name.text = todo.todo
        action.text = todo.description
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        date.text = formatter.string(from: todo.createdDate ?? Date())
        
        name.textColor = .white
        action.textColor = .white
        date.textColor = .white
    }
    
}
