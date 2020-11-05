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

struct DoneData: Codable {
    var done: Bool?
    var error: APIError?
}

struct LoginData: Codable {
    var error: APIError?
    var user: UserData?
}

struct UserData: Codable {
    var id: Int
    var username: String
	var type: Int
    var firstname: String
    var lastname: String
}
