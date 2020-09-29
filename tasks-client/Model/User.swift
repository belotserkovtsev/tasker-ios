//
//  User.swift
//  tasks-client
//
//  Created by milkyway on 26.09.2020.
//

import Foundation

struct User {
    private(set) var id: Int? = 1
    private(set) var username: String? = "bogdan"
//    private(set) var lastname: String?
//    private(set) var firstname: String?
    
    
    private(set) var loggedIn = false
    
    mutating func logUserIn(username: String, id: Int) {
        self.id = id
        self.username = username
        self.loggedIn = true
    }
}
