//
//  ContentView.swift
//  tasks-client
//
//  Created by milkyway on 24.09.2020.
//

import SwiftUI

struct ContentView: View {
    @State var username = ""
    @EnvironmentObject var user: UserWorker
    
    var body: some View {
        if !user.loggedIn {
            AuthenticateView(username: $username)
        } else {
            AuthenticatedView()
                .environmentObject(FeedWorker())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
