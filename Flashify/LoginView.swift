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
                        .font(Font.custom("Teko-Bold", size: 36))
                        .foregroundColor(Color(hex: "4D4E8C"))
                        .padding(.top, 75.0)
                    
                    VStack(spacing: 25) {
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
                    .padding(.top)
                    
                    Button(action: {
                        isNavigatingToHomePage = true
                    }) {
                        Text("Sign In")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .frame(width: 250.0)
                            .background(Color(hex: "7B83EB"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding([.top, .leading, .trailing])
                    .frame(width: 220.0)
                    
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