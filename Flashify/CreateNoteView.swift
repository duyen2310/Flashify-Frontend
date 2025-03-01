//
//  CreateNoteView.swift
//  Flashify
//
//  Created by Ky Duyen on 1/3/25.
//

import SwiftUI

struct CreateNoteView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var note: String = ""
    @State private var topic: String = ""
    @State private var createOption: String = "Manually"
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create Notes")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "4D4D9A"))
            
            HStack {
                Button(action: { createOption = "Manually" }) {
                    Text("✓ Manually")
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
                TextField("Title", text: $title)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                TextField("Notes", text: $note)
                    .frame(height: 120)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            } else {
                TextField("check", text: $topic)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            
            HStack {
                Button(action: {
                    if createOption == "Manually" {
                        
                        print("Manually Added Flashcard")
                    } else {
                        
                        print("Generating flashcards for topic")
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
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .frame(width: 350, height: 450)

    }
}


#Preview {
    CreateNoteView()
}
