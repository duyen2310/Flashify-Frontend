import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isNavigatingToSignUp = false
    @State private var isNavigatingToHomePage = false


    var body: some View {
        NavigationStack { 
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(hex: "7B83EB"), Color.white]),
                               startPoint: .top,
                               endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("Welcome Back")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(hex: "333333"))
                        .padding(.top, 50.0)
                    
                    VStack(spacing: 12) {
                        TextField("Email", text: $email)
                            .frame(width: 200.0)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.all)
                        
                        SecureField("Password", text: $password)
                            .frame(width: 200.0)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding([.leading, .bottom, .trailing])
                    }
                    
                    Button(action: {
                        isNavigatingToHomePage = true
                    }) {
                        Text("Sign In")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .frame(width: 200.0)
                            .background(Color(hex: "7B83EB"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    .frame(width: 200.0)
                    
                    // Sign up link
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.gray)
                        Button(action: {
                            isNavigatingToSignUp = true
                        }) {
                            Text("Sign up")
                                .foregroundColor(Color(hex: "7B83EB"))
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.bottom, 50.0)
                    .font(.footnote)
                    
                    .navigationDestination(isPresented: $isNavigatingToSignUp) {
                        SignUpView()
                    }
                    .navigationDestination(isPresented: $isNavigatingToHomePage) {
                        HomePageView()
                    }
                }
//                .padding()
                .frame(maxWidth: 350)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 10)
            }
        }
    }
}

#Preview {
    LoginView()
}