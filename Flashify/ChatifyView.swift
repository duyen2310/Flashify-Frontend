//
//  ChatifyView.swift
//  Flashify
//
//  Created by Ky Duyen on 1/3/25.
//

import SwiftUI
struct ChatifyView: View {
    @Environment(\.dismiss) var dismiss
    @State private var message: String = ""
    @State private var messages: [String] = [
        "Hey, can you explain a topic for me?",
        "Sure. Please tell me the topic!"
    ]

    var body: some View {
        VStack {
            HStack {
                Text("Chatify")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "4D4D9A"))
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
            .padding()
//DUMB BA DA
//NEED TO BE CHANGED THE WHOLE LOGIC FRONT END FOR BACKEND LATER
//CONNECT WITH OPENAI
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages, id: \.self) { msg in
                        Text(msg)
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
}
