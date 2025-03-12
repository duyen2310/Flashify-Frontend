import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isNavigatingToSignUp = false
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
                    Text("Welcome Back")
                        .font(Font.custom("Teko-Bold", size: 36))
                        .foregroundColor(Color(hex: "4D4E8C"))
                        .padding(.top, 75.0)
                    
                    VStack(spacing: 25) {
                        TextField("Email", text: $email)
                            .padding()
                            .frame(width: 250, height: 50)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(hex: "E1E1E1"), lineWidth: 3)
                            )

                        SecureField("Password", text: $password)
                            .padding()
                            .frame(width: 250, height: 50)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(hex: "E1E1E1"), lineWidth: 3)
                            )
                    }
                    .padding(.top)
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.top)
                    }

                    Button(action: loginUser) {
                        if isLoading {
                            ProgressView()
                        } else {
                            Text("Sign In")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .frame(width: 250.0)
                                .background(Color(hex: "7B83EB"))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .disabled(isLoading)
                    .padding([.top, .leading, .trailing])
                    .frame(width: 220.0)
                    
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
                        HomePageView() // No need to pass accessToken manually anymore
                    }
                }
                .frame(maxWidth: 350)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 10)
            }
        }
    }

    // MARK: - Login Logic
    func loginUser() {
        isLoading = true
        errorMessage = nil

        UserNetworkManager.shared.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let token):
                    SessionManager.shared.accessToken = token  // Update global state
                    isNavigatingToHomePage = true
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}


#Preview {
    LoginView()
}
