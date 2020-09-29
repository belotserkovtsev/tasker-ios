//
//  ContentView.swift
//  tasks-client
//
//  Created by milkyway on 24.09.2020.
//

import SwiftUI

struct ContentView: View {
    @State var username = ""
//    @State var loggedIn = false
    @EnvironmentObject var user: UserAuth
    
    var body: some View {
        if !user.loggedIn {
            AuthenticateView(username: $username)
//                .onReceive(user.$userData){ user in
//                    if user.loggedIn {
//                        withAnimation() {
//                            loggedIn.toggle()
//                        }
//                    }
//                }
//                .transition(.slide)
        } else {
            FeedView()
                .environmentObject(FeedFetcher())
//                .transition(.slide)
        }
    }
}

struct AuthenticateView: View {
    @Binding var username: String
    @EnvironmentObject var user: UserAuth
    
    var body: some View {
        VStack(spacing: .zero) {
            Image("loginImage")
                .padding(.bottom, 48)
            Text("Добро пожаловать!")
                .font(.system(size: 28, weight: .bold))
                .padding(.bottom, 13)
            Text("Используйте имя пользователя для входа в систему")
                .multilineTextAlignment(.center)
                .frame(maxWidth: 259)
                .padding(.bottom, 43)
            
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundColor(Color("inputFieldBlack"))
                TextField("Имя пользователя", text: $username)
                    .padding(.leading, 20)
            }
            .frame(width: 359, height: 56)
            .padding(.bottom, 8)
            
            Button(action: {
                self.user.login(user: username)
            }){
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .frame(width: 359, height: 58)
                        .foregroundColor(Color("loginButtonPink"))
                    Text("Войти")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
