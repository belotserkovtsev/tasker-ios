//
//  AuthenticateView.swift
//  tasks-client
//
//  Created by milkyway on 29.09.2020.
//

import SwiftUI

struct AuthenticateView: View {
    @Binding var username: String
    @EnvironmentObject var user: UserAuth
    @State private var feedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        VStack(spacing: .zero) {
            Image("loginImage")
                .padding(.bottom, 48)
            Text("Добро пожаловать!")
                .font(.system(size: 28, weight: .bold))
                .padding(.bottom, 13)
            Text("Используйте имя пользователя для входа в систему")
                .foregroundColor(Color("captionGray"))
//                .opacity(0.7)
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
                self.user.login(user: username) { result in
                    switch result {
                    case .failure(let err):
                        feedback.notificationOccurred(.error)
                        print(err)
                    case .success:
                        feedback.notificationOccurred(.success)
                    }
                }
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
        .onAppear {
            feedback.prepare()
        }
    }
}

struct AuthenticateView_Previews: PreviewProvider {
    @State static var username = ""
    static var previews: some View {
        AuthenticateView(username: $username)
            .preferredColorScheme(.dark)
//            .colorScheme(.dark)
    }
}
