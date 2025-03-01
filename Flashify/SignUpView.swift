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
                        .font(Font.custom("Teko-Bold", size: 36))                        .foregroundColor(Color(hex: "4D4E8C"))

                    VStack(spacing: 25) {
                        TextField("Username", text: $username)
                            .padding(.all)
                            .frame(width: 250, height: 50)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(hex: "E1E1E1"), lineWidth: 3)
                            )


                        TextField("Email", text: $email)
                            .padding(.all)
                            .frame(width: 250, height: 50)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(hex: "E1E1E1"), lineWidth: 3)
                            )

                        SecureField("Password", text: $password)
                            .padding(.all)
                            .frame(width: 250, height: 50)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(hex: "E1E1E1"), lineWidth: 3)
                            )

                }

                    // BACKEND
                    Button(action: {
                        isNavigatingToHomePage = true
                    }) {
                        Text("Sign Up")
                            .frame(width: 220)
                            .padding()
                            .background(Color(hex: "7B83EB"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .frame(width: 200.0)
                .padding()

                    // Sign In Link
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.gray)
                        Button(action: {
                            isNavigatingToLogIn = true
                        }) {
                            Text("Sign in")
                                .foregroundColor(Color(hex: "7B83EB"))
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.bottom, 50)
                .font(.footnote)

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
}

#Preview {
    SignUpView()
}