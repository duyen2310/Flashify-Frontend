import SwiftUI

struct FolderView: View {
    var folderName: String
    var folderId: Int
    
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var showChatify = false
    @State private var showFlashcard = false
    @State private var showChapter = false
    @State private var showCreatePopup = false
    @State private var selectedTab = "Flashcards"
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var sessionManager = SessionManager.shared
    
    @State private var flashcards: [(id: String, folderId: String, question: String, answer: String)] = []
    @State private var notes: [(id: String, folderId: String, note: String, title: String)] = []
    @State private var selectedNote: (id: String, folderId: Int, note: String, title: String)?
    @State private var selectedFlashcard: (id: String, folderId: Int, question: String, answer: String)?

    let defaultFlashcard = (id: "0", folderId: 0, question: "Default Question", answer: "Default Answer")
    let defaultNote = (id: "0", folderId: 0, note: "Default Note", title: "Default Title")

    var body: some View {
        ZStack {
            VStack {
                // Header
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
                    Button(action: { showCreatePopup.toggle() }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 50)
                .padding(.bottom, 10)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(hex: "7B83EB"), Color(hex: "4D4D9A")]),
                                   startPoint: .top, endPoint: .bottom)
                )

                // Tab
                HStack {
                    ForEach(["Flashcards", "Notes"], id: \.self) { tab in
                        Button(action: { selectedTab = tab }) {
                            Text(tab)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(selectedTab == tab ? Color.black : Color.white)
                                .foregroundColor(selectedTab == tab ? .white : .black)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()

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
                                        selectFlashcard(flashcard)
                                        showFlashcard = true
                                    }) {
                                        VStack {
                                            Text(flashcard.question)
                                                .font(Font.custom("Teko-Bold", size: 16))
                                                .foregroundColor(.white)
                                                .padding(.top)

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
                                        selectNote(note)
                                        showChapter = true
                                    }) {
                                        Text(note.title)
                                            .font(Font.custom("Teko-Bold", size: 26))
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "7B83EB"), Color(hex: "4D4D9A")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                            .cornerRadius(12)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }

                Spacer()

                // Chatify Button
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
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationBarBackButtonHidden(true)
            .onAppear {
                fetchFlashcards()
                fetchNotes()
            }

            // Flashcard Popup
            if showFlashcard {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                    .onTapGesture { showFlashcard = false }

                FlashcardView(isVisible: $showFlashcard, flashcard: selectedFlashcard ?? defaultFlashcard)
                    .frame(width: 350, height: 300)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .transition(.scale)
            }

            // Chapter Popup
            if showChapter {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                    .onTapGesture { showChapter = false }

                ChapterNoteView(isVisible: $showChapter, note: selectedNote ?? defaultNote)
                    .frame(width: 380, height: 750)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .transition(.scale)
            }

            // Create Popup
            if showCreatePopup {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                    .onTapGesture { showCreatePopup = false }

                VStack {
                    if selectedTab == "Flashcards" {
                        CreateFlashcardView(
                            folderId: folderId,
                            isVisible: $showCreatePopup,
                            onCreated: fetchFlashcards
                        )
                    } else {
                        CreateNoteView(
                            folderId: folderId,
                            isVisible: $showCreatePopup,
                            onCreated: fetchNotes
                        )
                    }
                }
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

    private func selectFlashcard(_ flashcard: (id: String, folderId: String, question: String, answer: String)) {
        selectedFlashcard = (id: flashcard.id, folderId: Int(folderId), question: flashcard.question, answer: flashcard.answer)
    }
    
    private func selectNote(_ note: (id: String, folderId: String, note: String, title: String)) {
        selectedNote = (id: note.id, folderId: Int(folderId), note: note.note, title: note.title)
    }


    private func fetchFlashcards() {
        isLoading = true
        errorMessage = nil

        FlashcardNetworkManager.shared.getFlashcards(for: folderId) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let response):
                    if let responseDict = response as? [String: Any],
                       let flashcardsData = responseDict["flashcards"] as? [[String: Any]] {
                        self.flashcards = flashcardsData.compactMap {
                            guard let id = $0["id"] as? Int,
                                  let folderId = $0["folder_id"] as? Int,
                                  let question = $0["question"] as? String,
                                  let answer = $0["answer"] as? String else { return nil }
                            return (id: "\(id)", folderId: "\(folderId)", question: question, answer: answer)
                        }
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

        NoteNetworkManager.shared.getNotes(for: folderId) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let response):
                    if let responseDict = response as? [String: Any],
                       let notesData = responseDict["notes"] as? [[String: Any]] {
                        self.notes = notesData.compactMap {
                            guard let id = $0["id"] as? Int,
                                  let folderId = $0["folder_id"] as? Int,
                                  let note = $0["note"] as? String,
                                  let title = $0["title"] as? String else { return nil }
                            return (id: "\(id)", folderId: "\(folderId)", note: note, title: title)
                        }
                    }
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    FolderView(folderName: "Chemistry", folderId: 4)
}
