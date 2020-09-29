//
//  FeedFetcher.swift
//  tasks-client
//
//  Created by milkyway on 26.09.2020.
//

import Foundation

class FeedFetcher: ObservableObject {
    @Published var feedData = Feed()
    
//    init(model: Feed) {
//        feedData = model
//    }
    
    var personalTasks: [Feed.Task] {
        feedData.personalTasks
    }
    
    var groupTasks: [Feed.Task] {
        feedData.groupTasks
    }
    
    
    
    func fetch(for id: Int, _ type: FeedType) {
        var url: URL
        if type == .personal {
            url = URL(string: "http://192.168.1.222:8888/api/getUserTasks?userId=\(id)")!
        } else {
            url = URL(string: "http://192.168.1.222:8888/api/getGroupTasks?userId=\(id)")!
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 20
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let resp: FeedData = try JSONDecoder().decode(FeedData.self, from: data)
                    if let userData = resp.tasks {
                        print(userData)
                        DispatchQueue.main.async {
                            self.feedData.pushTask(array: userData, type)
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
    
    struct FeedData: Codable {
        var error: APIError?
        var tasks: [Feed.Task]?
    }
}
