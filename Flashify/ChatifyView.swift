import SwiftUI

// Inject AINetworkManager into the view
struct ChatifyView: View {
    @Environment(\.dismiss) var dismiss
    @State private var message: String = ""
    @State private var messages: [String] = [
        "Hey, can you explain a topic for me?",
        "Sure. Please tell me the topic!"
    ]
    @State private var isLoading: Bool = false
    @State private var responseMessage: String = ""

    var folderId: Int
    var noteId: Int

    var body: some View {
        VStack {
            HStack {
                Text("Chatify")
                    .font(Font.custom("Teko-Bold", size: 36))
                    .foregroundColor(Color(hex: "4D4D9A"))
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages, id: \.self) { msg in
                        Text(msg)
                            .padding()
                            .background(Color(hex: "E8EBFA"))
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    if isLoading {
                        Text("Thinking... Please wait.")
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                    if !responseMessage.isEmpty {
                        Text(responseMessage)
                            .padding()
                            .background(Color(hex: "E8EBFA"))
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
            }

            HStack {
                TextField("Ask me something ...", text: $message)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)

                Button(action: {
                    if !message.isEmpty {
                        messages.append(message)
                        isLoading = true
                        interactWithFlashcardOrNote(message: message)
                        message = ""
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.black)
                        .font(.title2)
                }
            }
            .padding()
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }

    func interactWithFlashcardOrNote(message: String) {
        if message.contains("flashcard") {
            interactWithFlashcard(prompt: message)
        } else if message.contains("note") {
            interactWithNote(prompt: message)
        } else {
            // Handle unknown cases, maybe some default behavior
            responseMessage = "One moment, loading"
            isLoading = false
        }
    }

    func interactWithFlashcard(prompt: String) {
        AINetworkManager.shared.interactWithFlashcard(folderId: folderId, prompt: prompt) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    messages.append(response)
                    isLoading = false
                case .failure(let error):
                    messages.append("Error: \(error.localizedDescription)")
                    isLoading = false
                }
            }
        }
    }

    func interactWithNote(prompt: String) {
        AINetworkManager.shared.interactWithNote(noteId: noteId, prompt: prompt) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    messages.append(response)
                    isLoading = false
                case .failure(let error):
                    messages.append("Error: \(error.localizedDescription)")
                    isLoading = false
                }
            }
        }
    }
}
#Preview {
    ChatifyView(folderId: 1, noteId:1)
}
