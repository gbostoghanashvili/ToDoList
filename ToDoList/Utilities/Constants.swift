//
//  constants.swift
//  ToDoList
//
//  Created by Giorgi on 2/5/21.
//

import Firebase

struct API {
    static let collectionUsers = Firestore.firestore().collection("users")
    static let collectionTasks = Firestore.firestore().collection("tasks")
}
