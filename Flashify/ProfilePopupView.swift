import SwiftUI

struct ProfilePopupView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var isVisible: Bool
    @State private var isNavigatingToLogIn = false
    @ObservedObject var sessionManager = SessionManager.shared
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            Text("Profile")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "4D4D9A"))
                .padding()

          
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                
                TextField("Username: \(username)", text: .constant(username))
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .disabled(true)

                TextField("Email: \(email)", text: .constant(email))
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .disabled(true)

                // Show error message if there is any
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
            }

            HStack {
                Button(action: {
                    withAnimation {
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
                    logoutUser()
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
        .onAppear {
            fetchUserProfile()
        }
    }

    func fetchUserProfile() {
        // Start loading
        isLoading = true
        errorMessage = nil
        
        UserNetworkManager.shared.fetchUserProfile { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let response):
                    
                    if let user = response["user"] as? [String: Any] {
                        if let username = user["username"] as? String,
                           let email = user["email"] as? String {
                            self.username = username
                            self.email = email
                        }
                    } else {
                        errorMessage = "Invalid response structure."
                    }
                case .failure(let error):
                    errorMessage = "Failed to load profile: \(error.localizedDescription)"
                }
            }
        }
    }

    

    // Logout logic
    func logoutUser() {
        sessionManager.logout()
        withAnimation {
            isNavigatingToLogIn = true
        }
    }
}

#Preview {
    ProfilePopupView(isVisible: .constant(true))
}
