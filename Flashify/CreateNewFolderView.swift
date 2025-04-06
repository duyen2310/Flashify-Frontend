import SwiftUI

struct CreateNewFolderView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var isVisible: Bool
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @ObservedObject var sessionManager = SessionManager.shared
    var onFolderCreated: (() -> Void)? // Callback function

    var body: some View {
        VStack(spacing: 20) {
            Text("Create New Folder")
                .font(Font.custom("Teko-Bold", size: 36))
                .foregroundColor(Color(hex: "4D4E8C"))
            
            TextField("Folder Name", text: $name)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            TextField("Folder Description", text: $description)
                .frame(height: 120)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            if isLoading {
                ProgressView("Creating Folder...")
                    .progressViewStyle(CircularProgressViewStyle())
            }
            
            HStack {
                Button(action: {
                    createFolder()
                }) {
                    Text("Add")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "7B83EB"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    isVisible = false
                }) {
                    Text("Cancel")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "EB7B7D"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .frame(width: 350, height: 450)
        .onAppear {
            print("Session Manager Access Token: \(sessionManager.accessToken ?? "No Token")")
        }
    }
    
    private func createFolder() {
        guard !name.isEmpty else {
            errorMessage = "Folder name is required."
            return
        }
        
        errorMessage = nil
        isLoading = true
        
        FolderNetworkManager.shared.createFolder(name: name, description: description) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(_):
                    dismiss()
                    onFolderCreated?()
                case .failure(let error):
                   errorMessage = error.localizedDescription
                }
            }
        }
    }
}
