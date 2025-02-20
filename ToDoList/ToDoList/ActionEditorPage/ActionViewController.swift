//
//  ActionViewController.swift
//  ToDoList
//
//  Created by Chichek on 05.12.24.
//

import UIKit
import Alamofire
//
//class ActionViewController: UIViewController, UITextViewDelegate {
//    var todoEntity: ToDoEntity?
//   // var completionHandler: ((Todo) -> Void)?
//    var heading: UITextField = {
//        let textField = UITextField()
//        textField.font = UIFont.systemFont(ofSize: 34, weight: .bold)
//        textField.textColor = .white
//        textField.borderStyle = .none
//        return textField
//    }()
//
//    var date: UILabel = {
//        let dateLabel = UILabel()
//        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
//        dateLabel.textColor = .white
//        return dateLabel
//    }()
//
//    var descriptionTextView: UITextView = {
//        let textView = UITextView()
//        textView.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//        textView.textColor = .white
//        textView.backgroundColor = .clear
//        return textView
//    }()
//
//    
//    override func viewDidLoad() {
//        configureUI()
//        configureConstraints()
//        
////        if let todoEntity = todoEntity {
////                    heading.text = todoEntity.todo
////                    descriptionTextView.text = todoEntity.descriptionText
////                    date.text = formatDate(todoEntity.createdDate ?? Date()) // Устанавливаем дату
////                } else {
////                    date.text = formatDate(Date()) // Новая задача → текущая дата
////                }
////                
////                descriptionTextView.delegate = self
////                heading.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
//    }
//    
//    func configureUI() {
//        view.addSubview(heading)
//        view.addSubview(date)
//        view.addSubview(descriptionTextView)
//        
//        heading.translatesAutoresizingMaskIntoConstraints = false
//        date.translatesAutoresizingMaskIntoConstraints = false
//        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    func  configureConstraints() {
//        heading.anchor(
//            top: view.safeAreaLayoutGuide.topAnchor,
//            bottom: date.topAnchor,
//            leading: view.leadingAnchor,
//            trailing: view.trailingAnchor,
//            constraint: (top: 8, bottom: 8, leading: 20, trailing: 20)
//        )
//        date.anchor(
//            top: heading.bottomAnchor,
//            bottom: descriptionTextView.topAnchor,
//            leading: view.leadingAnchor,
//            trailing: view.trailingAnchor,
//            constraint: (top: 8, bottom: 16, leading: 20, trailing: 269)
//        )
//        descriptionTextView.anchor(
//            top: date.bottomAnchor,
//            bottom: view.bottomAnchor,
//            leading: view.leadingAnchor,
//            trailing: view.trailingAnchor,
//            constraint: (top: 16, bottom: 547, leading: 20, trailing: 20)
//        )
//    }
////    @objc func textFieldChanged() {
////            guard var todoEntity = todoEntity else { return }
////
////            todoEntity.todo = heading.text ?? ""
////            todoEntity.descriptionText = descriptionTextView.text ?? ""
////            todoEntity.createdDate = Date() // Обновляем дату
////            
////            CoreDataManager.shared.saveContext() // Сохраняем изменения в Core Data
////        }
////
////        func formatDate(_ date: Date) -> String {
////            let formatter = DateFormatter()
////            formatter.dateFormat = "dd.MM.yyyy" // Формат даты
////            return formatter.string(from: date)
////        }
//
//    
//}

//class ActionViewController: UIViewController {
//
//    @IBOutlet var actionName: UITextField!
//
//    @IBOutlet var actionDefiniition: UITextField!
//
//    @IBOutlet var date: UILabel!
//   // var viewModel = ToDoListViewModel(context: <#NSManagedObjectContext#>)
//        var addNewToDo: ((Todo) -> Void)?
//        var toDoList: Todo? // Опциональное значение
//        var editAction: ((Todo) -> Void)?
//
//    override func viewDidLoad() {
//          super.viewDidLoad()
//
//          guard let toDo = toDoList else {
//              actionName.text = ""
//              actionDefiniition.text = ""
//              print("No todo to edit.")
//              return
//          }
//
//          // Если toDoList существует, безопасно извлекаем его свойства
//          actionName.text = toDo.todo
//         // actionDefiniition.text = toDo.description
//      }
//
//      override func viewWillDisappear(_ animated: Bool) {
//          super.viewWillDisappear(animated)
//
//          guard let todoText = actionName.text, !todoText.isEmpty,
//                let definition = actionDefiniition.text, !definition.isEmpty else {
//              print("Fields are empty, skipping todo update.")
//              return
//          }
//
//          // Создаем новый объект Todo с безопасным извлечением значений
////          let updatedTodo = Todo(
////              id: toDoList?.id ?? UUID().hashValue, // Если id нет, генерируем новый
////              todo: todoText,
////              completed: toDoList?.completed ?? false, // Если completed нет, по умолчанию false
////              userID: toDoList?.userID ?? 1, // Если userID нет, по умолчанию 1
////              createdDate: toDoList?.createdDate ?? Date(), // Если дата нет, используем текущую
////              description: definition
////          )
//
//          // Передаем обновленный объект в замыкание
//        //  editAction?(updatedTodo)
//      }
//  }

import UIKit
import Alamofire

class ActionViewController: UIViewController {
    
    var todo: Todo? // ❌ `todoEntity` yerine API’den gelen `Todo` modelini kullanıyoruz.
    var completionHandler: ((Todo) -> Void)?
    
    private var heading: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        textField.textColor = .white
        textField.borderStyle = .none
        return textField
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
    
    private var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kaydet", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(ActionViewController.self, action: #selector(saveChanges), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureUI()
        configureConstraints()
        loadData() // Seçilen veriyi ekrana aktar
    }
    
    private func loadData() {
        guard let todo = todo else { return }
        heading.text = todo.todo
        descriptionTextView.text = "" // Eğer API açıklama getiriyorsa buraya set edilmeli
    }
    
    private func configureUI() {
        view.addSubview(heading)
        view.addSubview(descriptionTextView)
        view.addSubview(saveButton)
        
        heading.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureConstraints() {
        heading.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            bottom: descriptionTextView.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            constraint: (top: 16, bottom: 8, leading: 20, trailing: 20)
        )
        
        descriptionTextView.anchor(
            top: heading.bottomAnchor,
            bottom: saveButton.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            constraint: (top: 16, bottom: 20, leading: 20, trailing: 20),
            height: 150
        )
        
        saveButton.anchor(
            top: descriptionTextView.bottomAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            constraint: (top: 20, bottom: 30, leading: 20, trailing: 20),
            height: 50
        )
    }
    
    /// 🔥 **API'ye Görevi Güncelleme Talebi Gönderir**
    @objc private func saveChanges() {
        guard var todo = todo else { return }

        todo.todo = heading.text ?? "Boş Görev"

        // API'ye Güncelleme Talebi Gönder
        updateTodoInAPI(todo)
    }
    
    /// **📌 API Üzerinden Todo Güncelleme İşlemi**
    private func updateTodoInAPI(_ todo: Todo) {
        let url = "https://dummyjson.com/todos/\(todo.id)" // API URL'si (Örnek)
        let parameters: [String: Any] = [
            "todo": todo.todo,
            "completed": todo.completed
        ]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default).response { response in
            switch response.result {
            case .success:
                print("✅ Görev başarıyla güncellendi: \(todo.todo)")
                self.completionHandler?(todo)
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print("❌ Hata: Görev güncellenemedi - \(error.localizedDescription)")
            }
        }
    }
}
