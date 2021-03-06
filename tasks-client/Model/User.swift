//
//  User.swift
//  tasks-client
//
//  Created by milkyway on 26.09.2020.
//

import Foundation

struct User {
    private(set) var id: Int?
    private(set) var username: String?
    private(set) var lastname: String?
    private(set) var firstname: String?
	
	private(set) var userType: UserType?
    private(set) var loggedIn = false
    
	mutating func logUserIn(username: String, id: Int, type: Int, firstname: String, lastname: String) {
        self.id = id
        self.username = username
        self.loggedIn = true
        self.firstname = firstname
        self.lastname = lastname
		
		self.userType = type == 0 ? .subordinate : .head
    }
	
	enum UserType {
		case subordinate, head
	}
}
