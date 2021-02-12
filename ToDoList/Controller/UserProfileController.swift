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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        fetchUser()
    }
    
    //MARK: - API
    
    func fetchUser() {
        showLoader(true)
        Service.fetchUser { user in
            self.showLoader(false)
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
        
        let removePhotoAction = UIAlertAction(title: "Remove Picture", style: .default) { _ in
            Service.removeUserProfileImageUrl()
            self.fetchUser()
        }

        alert.addAction(fromCameraAction)
        alert.addAction(fromLlibraryAction)
        if user?.profileImageUrl != "" {
            alert.addAction(removePhotoAction)
        }
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
    
    func handleEditUsername() {
        guard let text = user?.username else {return}
        let controller = EditController(field: .username, text: text)
//        controller.usernameText = user?.username
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleEditEmail() {
        guard let text = user?.email else {return}
        let controller = EditController(field: .email, text: text)
//        controller.emailText = user?.email
        
        navigationController?.pushViewController(controller, animated: true)
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
            self.fetchUser()
    }

    userProfileView.profileImageView.layer.masksToBounds = true
    userProfileView.profileImageView.layer.borderColor = UIColor.white.cgColor
    userProfileView.profileImageView.layer.borderWidth = 2
    userProfileView.profileImageView.image = image.withRenderingMode((.alwaysOriginal))
            
    picker.dismiss(animated: true, completion: nil)
    
    }
}
