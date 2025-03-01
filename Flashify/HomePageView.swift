import SwiftUI

struct HomePageView: View {
    @State private var selectedFolder: String? = nil
    
    let folders = ["Mathematics", "Literature", "Biology", "Grammar", "History", "DSA"]

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
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
                            TextField("Search folders", text: .constant(""))
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(10)
                            Button(action: {
                                print("Add new folder")
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

                ScrollView {
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 20) {
                        ForEach(folders, id: \.self) { folder in
                            NavigationLink(destination: FolderView(folderName: folder), tag: folder, selection: $selectedFolder) {
                                Button(action: {
                                    selectedFolder = folder // set the folder selected
                                }) {
                                    VStack {
                                        Image(systemName: "folder")
                                            .resizable()
                                            .frame(width: 60, height: 50)
                                            .foregroundColor(Color(hex: "7B83EB"))
                                        Text(folder)
                                            .font(Font.custom("Teko-Bold", size: 16))
                                            .foregroundColor(Color(hex:"4D4D9A"))

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
                                TextField("Search folders", text: .constant(""))
                                    .padding(10)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                Button(action: {
                                    print("Add new folder")
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

                    ScrollView {
                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 20) {
                            ForEach(folders, id: \.self) { folder in
                                NavigationLink(destination: FolderView(folderName: folder), tag: folder, selection: $selectedFolder) {
                                    Button(action: {
                                        selectedFolder = folder
                                    }) {
                                        VStack {
                                            Image(systemName: "folder")
                                                .resizable()
                                                .frame(width: 60, height: 50)
                                                .foregroundColor(Color(hex: "7B83EB"))
                                            Text(folder)
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.black)
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.horizontal)
                        .navigationBarBackButtonHidden(true)
                    }
                }
                .background(Color(hex: "E8EBFA").edgesIgnoringSafeArea(.all))

                // Profile popup
                if isProfilePopupVisible {
                    Color.black.opacity(0.3) // Dimmed background
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isProfilePopupVisible = false
                            }
                        }
                    
                    ProfilePopupView(isVisible: $isProfilePopupVisible)
                        .transition(.scale) 
                        .zIndex(1) 
                }
            }
        }
        .navigationBarBackButtonHidden(true)

    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

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
