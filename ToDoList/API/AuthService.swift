//
//  AuthService.swift
//  ToDoList
//
//  Created by Giorgi on 2/5/21.
//

import Firebase

typealias FirestoreCompletion = (Error?) -> Void

struct AuthService {
    static func logUserIn(withEmail email: String, password: String,
                          completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    
    static func signUserUp(withCredentials credentials: AuthCredentials,
                             completion: @escaping(FirestoreCompletion)) {
            Auth.auth().createUser(withEmail: credentials.email,
                                   password: credentials.password) { result, error in
                if let error = error {
                    completion(error)
                    return
                    }
                
                guard let uid = result?.user.uid else {return}
                
                let data: [String : Any] = [ "email" : credentials.email,
                                             "username" : credentials.username,
                                             "uid" : uid]
                
                    API.collectionUsers.document("\(uid)").setData(data, completion: completion)
            }
        }
    
    static func resetPassword(withEmail email: String, completion: SendPasswordResetCallback?) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
        }
    }

