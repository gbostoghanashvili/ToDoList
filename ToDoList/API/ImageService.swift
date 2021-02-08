//
//  ImageService.swift
//  ToDoList
//
//  Created by Giorgi on 2/8/21.
//


import FirebaseStorage

struct ImageService {
    
    static func uploadImage(image: UIImage, uuid: String,
                            competion: @escaping(String)-> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        
        let reference = Storage.storage().reference(withPath: "profileImages/\(uuid)")
        
        reference.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("DEBUG: Failed to upload image \(error.localizedDescription)")
                return
                }
            
            reference.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else {return}
                competion(imageUrl)
            }
        }
    }
}

