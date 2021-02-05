//
//  Service.swift
//  ToDoList
//
//  Created by Giorgi on 2/5/21.
//

import Firebase

struct Service {
    static func setData(taskUid uid: String, title: String) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
        
        let data : [String: Any] = [ "title" : title,
                                     "uid" : uid,
                                     "isCompleted" : false,
                                     "timestamp" : Timestamp(date: Date())]
        
        API.collectionUsers.document(currentUserUid).collection("tasks").document(uid).setData(data)
    }
    
    static func fetchData(completion: @escaping([Task]) -> Void) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return}

        var tasks = [Task]()
        API.collectionUsers.document(currentUserUid).collection("tasks").order(by: "timestamp", descending: true).addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    tasks.append(Task(dictionary: dictionary))
                    tasks.sort {$0.timestamp.seconds > $1.timestamp.seconds}
                    completion(tasks)
                }
            })
        }
    }
    
    static func deleteTaks(withUid uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
        API.collectionUsers.document(currentUserUid).collection("tasks").document(uid).delete(completion: completion)
    }
    
    static func editTask(title: String, taskUid uid: String) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
        API.collectionUsers.document(currentUserUid).collection("tasks").document(uid).updateData(["title": title])
    }
    
    static func changeCompletionStatus(forTaskId uid: String, completionStatus status: Bool) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
        API.collectionUsers.document(currentUserUid).collection("tasks").document(uid).updateData(["isCompleted": status])
    }
}
