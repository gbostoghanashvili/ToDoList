//
//  Task.swift
//  ToDoList
//
//  Created by Giorgi on 2/4/21.
//

import Firebase

struct Task {
    let title: String
    let uid: String
    var isCompleted: Bool
    let timestamp: Timestamp
    
    init (dictionary: [String : Any]) {
        self.title = dictionary["title"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.isCompleted = dictionary["isCompleted"] as? Bool ?? false
        self.timestamp = dictionary["Timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
