//
//  ToDoActionController.swift
//  ToDoList
//
//  Created by Chichek on 20.02.25.
//

//import Foundation
//
//import UIKit
//import Alamofire
//
//class ToDoActionController: UIViewController {
//    
//    var todo: Todo? // ❌ `todoEntity` yerine API’den gelen `Todo` modelini kullanıyoruz.
//    var completionHandler: ((Todo) -> Void)?
//    
//    private var heading: UITextField = {
//        let textField = UITextField()
//        textField.font = UIFont.systemFont(ofSize: 34, weight: .bold)
//        textField.textColor = .white
//        textField.borderStyle = .none
//        return textField
//    }()
//    
//    private var descriptionTextView: UITextView = {
//        let textView = UITextView()
//        textView.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//        textView.textColor = .white
//        textView.backgroundColor = .clear
//        textView.layer.borderWidth = 1
//        textView.layer.borderColor = UIColor.gray.cgColor
//        textView.layer.cornerRadius = 10
//        return textView
//    }()
//    
//    private var saveButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Kaydet", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .systemBlue
//        button.layer.cornerRadius = 10
//        button.addTarget(ActionViewController.self, action: #selector(saveChanges), for: .touchUpInside)
//        return button
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .black
//        configureUI()
//        configureConstraints()
//        loadData() // Seçilen veriyi ekrana aktar
//    }
//    
//    private func loadData() {
//        guard let todo = todo else { return }
//        heading.text = todo.todo
//        descriptionTextView.text = "" // Eğer API açıklama getiriyorsa buraya set edilmeli
//    }
//    
//    private func configureUI() {
//        view.addSubview(heading)
//        view.addSubview(descriptionTextView)
//        view.addSubview(saveButton)
//        
//        heading.translatesAutoresizingMaskIntoConstraints = false
//        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
//        saveButton.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    private func configureConstraints() {
//        heading.anchor(
//            top: view.safeAreaLayoutGuide.topAnchor,
//            bottom: descriptionTextView.topAnchor,
//            leading: view.leadingAnchor,
//            trailing: view.trailingAnchor,
//            constraint: (top: 16, bottom: 8, leading: 20, trailing: 20)
//        )
//        
//        descriptionTextView.anchor(
//            top: heading.bottomAnchor,
//            bottom: saveButton.topAnchor,
//            leading: view.leadingAnchor,
//            trailing: view.trailingAnchor,
//            constraint: (top: 16, bottom: 20, leading: 20, trailing: 20),
//            height: 150
//        )
//        
//        saveButton.anchor(
//            top: descriptionTextView.bottomAnchor,
//            bottom: view.safeAreaLayoutGuide.bottomAnchor,
//            leading: view.leadingAnchor,
//            trailing: view.trailingAnchor,
//            constraint: (top: 20, bottom: 30, leading: 20, trailing: 20),
//            height: 50
//        )
//    }
//    
//    /// 🔥 **API'ye Görevi Güncelleme Talebi Gönderir**
//    @objc private func saveChanges() {
//        guard var todo = todo else { return }
//
//        todo.todo = heading.text ?? "Boş Görev"
//
//        // API'ye Güncelleme Talebi Gönder
//        updateTodoInAPI(todo)
//    }
//    
//    /// **📌 API Üzerinden Todo Güncelleme İşlemi**
//    private func updateTodoInAPI(_ todo: Todo) {
//        let url = "https://dummyjson.com/todos/\(todo.id)" // API URL'si (Örnek)
//        let parameters: [String: Any] = [
//            "todo": todo.todo,
//            "completed": todo.completed
//        ]
//        
//        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default).response { response in
//            switch response.result {
//            case .success:
//                print("✅ Görev başarıyla güncellendi: \(todo.todo)")
//                self.completionHandler?(todo)
//                self.navigationController?.popViewController(animated: true)
//            case .failure(let error):
//                print("❌ Hata: Görev güncellenemedi - \(error.localizedDescription)")
//            }
//        }
//    }
//}


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
    
    private var heading: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        textField.textColor = .white
        textField.borderStyle = .none
        return textField
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
        loadData() // Seçilen veriyi ekrana aktar
    }
    
    private func loadData() {
        guard let todo = todo else { return }
        
        heading.text = todo.todo

        // CoreData'dan açıklama çek
        if let todoEntity = CoreDataManager.shared.loadToDos().first(where: { $0.id == todo.id }) {
            descriptionTextView.text = todoEntity.descriptionText ?? "" // ✅ Açıklama CoreData’dan alınıyor
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none

            if let createdDate = todoEntity.createdDate {
                date.text = formatter.string(from: createdDate) // ✅ CoreData’dan tarih alınıyor
            } else {
                date.text = formatter.string(from: Date()) // ✅ Eğer tarih yoksa bugünün tarihini ata
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
    
    /// 🔥 **API'ye Görevi Güncelleme Talebi Gönderir**
    @objc private func saveChanges() {
        guard let todo = todo else { return }

        // Kullanıcının girdiği verileri al
        let updatedDescription = descriptionTextView.text ?? ""
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let updatedDate = Date() // Yeni tarih (şu anki tarih kullanılıyor)

        // CoreData'da güncelle
        CoreDataManager.shared.updateToDoInCoreData(
            updatedTodo: todo,
            description: updatedDescription,
            createdDate: updatedDate,
            isDelete: false // Silme işlemi yok, varsayılan false
        )

        // Güncellenmiş todo'yu geri döndür
        completionHandler?(todo)

        // Sayfayı kapat
        navigationController?.popViewController(animated: true)
    }

    

}

//1.editleyib geri qayidanda birinci sehifedeki heading update olsun
//2.description geriqayidanda gorunsun
//3. ui i duzelt
//4.naming problemi
