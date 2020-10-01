//
//  LoginData.swift
//  tasks-client
//
//  Created by milkyway on 29.09.2020.
//

import Foundation

struct FeedData: Codable {
    var error: APIError?
    var tasks: [Feed.Task]?
}

struct LoginData: Codable {
    var error: APIError?
    var user: UserData?
}

struct UserData: Codable {
    var id: Int
    var username: String
    var firstname: String
    var lastname: String
}
