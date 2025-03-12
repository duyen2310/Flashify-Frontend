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
    @State private var isNavigatingToLogIn = false
    @State private var isNavigatingToHomePage = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(hex: "7B83EB"), Color.white]),
                               startPoint: .top,
                               endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("Welcome to Flashify")
                        .padding(.top, 50)
                        .font(Font.custom("Teko-Bold", size: 36))
                        .foregroundColor(Color(hex: "4D4E8C"))
                    
                    VStack(spacing: 25) {
                        TextField("Username", text: $username)
                            .textFieldStyle()
                        
                        TextField("Email", text: $email)
                            .textFieldStyle()
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle()
                    }
                    .padding(.top)
                    
                    // Show error message if exists
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                    
                    // Sign Up Button
                    Button(action: signUpUser) {
                        if isLoading {
                            ProgressView()
                        } else {
                            Text("Sign Up")
                                .frame(width: 220)
                                .padding()
                                .background(Color(hex: "7B83EB"))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .disabled(isLoading)
                    .frame(width: 200.0)
                    .padding()
                    
                    // Sign In Link
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.gray)
                        Button(action: { isNavigatingToLogIn = true }) {
                            Text("Sign in")
                                .foregroundColor(Color(hex: "7B83EB"))
                                .fontWeight(.bold)
                        }
                    }
                    .font(.footnote)
                    .padding(.bottom, 50)
                    
                    // Navigation
                    .navigationDestination(isPresented: $isNavigatingToLogIn) {
                        LoginView()
                    }
                    .navigationDestination(isPresented: $isNavigatingToHomePage) {
                        HomePageView()
                    }
                }
                .padding()
                .frame(maxWidth: 350)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 10)
            }
        }
    }
    
    // MARK: - Sign Up Logic
    func signUpUser() {
        isLoading = true
        errorMessage = nil
        
        UserNetworkManager.shared.signUp(username: username, email: email, password: password) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let token):  // Ensure the API returns the token
                    SessionManager.shared.accessToken = token  // Store token in SessionManager
                    isNavigatingToHomePage = true
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

// MARK: - Custom Modifier for TextFields
extension View {
    func textFieldStyle() -> some View {
        self
            .padding()
            .frame(width: 250, height: 50)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(hex: "E1E1E1"), lineWidth: 3)
            )
    }
}

#Preview {
    SignUpView()
}
