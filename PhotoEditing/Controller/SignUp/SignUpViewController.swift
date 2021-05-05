//
//  SignUpViewController.swift
//  PhotoEditing
//
//  Created by Mahesh Sapkota, Sarad Poudel and Kritartha Kafle on 04/25/21.

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {
   var REF_USERS = Database.database().reference().child("users")
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var selectedImage: UIImage?
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        profileImage.layer.borderWidth = 2
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 50
        loading.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleTextField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func handleTextField() {
        usernameTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(self.textCheck), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textCheck), for: UIControl.Event.editingChanged)
        
    }
    
    @objc func textCheck() {
        guard let username = usernameTextField.text, !username.isEmpty,
            
            let email = emailTextField.text, !email.isEmpty,
            
            let password = passwordTextField.text, !password.isEmpty else {
                signUpButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
                signUpButton.isEnabled = false
                return
        }
        signUpButton.isEnabled = true
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        textField.text = usernameTextField.text?.lowercased()
    }
    
    @objc func handleSelectProfileImageView() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Open the camera
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Choose image from camera roll
    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func dismiss_onClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpBtn_TouchUpInside(_ sender: Any) {
        view.endEditing(true)
        loading.isHidden = false
        self.loading.startAnimating()
        var profileImg = self.selectedImage
        if profileImg == nil {
            profileImg = UIImage(named: "placeholderImg")
        }

        let imageData = profileImg!.jpegData(compressionQuality: 0.1)

        AuthService.signUp(username: self.usernameTextField.text!, email: self.emailTextField.text!, password: self.passwordTextField.text!, imageData: imageData!, onSuccess: {
            self.loading.stopAnimating()
            self.performSegue(withIdentifier: "signUpToTabbarVC", sender: nil)
        }, onError: { (errorString) in
            
            let alertController = UIAlertController(title: "Oops!", message: errorString, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Okay", style: .default, handler: { (alert) in
                print("alert")
                alertController.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(alertAction)
            DispatchQueue.main.async {
                self.loading.isHidden = true
                self.loading.stopAnimating()
                self.present(alertController, animated: true, completion: nil)
            }
        })
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImage = image
            profileImage.image = image
            if profileImage.image == nil {
                profileImage.image = UIImage(named: "placeholderImg")
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}

