//
//  ContentView.swift
//  tasks-client
//
//  Created by milkyway on 24.09.2020.
//

import SwiftUI

struct ContentView: View {
    @State var username = ""
    @EnvironmentObject var user: UserAuth
    
    var body: some View {
        if !user.loggedIn {
            AuthenticateView(username: $username)
        } else {
            FeedView()
                .environmentObject(FeedFetcher())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
