//
//  SignUpView.swift
//  Flashify
//
//  Created by Ky Duyen on 28/2/25.
//

import SwiftUI

struct SignUpView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [Color(hex: "7B83EB"), Color.white]),
                           startPoint: .top,
                           endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Welcome to Flashify")
                    .padding(.top, 50)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "333333"))
                
                VStack(spacing: 12) {
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.all)
                        .frame(width: 250)
                        
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.leading, .bottom, .trailing])
                        .frame(width: 250)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .frame(width: 250)
                }
                
                // signUp button
                // Backend func
                Button(action: {
                    print("Sign Up tapped")
                }) {
                    Text("Sign Up")
                        .frame(width: 200)
                        .padding()
                        .background(Color(hex: "7B83EB"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .frame(width: 200.0)
                .padding()
                
                // sigIn link
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.gray)
                    Button(action: {
                        print("Sign In tapped")
                    }) {
                        Text("Sign in")
                            .foregroundColor(Color(hex: "7B83EB"))
                            .fontWeight(.bold)
                    }
                }
                .padding(.bottom, 50)
                .font(.footnote)
            }
            .padding()
            .frame(maxWidth: 350)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 10)
        }
    }
}
#Preview {
    SignUpView()
}
