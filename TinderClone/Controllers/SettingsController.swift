//
//  SettingsController.swift
//  TinderClone
//
//  Created by Михаил on 01.03.2023.
//

import UIKit
import Firebase
import FirebaseFirestore
import JGProgressHUD
import SDWebImage

class CustomImagePickerController: UIImagePickerController{
    var imageButton: UIButton?
    
    }

class SettingsController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    lazy var image1button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3button = createButton(selector: #selector(handleSelectPhoto))
    
    @objc fileprivate func handleSelectPhoto(button: UIButton){
        let imagePicker = CustomImagePickerController()
        imagePicker.imageButton = button
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
    }
    
    func createButton(selector: Selector) -> UIButton{
        let button = UIButton()
        button.setTitle("Srelect photo", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.clipsToBounds = true
        return button
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationsItems()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        
        fetchCurrentUser()
    }
    
    var user: User?
    
    fileprivate func fetchCurrentUser(){
        
        guard let uid = Auth.auth().currentUser?.uid else { return}
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, err in
            if let err = err{
                print(err)
                return
            }
            
            
            guard let dictionary = snapshot?.data() else {return}
            self.user = User(dictionary: dictionary)
            
            self.tableView.reloadData()
        }
    }
    
    fileprivate func setupNavigationsItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(hadleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(hadleCancel)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(hadleCancel))
        ]
    }
    

    @objc fileprivate func hadleCancel(){
        dismiss(animated: true)
    }
    // MARK: - Table view data source
    
    lazy var header = {
        let header = UIView()
        header.addSubview(image1button)
        let padding: CGFloat = 16
        image1button.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        image1button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [image2button, image3button])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        
        header.addSubview(stackView)
        stackView.anchor(top: header.topAnchor, leading: nil, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        stackView.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        
        return header
    }()
    
    class HeaderLabel: UILabel{
        override func drawText(in rect: CGRect){
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            return header
        }
        
        let headerLable = HeaderLabel()
        
        switch section{
        case 1:
            headerLable.text = "Name"
        case 2:
            headerLable.text = "Profession"
        case 3:
            headerLable.text = "Age"
        default:
            headerLable.text = "Bio"
        }
        
        return headerLable
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 300
        } else {
            return 40
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.section{
        case 1:
            cell.textField.placeholder = "Enter name"
            cell.textField.text = user?.name
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
        case 3:
            cell.textField.placeholder = "Enter Age"
            cell.textField.text = String(user?.age ?? 0)
        default:
            cell.textField.placeholder = "Enter Bio"
        }
        
        return cell
    }



}
