import SwiftUI

struct FolderView: View {
    var folderName: String
    var folderId: String
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @State private var showChatify: Bool = false
    @State private var showFlashcard: Bool = false
    @State private var showChapter: Bool = false
    @State private var showCreatePopup: Bool = false
    @State private var selectedTab: String = "Flashcards"
    @Environment(\.dismiss) var dismiss
    @ObservedObject var sessionManager = SessionManager.shared
    
    @State private var flashcards: [(id: String, folderId: String, question: String, answer: String)] = []
    @State private var notes: [(id: String, folderId: String, note: String, title: String)] = [] // Store fetched notes
    
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
                        if flashcards.isEmpty {
                            Text("No flashcards available.")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 16) {
                                ForEach(flashcards, id: \.id) { flashcard in
                                    Button(action: {
                                        showFlashcard = true
                                    }) {
                                        VStack {
                                            Text(flashcard.question)
                                                .font(Font.custom("Teko-Bold", size: 16))
                                                .foregroundColor(.white)
                                                .padding()
                                            
                                            Text(flashcard.answer)
                                                .font(Font.custom("Teko-Regular", size: 14))
                                                .foregroundColor(.gray)
                                                .padding(.bottom)
                                        }
                                        .frame(height: 120)
                                        .frame(maxWidth: .infinity)
                                        .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "7B83EB"), Color(hex: "4D4D9A")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .cornerRadius(12)
                                    }
                                    .multilineTextAlignment(.center)
                                }
                            }
                            .padding()
                        }
                    } else {
                        if notes.isEmpty {
                            Text("No notes available.")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            VStack(spacing: 12) {
                                ForEach(notes, id: \.id) { note in
                                    Button(action: {
                                        showChapter = true
                                    }) {
                                        VStack {
                                            Text(note.title)  // Display note title instead of the entire note
                                                .font(Font.custom("Teko-Bold", size: 26))
                                                .foregroundColor(.white)
                                                .padding()
                                                .frame(maxWidth: .infinity)
                                                .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "7B83EB"), Color(hex: "4D4D9A")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                                .cornerRadius(12)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding()
                        }
                    }
                }
                
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
            .edgesIgnoringSafeArea(.top)
            .background(Color(hex: "E8EBFA").edgesIgnoringSafeArea(.all))
            .navigationBarBackButtonHidden(true)
            .onAppear {
                fetchFlashcards()
                fetchNotes()
            }
        }
    }
    
    private func fetchFlashcards() {
        isLoading = true
        errorMessage = nil
        
        FlashcardNetworkManager.shared.getFlashcards(for: Int(folderId) ?? 0) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let response):
                    if let responseDict = response as? [String: Any], let flashcardsData = responseDict["flashcards"] as? [[String: Any]] {
                        self.flashcards = flashcardsData.compactMap { flashcardData in
                            if let id = flashcardData["id"] as? Int,
                               let folderId = flashcardData["folder_id"] as? Int,
                               let question = flashcardData["question"] as? String,
                               let answer = flashcardData["answer"] as? String {
                                return (id: "\(id)", folderId: "\(folderId)", question: question, answer: answer)
                            }
                            return nil
                        }
                        print("Fetched flashcards: \(self.flashcards)")  // Debugging the fetched flashcards
                    }
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func fetchNotes() {
        isLoading = true
        errorMessage = nil
        
        NoteNetworkManager.shared.getNotes(for: Int(folderId) ?? 0) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let response):
                    if let responseDict = response as? [String: Any], let notesData = responseDict["notes"] as? [[String: Any]] {
                        self.notes = notesData.compactMap { noteData in
                            // Change id and folder_id to Int, as the response shows them as integers
                            if let id = noteData["id"] as? Int,
                               let folderId = noteData["folder_id"] as? Int,
                               let note = noteData["note"] as? String,
                               let title = noteData["title"] as? String {
                                return (id: "\(id)", folderId: "\(folderId)", note: note, title: title)
                            }
                            return nil
                        }
                        print("Fetched notes: \(self.notes)")  // Debugging the fetched notes
                    }
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}
