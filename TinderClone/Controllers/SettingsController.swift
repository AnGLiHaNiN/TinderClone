//
//  SettingsController.swift
//  TinderClone
//
//  Created by Михаил on 01.03.2023.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
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
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.75) else {return}
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading image..."
        hud.show(in: view)
        
        ref.putData(uploadData) { (nil, err) in
            
            if let err = err {
                hud.dismiss()
                print("Failed to upload image to storage", err)
                return
            }
            print("Finish uploading image")
            ref.downloadURL { (url, err)  in
                hud.dismiss()
                if let err = err{
                    print("Failed to upload image to storage", err)
                    return
                }
                
                print("Finishing getting download url:", url?.absoluteString ?? "")
                
                switch imageButton {
                case self.image1button:
                    self.user?.imageURL1 = url?.absoluteString
                case self.image2button:
                    self.user?.imageURL2 = url?.absoluteString
                default:
                    self.user?.imageURL3 = url?.absoluteString
                }
                
                
            }
        }
    }
    
    func createButton(selector: Selector) -> UIButton{
        let button = UIButton()
        button.setTitle("Select photo", for: .normal)
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
            self.loadUserPhotos()
            
            self.tableView.reloadData()
        }
    }
    
    fileprivate func loadUserPhotos(){
        if let imageUrl = user?.imageURL1,  let url = URL(string: imageUrl){
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.image1button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        if let imageUrl = user?.imageURL2,  let url = URL(string: imageUrl){
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.image2button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        if let imageUrl = user?.imageURL3,  let url = URL(string: imageUrl){
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.image3button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
        
    }
    
    fileprivate func setupNavigationsItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(hadleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(hadleSave)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(hadleCancel))
        ]
    }
    
    
    @objc fileprivate func hadleSave(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let docData = [
            "uid": uid,
            "fullName": user?.name ?? "",
            "imageUrl1": user?.imageURL1 ?? "",
            "imageUrl2": user?.imageURL2 ?? "",
            "imageUrl3": user?.imageURL3 ?? "",
            "age": user?.age ?? -1,
            "profession": user?.profession ?? "",
            "minSeekingAge": user?.minSeekingAge ?? -1,
            "maxSeekingAge": user?.maxSeekingAge ?? -1
        ] as [String : Any]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving settings"
        hud.show(in: view)
        
        Firestore.firestore().collection("users").document(uid).setData(docData) { err in
            hud.dismiss()
            if let err = err {
                print("failed to print user settings", err)
                return
            }
            print("Finished saving user info")
        }
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
        case 4:
            headerLable.text = "Bio"
        default:
            headerLable.text = "Seeking Age Range"
        }
        headerLable.font = UIFont.boldSystemFont(ofSize: 14)
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
        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return section == 0 ? 0 : 1
    }
    
    @objc fileprivate func handleMinAgeChange(slider: UISlider){
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        ageRangeCell.minLable.text = "Min: \(Int(slider.value))"
        if slider.value > ageRangeCell.maxSlider.value{
            ageRangeCell.maxSlider.value = slider.value
            handleMaxAgeChange(slider: ageRangeCell.maxSlider)
        }
        
        self.user?.minSeekingAge = Int(slider.value)
    }
    
    @objc fileprivate func handleMaxAgeChange(slider: UISlider){
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        ageRangeCell.maxLable.text = "Max: \(Int(slider.value))"
        if slider.value < ageRangeCell.minSlider.value{
            ageRangeCell.minSlider.value = slider.value
            handleMinAgeChange(slider: ageRangeCell.minSlider)
        }
        
        self.user?.maxSeekingAge = Int(slider.value)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        
        if indexPath.section == 5{
            let ageRangeCell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinAgeChange), for: .valueChanged)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxAgeChange), for: .valueChanged)
            ageRangeCell.minLable.text = "Min \(user?.minSeekingAge ?? -1)"
            ageRangeCell.maxLable.text = "Max \(user?.maxSeekingAge ?? -1)"
            return ageRangeCell
        }
        
        switch indexPath.section{
        case 1:
            cell.textField.placeholder = "Enter name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Age"
            if let age = user?.age {
                cell.textField.text = String(age)
                cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
            }
        default:
            cell.textField.placeholder = "Enter Bio"
        }
        
        return cell
    }
    
    
    @objc fileprivate func handleNameChange(textField: UITextField){
        self.user?.name = textField.text
    }
    
    @objc fileprivate func handleProfessionChange(textField: UITextField){
        self.user?.profession = textField.text
    }
    
    @objc fileprivate func handleAgeChange(textField: UITextField){
        self.user?.age = Int(textField.text ?? "")
    }


}
