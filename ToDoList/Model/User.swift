//
//  User.swift
//  ToDoList
//
//  Created by Giorgi on 2/5/21.
//

import Foundation

struct AuthCredentials {
    let email: String
    let password: String
    let username: String
}


struct User {
    let email: String
    let username: String
    let uid: String
    
    init (dictionary: [String : Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
