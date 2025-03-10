import SwiftUI


struct CreateFlashcardView: View {
    @Environment(\.dismiss) var dismiss
    @State private var question: String = ""
    @State private var answer: String = ""
    @State private var topic: String = ""
    @State private var createOption: String = "Manually"
    @State private var selectedFileURL: URL?
    @State private var showingFileImporter = false
    var body: some View {
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                HStack {
                    Text("Create Flashcards")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "4D4D9A"))
                    
                    Spacer()
                    
            
                }

                HStack {
                    Button(action: { createOption = "Manually" }) {
                        Text("Manually")
                            .padding()
                            .background(createOption == "Manually" ? Color.black : Color.gray.opacity(0.3))
                            .foregroundColor(createOption == "Manually" ? .white : .black)
                            .cornerRadius(8)
                    }
                    
                    Button(action: { createOption = "Generate" }) {
                        Text("Generate")
                            .padding()
                            .background(createOption == "Generate" ? Color.black : Color.gray.opacity(0.3))
                            .foregroundColor(createOption == "Generate" ? .white : .black)
                            .cornerRadius(8)
                    }
                }

                if createOption == "Manually" {
                    TextField("Question", text: $question)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    TextField("Answer",text: $answer)
                        .frame(height: 120)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                } else {
                    VStack(spacing: 20) {
                            Button(action: {
                                showingFileImporter = true
                            }) {
                                VStack {
                                    Image(systemName: "doc.badge.plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.black)

                                    Text("Upload File")
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, minHeight: 150)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            }
                            .fileImporter(
                                isPresented: $showingFileImporter,
                                allowedContentTypes: [.plainText, .json],
                                onCompletion: { result in
                                    switch result {
                                    case .success(let url):
                                        selectedFileURL = url
                                        print("Selected file: \(url.lastPathComponent)")
                                    case .failure(let error):
                                        print("File import failed: \(error.localizedDescription)")
                                    }
                                }
                            )

                            if let fileURL = selectedFileURL {
                                Text("Selected file: \(fileURL.lastPathComponent)")
                                    .foregroundColor(.blue)
                                    .padding(.top)
                            }
                    }
                    .padding(.vertical, 30.0)
                    }

                HStack {
                    Button(action: {
                        if createOption == "Manually" {
                            print("Manually Added Flashcard: \(question) - \(answer)")
                        } else {
                            print("Generating flashcards for topic: \(topic)")
                        }
                        dismiss()
                    }) {
                        Text("Add")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "7B83EB"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        dismiss()
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
            .frame(width: 350, height: 450)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }
}

#Preview {
    CreateFlashcardView()
}
