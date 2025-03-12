//
//  ProfilePopupView.swift
//  Flashify
//
//  Created by Ky Duyen on 1/3/25.
//

import SwiftUI
struct ProfilePopupView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var isVisible: Bool
    @State private var isNavigatingToLogIn = false

    var body: some View {
        VStack {
            Text("Profile")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "4D4D9A"))
                .padding()

            TextField("Username: John Doe", text: .constant(""))
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .disabled(true)

            TextField("Email: johndoe@gmail.com", text: .constant(""))
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .disabled(true)

            HStack {
                Button(action: {
                    withAnimation{
                        isVisible = false
                    }
                }) {
                    Text("Cancel")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "7B83EB"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    isNavigatingToLogIn = true
                }) {
                    Text("Logout")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "EB7B7D"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .navigationDestination(isPresented: $isNavigatingToLogIn) {
                LoginView()
            }
            .padding(.horizontal)
            Spacer()
        }
        .padding()
        .frame(width: 300, height: 300)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}