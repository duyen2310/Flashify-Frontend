import SwiftUI

struct FolderView: View {
    var folderName: String
    @State private var showChatify: Bool = false
    @State private var showCreatePopup: Bool = false
    @State private var selectedTab: String = "Flashcards"
    @Environment(\.dismiss) var dismiss

    let flashcards = [
        "In what way does calculus contribute to the field of engineering?",
        "How does calculus contribute to advancement in computer science?",
        "What is the integral of f(x)=3x²?",
        "What is the derivative of f(x)=x²?",
        "What is the limit definition of a derivative?"
    ]
    
    let chapters = [
        "Chapter : 1",
        "Chapter : 2",
        "Chapter : 3",
        "Chapter : 4",
        "Chapter : 5"
    ]
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text(folderName)
                        .font(Font.custom("Teko-Bold", size: 36))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        showCreatePopup.toggle()
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .padding(.top, 50)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(hex: "7B83EB"), Color(hex: "4D4D9A")]), startPoint: .top, endPoint: .bottom)
                )
                
                HStack {
                    Button(action: { selectedTab = "Flashcards" }) {
                        Text("Flashcards")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(selectedTab == "Flashcards" ? Color.black : Color.white)
                            .foregroundColor(selectedTab == "Flashcards" ? .white : .black)
                            .cornerRadius(8)
                    }
                    
                    Button(action: { selectedTab = "Notes" }) {
                        Text("Notes")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(selectedTab == "Notes" ? Color.black : Color.white)
                            .foregroundColor(selectedTab == "Notes" ? .white : .black)
                            .cornerRadius(8)
                    }
                }
                .padding()
                .shadow(radius: 2)
                
                ScrollView {
                    if selectedTab == "Flashcards" {
                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 16) {
                            ForEach(flashcards, id: \.self) { flashcard in
                                Text(flashcard)
                                    .font(Font.custom("Teko-Bold", size: 16))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(height: 120)
                                    .frame(maxWidth: .infinity)
                                    .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "7B83EB"), Color(hex: "4D4D9A")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .cornerRadius(12)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding()
                    } else {
                        VStack(spacing: 12) {
                            ForEach(chapters, id: \.self) { chapter in
                                Text(chapter)
                                    .font(Font.custom("Teko-Bold", size: 26))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "7B83EB"), Color(hex: "4D4D9A")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .cornerRadius(12)
                            }
                        }
                        .padding()
                    }
                }
                
            VStack{
                Spacer()
                
                Button(action: {
                    showChatify.toggle()
                }) {
                    Image(systemName: "command")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .sheet(isPresented: $showChatify) {
                    ChatifyView()
                }
                .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .zero, alignment: .bottom)
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color(hex: "E8EBFA").edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)

            if showCreatePopup {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showCreatePopup = false
                    }
                if selectedTab == "Flashcards" {
                    CreateFlashcardView()
                        .frame(width: 350, height: 450)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .overlay(
                            Button(action: {
                                showCreatePopup = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.gray)
                            }
                                .padding()
                                .offset(x: 150, y: -200)
                        )
                        .transition(.scale)
                }else{
                    CreateNoteView()
                        .frame(width: 350, height: 450)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .overlay(
                            Button(action: {
                                showCreatePopup = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.gray)
                            }
                                .padding()
                                .offset(x: 150, y: -200)
                        )
                        .transition(.scale)
                }
            }
        }
    }
}

#Preview {
    FolderView(folderName: "Calculus")
}