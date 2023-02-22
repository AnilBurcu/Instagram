//
//  EditProfileViewController.swift
//  Instagram
//
//  Created by Anıl Bürcü on 20.02.2023.
//

import UIKit

struct EditProfileFormModel {
    let label:String
    let placeholder:String
    var value: String?
}

final class EditProfileViewController: UIViewController,UITableViewDataSource {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FormTableViewCell.self, forCellReuseIdentifier: FormTableViewCell.identifier)
        return tableView
    }()
    
    private var models = [[EditProfileFormModel]]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
  
        tableView.tableHeaderView = createTableViewHeader()
        tableView.dataSource = self
        view.addSubview(tableView)
        
        view.backgroundColor = .systemBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
        
    }
    
    private func configureModels(){
        // name, username, website, bio
        let section1Labels = ["Name","Username","Bio"]
        var section1 = [EditProfileFormModel]()
        for label in section1Labels {
            let model = EditProfileFormModel(label: label, placeholder: "Enter \(label)", value: nil)
            section1.append(model)
        }
        models.append(section1)
        // email, phone, gender
        let section2Labels = ["Email","Phone","Gender"]
        var section2 = [EditProfileFormModel]()
        for label in section2Labels {
            let model = EditProfileFormModel(label: label, placeholder: "Enter \(label)", value: nil)
            section2.append(model)
        }
        models.append(section2)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()     // Profil reesminin görülebilir olması için çerçeveyi gösterdik
        tableView.frame = view.bounds
    }
    
    // MARK: - TableView
    
    private func createTableViewHeader() -> UIView {
        let header = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: view.width,
                                          height: view.width/2).integral)
        let size = header.height/1.5
        let profilePhotoButton = UIButton(frame: CGRect(x: (view.width-size)/2,
                                                        y: (header.height-size)/2,
                                                        width: size,
                                                        height: size))
        header.addSubview(profilePhotoButton)
        profilePhotoButton.layer.masksToBounds = true // Fotoğrafın yuvarlak olması için
        profilePhotoButton.layer.cornerRadius = size/2
        profilePhotoButton.tintColor = .label
        profilePhotoButton.addTarget(self, action: #selector(didTapProfilePhotoButton), for: .touchUpInside)
        profilePhotoButton.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
        profilePhotoButton.layer.borderWidth = 1
        profilePhotoButton.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        return header
    }
    
    @objc private func didTapProfilePhotoButton(){ //selector fonksiyonu olduğu için @objc ile yazıyoruz
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FormTableViewCell.identifier,for: indexPath) as! FormTableViewCell
        cell.configure(with: model)
        cell.delegate = self
        
        return cell
    }
    
    
    // MARK: - Action
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 1 else{
            return nil
        }
        return "Private Information"
        
    }
    
    @objc private func didTapSave(){
        // Save info to database
        dismiss(animated: true)
    }
    @objc private func didTapCancel(){
        dismiss(animated: true)
    }
    
    @objc private func didTapChangeProfilePicture(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "Change Profile Picture", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Take Phote", style: .default))
        
        actionSheet.addAction(UIAlertAction(title: "Choose From Library", style: .default))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        actionSheet.popoverPresentationController?.sourceView = view
        actionSheet.popoverPresentationController?.sourceRect = view.bounds

        present(actionSheet,animated:  true)
    }
    


}

extension EditProfileViewController: FormTableViewCellDelegate{
    func formTableViewCell(_ cell: FormTableViewCell, didUpdateField updatedModel: EditProfileFormModel) {
        // Update the model
        print(updatedModel.value ?? "nil")
    }

}
