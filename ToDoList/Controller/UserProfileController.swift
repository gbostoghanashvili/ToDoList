//
//  UserProfileController.swift
//  ToDoList
//
//  Created by Giorgi on 2/8/21.
//

import UIKit

class UserProfileController: UIViewController {
    //MARK: - Properties
    
    private let userProfileView = UserProfileView()
    
    private var user: User?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUi()
        fetchUser()
    }
    
    //MARK: - API
    
    func fetchUser() {
        Service.fetchUser { user in
            self.user = user
            self.userProfileView.user = user
        }
    }
    
    //MARK: - Helpers
    
    func configureUi() {
        view.backgroundColor = .white
        
        view.addSubview(userProfileView)
        userProfileView.fillSuperview()
        userProfileView.delegate = self
        

    }
    
    func configureImagePicker() -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        
        let alert = UIAlertController(title: "Choose Your Profile Picture", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
        let fromCameraAction = UIAlertAction(title: "Take Picture", style: .default) { [weak self] _ in
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.cameraDevice = .front
            imagePicker.showsCameraControls = true
            imagePicker.isNavigationBarHidden = false
            imagePicker.isToolbarHidden = true
            
            self?.present(imagePicker, animated: true, completion: nil)
        }
        
        let fromLlibraryAction = UIAlertAction(title: "Choose From Library", style: .default) { [weak self] _ in
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            
            self?.present(imagePicker, animated: true, completion: nil)
        }

        alert.addAction(fromCameraAction)
        alert.addAction(fromLlibraryAction)
        alert.addAction(cancelAction)
      
        present(alert, animated: true)
        
        return imagePicker
    }

}


extension UserProfileController: UserProfileViewDelegate {
    func handleBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func handleShowImagePicker() {
        let picker = configureImagePicker()
        picker.delegate = self
    }
}


//MARK: - UIImagePickerControllerDelegate && UINavigationControllerDelegate

extension UserProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
func imagePickerController(_ picker: UIImagePickerController,
                           didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let user = self.user else {return}
    guard let image = info[.editedImage] as? UIImage else {return}
    let uuid = NSUUID().uuidString
    showLoader(true)
        ImageService.uploadImage(image: image, uuid: uuid) { imageUrl in
            Service.setProfileImageUrl(forUser: user, imageUrl: imageUrl)
            self.showLoader(false)
            self.userProfileView.addPhotoButton.setTitle("Change Photo", for: .normal)
        
    }

    userProfileView.profileImageView.layer.masksToBounds = true
    userProfileView.profileImageView.layer.borderColor = UIColor.white.cgColor
    userProfileView.profileImageView.layer.borderWidth = 2
    userProfileView.profileImageView.image = image.withRenderingMode((.alwaysOriginal))
            
    picker.dismiss(animated: true, completion: nil)
    
    }
}
