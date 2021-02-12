//
//  MenuOptions.swift
//  ToDoList
//
//  Created by Giorgi on 2/12/21.
//

import UIKit

enum MenuOptions: Int, CaseIterable, CustomStringConvertible {
    case settings
    case userProfile
    case logout
    
    var description: String {
        switch self {
        case .settings: return "Settings"
        case .userProfile: return "User Profile"
        case .logout: return "Log Out"
        }
    }
}
