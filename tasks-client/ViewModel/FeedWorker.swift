//
//  FeedFetcher.swift
//  tasks-client
//
//  Created by milkyway on 26.09.2020.
//

import Foundation

class FeedWorker: ObservableObject {
    @Published private var feedData = Feed()
    
//    init(model: Feed) {
//        feedData = model
//    }
    
    var personalTasks: [Feed.Task] {
        feedData.personalTasks
    }
    
    var groupTasks: [Feed.Task] {
        feedData.groupTasks
    }
    
    
    
	func updateFeed(for id: Int, _ type: FeedType, completion: @escaping (Result) -> Void) {
        var getFeedUrl: URL
//        var isDoneUrl: URL
        if type == .personal {
            getFeedUrl = URL(string: "http://127.0.0.1:8888/api/getUserTasks?userId=\(id)")!
        } else {
            getFeedUrl = URL(string: "http://127.0.0.1:8888/api/getGroupTasks?userId=\(id)")!
        }
//        isDoneUrl = URL(string: "http://192.168.1.222:8888/api/getGroupTasks?userId=\(id)")!
        
        var feedRequest = URLRequest(url: getFeedUrl)
        feedRequest.httpMethod = "GET"
        feedRequest.timeoutInterval = 5
        
        let session = URLSession.shared
        session.dataTask(with: feedRequest) { (data, response, error) in
            if let rawData = data {
                do {
                    let resp: FeedData = try JSONDecoder().decode(FeedData.self, from: rawData)
                    if let userData = resp.tasks {
                        print(userData)
                        DispatchQueue.main.async {
                            self.feedData.pushTask(array: userData, type)
							completion(.success)
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
    }
}
