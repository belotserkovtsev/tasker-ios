//
//  ProfileView.swift
//  tasks-client
//
//  Created by milkyway on 27.09.2020.
//

import SwiftUI

struct AuthenticatedView: View {
	
    var body: some View {
		TabView {
			FeedView()
				.tabItem {
					Image(systemName: "square.and.pencil")
					Text("Задания")
				}
			
			ProfileView()
				.tabItem {
					Image(systemName: "person")
					Text("Профиль")
				}
		}
		.accentColor(.purple)
    }
}
