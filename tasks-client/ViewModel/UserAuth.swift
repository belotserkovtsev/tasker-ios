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
    
    //MARK: Intents
    
    func login(user username: String) {
        guard username.count > 0 else {
            return
        }
        let url: URL = URL(string: "http://192.168.1.222:8888/api/checkUser?username=\(username)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 20
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let resp: LoginData = try JSONDecoder().decode(LoginData.self, from: data)
                    if let userData = resp.user {
                        DispatchQueue.main.async {
                            self.userData.logUserIn(username: userData.username, id: userData.id)
                        }
                    }
//                    print(test)
                } catch {
                    print(error)
                }
            }
        }
        .resume()
    }
    
    struct LoginData: Codable {
        var error: APIError?
        var user: UserData?
    }
    
    struct UserData: Codable {
        var id: Int
        var username: String
    }
    
}



//enum loginError: Codabble {
//    case invalidRequest(Int)
//}
//
//extension loginError {
//    enum Key: CodingKey {
//        case rawValue
//        case associatedValue
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: Key.self)
//        let rawValue = try container.decode(Int.self, forKey: .rawValue)
//        switch rawValue {
//        case 0:
//            let id = try container.decode(Int.self, forKey: .associatedValue)
//            self = .invalidRequest(id)
//        default:
//            throw
//        }
//    }
//
//    func encode(to encoder: Encoder) throws {
//
//    }
//}
