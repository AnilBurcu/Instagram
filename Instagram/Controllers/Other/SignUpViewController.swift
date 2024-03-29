//
//  SignUpViewController.swift
//  Instagram
//
//  Created by Anıl Bürcü on 22.03.2023.
//

import SafariServices
import UIKit

class SignUpViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    // SubViews
    

    private let profilePictureImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .lightGray
        imageView.image = UIImage(systemName: "person.circle")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 45
        return imageView
    }()
    
    private let usernameField: IGTextField = {
        let field = IGTextField()
        
        field.placeholder = "Username"
        field.returnKeyType = .next
        field.autocorrectionType = .no

        return field
    }()

    private let emailField: IGTextField = {
        let field = IGTextField()
        
        field.placeholder = "Email Address"
        field.keyboardType = .emailAddress
        field.returnKeyType = .next
        field.autocorrectionType = .no

        return field
    }()
    
    private let passwordField: IGTextField = {
        let field = IGTextField()
        
        field.placeholder = "Create Password"
        field.isSecureTextEntry = true //Parola için güvenli görünümlü giriş
        field.keyboardType = .default
        field.returnKeyType = .continue
        field.autocorrectionType = .no
        field.textContentType = .password

        return field
    }()
    
    private let signUpButton:UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .systemGreen
        
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    private let createAccountButton:UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.link, for: .normal)
        
       
        return button
    }()
    
    private let termsButton:UIButton = {
        let button = UIButton()
        button.setTitle("Terms of Service", for: .normal)
        button.setTitleColor(.link, for: .normal)
        
        
        return button
    }()
    
    private let privacyButton:UIButton = {
        let button = UIButton()
        button.setTitle("Privacy Policy", for: .normal)
        button.setTitleColor(.link, for: .normal)
        
        
        return button
    }()
    
    public var completion: (()->Void)?
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        view.backgroundColor = .systemBackground
        addSubviews()
        
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        addButtonActions()
        addImageGesture()
    }
    
   
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let imageSize:CGFloat = 90
        
        
        profilePictureImageView.frame = CGRect(
            x: (view.width-imageSize)/2,
            y: view.safeAreaInsets.top + 15,
            width: imageSize,
            height: imageSize)
        usernameField.frame = CGRect(x: 25, y: profilePictureImageView.bottom+20, width: view.width-50, height: 50)
        emailField.frame = CGRect(x: 25, y: usernameField.bottom+10, width: view.width-50, height: 50)
        passwordField.frame = CGRect(x: 25, y: emailField.bottom+10, width: view.width-50, height: 50)
        signUpButton.frame = CGRect(x: 35, y: passwordField.bottom+20, width: view.width-70, height: 50)
        termsButton.frame = CGRect(x: 35, y: signUpButton.bottom+50, width: view.width-70, height: 40)
        privacyButton.frame = CGRect(x: 35, y: termsButton.bottom+10, width: view.width-70, height: 40)
    }
    private func addSubviews(){
        view.addSubview(profilePictureImageView)
        view.addSubview(emailField)
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        view.addSubview(termsButton)
        view.addSubview(privacyButton)
    }
    
    private func addImageGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        profilePictureImageView.isUserInteractionEnabled = true
        profilePictureImageView.addGestureRecognizer(tap)
    }
    
    private func addButtonActions() {
        
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTerms), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(didTapPrivacy), for: .touchUpInside)
        
        
    }
    
    // MARK: Actions
    
    @objc func didTapImage(){
        let sheet = UIAlertController(title: "Profile Picture",
                                      message: "Set a picture to help your friends find you.",
                                      preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        sheet.addAction(UIAlertAction(title: "Take Photo", style: .default,handler: {[weak self] _ in
            
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.sourceType = .camera
                picker.delegate = self
                self?.present(picker,animated: true)
            }
        }))
        sheet.addAction(UIAlertAction(title: "Choose Photo From Your Library", style: .default,handler: {[weak self] _ in
            
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self?.present(picker,animated: true)
            }
            
        }))
        present(sheet,animated: true)
    }
    
    @objc func didTapSignUp() {
        emailField.resignFirstResponder()
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let username = usernameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              !username.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6,
              username.count >= 2,
              username.trimmingCharacters(in: .alphanumerics).isEmpty else {
            presentError()
            return
        }
        // Sign in with authManager
        let data = profilePictureImageView.image?.pngData()
        
        AuthManager.shared.signUp(
            email: email,
            username: username,
            password: password,
            profilePicture: data) {[weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        UserDefaults.standard.setValue(user.email, forKey: "email")
                        UserDefaults.standard.setValue(user.username, forKey: "username")
                        self?.navigationController?.popToRootViewController(animated: true)
                        self?.completion?()
                    case .failure(let error):
                        print("\n\nSign Up Error")
                    }
                }
            }
    }

    @objc func didTapTerms() {
        guard let url = URL(string: "https://www.instagram.com") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc,animated: true)
    }
    @objc func didTapPrivacy() {
        guard let url = URL(string: "https://www.instagram.com") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc,animated: true)
    }
    
    private func signIn(){
        
    }
    
    private func presentError() {
        let alert = UIAlertController(title: "Woops", message: "Please make sure to fill all fields and have a password longer than 6 characters.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    
    
    // MARK: Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // Kullanıcı retur'e basınca olacaklar için
        
        if textField == usernameField {
            emailField.becomeFirstResponder()
        }
            else if textField == emailField {
                passwordField.becomeFirstResponder() // return'e basınca otomatik passwordfield'e geçmesi için
            }else {
                textField.resignFirstResponder()
                didTapSignUp()
            }
            
            return true
        }
    
    // Image Picker
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        profilePictureImageView.image = image
    }

}
