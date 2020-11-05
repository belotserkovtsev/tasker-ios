//
//  User.swift
//  tasks-client
//
//  Created by milkyway on 24.09.2020.
//

import Foundation

class UserAuth: ObservableObject {
    
    @Published var userData = User()
    
    var loggedIn: Bool {
        userData.loggedIn
    }
    
    var id: Int? {
        userData.id
    }
    
    var username: String? {
        userData.username
    }
    
    var firstname: String? {
        userData.firstname
    }
    
    var lastname: String? {
        userData.lastname
    }
	
	var userType: UType? {
		userData.userType
	}
    
    //MARK: Intents
    
    func login(user username: String, completion: @escaping (Result) -> Void) {
        if let url = URL(string: "http://127.0.0.1:8888/api/checkUser?username=\(username)") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.timeoutInterval = 2
            
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let rawData = data {
                    do {
                        let resp: LoginData = try JSONDecoder()
							.decode(LoginData.self, from: rawData)
                        if let userData = resp.user {
                            completion(.success)
                            DispatchQueue.main.async {
                                self.userData.logUserIn(
                                    username: userData.username,
                                    id: userData.id,
									type: userData.type,
                                    firstname: userData.firstname,
                                    lastname: userData.lastname
                                )
                            }
                        } else if let err = resp.error {
                            completion(.failure(err))
                        }
                    } catch {
                        completion(.failure(APIError(id: 6, message: "Couldn't decode")))
                    }
                } else {
                    completion(.failure(APIError(id: 5, message: "Server failure")))
                }
            }
            .resume()
        } else {
            completion(.failure(APIError(id: 3, message: "incorrect request")))
        }
    }
    
}
