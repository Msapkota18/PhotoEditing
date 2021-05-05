//
//  SettingTableViewController.swift
//  PhotoEditing
//
//  Created by Mahesh Sapkota, Sarad Poudel and Kritartha Kafle on 04/25/21.
//

//  View Controller will allow user to edit their profile. 

import UIKit
import LocationPicker
import MapKit

protocol SettingTableViewControllerDelegate {
    func updateUserInfor()
}

class SettingTableViewController: UITableViewController {

    @IBOutlet weak var usernnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var addressLabel: UILabel!
    
    var delegate: SettingTableViewControllerDelegate?
    
    var imagePicker = UIImagePickerController()
    
    var myLocation: CLLocation?
    var locationManager: CLLocationManager!
    var lat = 0.0
    var lon = 0.0
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        let alertController = UIAlertController(title: "Simple Social", message: "Detected a device shake", preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "Confirm", style: .default, handler: { (action) in
            
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit"
        usernnameTextField.delegate = self
        emailTextField.delegate = self
        goalTextField.delegate = self
        profileImageView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        profileImageView.layer.borderWidth = 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 50
        fetchCurrentUser()
        setBackButton()
        enableLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false //Testing for Profile Editing
    }
    
    func fetchCurrentUser() {
        Api.Userr.observeCurrentUser { (userr) in
            self.usernnameTextField.text = userr.username
            self.emailTextField.text = userr.email
            self.goalTextField.text = userr.bio
            self.addressLabel.text = userr.website
            if let profileUrl = URL(string: userr.profileImageUrl!) {
                self.profileImageView.sd_setImage(with: profileUrl)
            }
        }
    }
    
    @IBAction func saveBtn_TouchUpInside(_ sender: Any) {
        loading.startAnimating()
        if let profileImg = self.profileImageView.image, let imageData = profileImg.jpegData(compressionQuality: 0.1) {
          
            AuthService.updateUserInfor(username: usernnameTextField.text!, email: emailTextField.text!,
                                        bio:goalTextField.text!, website: addressLabel.text!, imageData: imageData, onSuccess: {
                self.delegate?.updateUserInfor()
                self.loading.stopAnimating()
                self.presentAlertWithTitle(title: "Success", message: "Your profile has been updated.", options: "Ok") {
                                                (option) in
                                                switch(option) {
                                                case 0:
                                                    print("Clear Post")
                                                default:
                                                    break
                                                }
                                            }
                print("Success on updating user info!)")
            }, onError: { (errorMessage) in
                print("Error: \(String(describing: errorMessage))")
            })
        }
    }

    @IBAction func logoutBtn_TouchUpInside(_ sender: Any) {
        let strMsg: String = "Are you sure want to logout?"
        let strOK: String = "OK"
        let strCancel: String = "CANCEL"
        showAlertViewWithTitle("", message: strMsg, buttonTitles: [strCancel, strOK], viewController: self, completion: {(index) in
            if index == 1 {
                AuthService.logout(onSuccess: {
                    let storyboard = UIStoryboard(name: "Start", bundle: nil)
                    let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
                    self.present(signInVC, animated: true, completion: nil)
                }) { (errorMessage) in
                    print("ERROR: \(String(describing: errorMessage))")
                }
            }
        })
    }
    
    
    @IBAction func bAddressTapped(_ sender: UIButton) {
        locationPicker()
    }
    
    func locationPicker(){
        let locationPicker = LocationPickerViewController()
        
        // you can optionally set initial location
        let placemark = MKPlacemark(coordinate: myLocation != nil ? myLocation!.coordinate : CLLocationCoordinate2D(latitude: 29.3607754, longitude: 47.6335785), addressDictionary: nil)
        
        let location = Location(name: "", location: nil, placemark: placemark)
        
        locationPicker.location = location
        locationPicker.showCurrentLocationButton = true
        locationPicker.currentLocationButtonBackground = .blue
        locationPicker.showCurrentLocationInitially = true
        locationPicker.mapType = .standard // default: .Hybrid
        locationPicker.useCurrentLocationAsHint = true // default: false
        locationPicker.searchBarPlaceholder = "Search Address" // default: "Search or enter an address"
        locationPicker.searchHistoryLabel = "Previously searched"
        locationPicker.resultRegionDistance = 600 // default: 600
        locationPicker.completion = { location in
            self.navigationController?.isNavigationBarHidden  = true
            if let loc = location{
                self.addressLabel.text = loc.address
                self.lat = loc.coordinate.latitude
                self.lon = loc.coordinate.longitude
            }
        }
        navigationController?.isNavigationBarHidden = false
        navigationController?.pushViewController(locationPicker, animated: true)
        
    }
    
    @IBAction func changeProfileBtn_TouchUpInside(_ sender: Any) {
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
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
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

}

extension SettingTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did Finish Picking Media")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            profileImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            profileImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}

extension SettingTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return")
        textField.resignFirstResponder()
        return true
    }
}



// Delegates to handle events for the location manager.
extension SettingTableViewController: CLLocationManagerDelegate {
    //MARK: Enabling User Current Location
    func enableLocation(){
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLocation = locations.last!
    }

    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }

    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
    }
}
