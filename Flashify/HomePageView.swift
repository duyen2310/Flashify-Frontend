import SwiftUI

struct HomePageView: View {
    @State private var selectedFolder: String? = nil
    @State private var isProfilePopupVisible = false
    @State private var isNewFolderVisible = false
    @ObservedObject var sessionManager = SessionManager.shared
    @State private var folders: [(id: String, name: String)] = []  // Store both folderId and folderName
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @State private var searchText: String = ""
    
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HeaderView(isProfilePopupVisible: $isProfilePopupVisible, isNewFolderVisible: $isNewFolderVisible,
                        searchText: $searchText)
                    
                    if isLoading {
                        ProgressView("Loading Folders...")
                            .progressViewStyle(CircularProgressViewStyle())
                    }

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding()
                    }

                    FolderListView(folders: $folders, selectedFolder: $selectedFolder, searchText: $searchText)

                }
                .background(Color(hex: "E8EBFA").edgesIgnoringSafeArea(.all))
                .onAppear {
                    fetchFolders()
                }
                
                if isProfilePopupVisible {
                    OverlayView(isVisible: $isProfilePopupVisible) {
                        ProfilePopupView(isVisible: $isProfilePopupVisible)
                    }
                }

                if isNewFolderVisible {
                    OverlayView(isVisible: $isNewFolderVisible) {
                        CreateNewFolderView(isVisible: $isNewFolderVisible, onFolderCreated: {
                            fetchFolders()
                            isNewFolderVisible = false
                        })
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func fetchFolders() {
        isLoading = true
        errorMessage = nil

        FolderNetworkManager.shared.getFolders { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let response):
                    // Ensure the response is a dictionary and then extract the "folders" key
                    if let responseDict = response as? [String: Any], let foldersData = responseDict["folders"] as? [[String: Any]] {
                        // Map the folder data into the desired format
                        self.folders = foldersData.compactMap { folderData in
                            if let id = folderData["id"] as? Int, let name = folderData["name"] as? String {
                                return (id: "\(id)", name: name) // Convert id to String to match your model
                            }
                            return nil
                        }
                    }
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

}

// MARK: - Header View
struct HeaderView: View {
    @Binding var isProfilePopupVisible: Bool
    @Binding var isNewFolderVisible: Bool
    @Binding var searchText: String
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(hex: "7B83EB"), Color(hex: "4D4D9A")]),
                           startPoint: .top,
                           endPoint: .bottom)
                .frame(height: 190)
                .clipShape(RoundedCorner(radius: 30, corners: [.bottomLeft, .bottomRight]))
                .edgesIgnoringSafeArea(.all)
                .shadow(radius: 5)

            VStack(spacing: 10) {
                HStack {
                    Text("Flashify")
                        .font(Font.custom("Teko-Bold", size: 36))
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        withAnimation {
                            isProfilePopupVisible.toggle()
                        }
                    }) {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                .padding(.top, -50.0)

                HStack {
                    TextField("Search folders", text:$searchText)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(10)
                    Button(action: {
                        withAnimation {
                            isNewFolderVisible.toggle()
                        }
                    }) {
                        Image(systemName: "plus.square.fill")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundColor(Color(hex: "7B83EB"))
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30.0)
            }
        }
    }
}

// MARK: - Folder List View
struct FolderListView: View {
    @Binding var folders: [(id: String, name: String)]
    @Binding var selectedFolder: String?
    @Binding var searchText: String  // Accept searchText as a binding

    var filteredFolders: [(id: String, name: String)] {
        folders.filter { searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 20) {
                ForEach(filteredFolders, id: \.id) { folder in
                    NavigationLink(destination: FolderView(folderName: folder.name, folderId: Int(folder.id) ?? 00), tag: folder.id, selection: $selectedFolder) {
                        Button(action: {
                            selectedFolder = folder.id
                        }) {
                            VStack {
                                Image(systemName: "folder")
                                    .resizable()
                                    .frame(width: 60, height: 50)
                                    .foregroundColor(Color(hex: "7B83EB"))
                                Text(folder.name)
                                    .font(Font.custom("Teko-Bold", size: 16))
                                    .foregroundColor(Color(hex: "4D4D9A"))
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .contextMenu {
                            Button(role: .destructive) {
                                deleteFolder(folderId: folder.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private func deleteFolder(folderId: String) {
        guard let folderIdInt = Int(folderId) else { return }

        FolderNetworkManager.shared.deleteFolder(id: folderIdInt) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    // Remove the deleted folder from the list
                    folders.removeAll { $0.id == folderId }
                case .failure(let error):
                    print("Failed to delete folder: \(error.localizedDescription)")
                }
            }
        }
    }
}



// MARK: - Overlay View (for Profile and New Folder)
struct OverlayView<Content: View>: View {
    @Binding var isVisible: Bool
    let content: Content

    init(isVisible: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isVisible = isVisible
        self.content = content()
    }

    var body: some View {
        Color.black.opacity(0.3)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                withAnimation {
                    isVisible = false
                }
            }
            .overlay(content)
    }
}

// MARK: - Custom Rounded Corner Shape
struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    HomePageView()
}
