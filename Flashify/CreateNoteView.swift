//
//  CreateNoteView.swift
//  Flashify
//
//  Created by Ky Duyen on 1/3/25.
//
import SwiftUI

struct CreateNoteView: View {
    @Environment(\.dismiss) var dismiss
    let folderId: Int  // Accept folderId as a parameter
    
    @State private var title: String = ""
    @State private var note: String = ""
    @State private var topic: String = ""
    @State private var createOption: String = "Manually"
    @State private var selectedFileURL: URL?
    @State private var showingFileImporter = false
    @Binding var isVisible: Bool
    @State private var generatedNote: String = ""
    
    
    var onCreated: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Create Notes")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "4D4D9A"))
            
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
                .padding(.vertical, 40.0)
            }
            
            HStack {
                Button(action: {
                    if createOption == "Manually" {
                        guard !title.isEmpty, !note.isEmpty else { return }
                        
                        NoteNetworkManager.shared.createNote(folderId: folderId, title: title, note: note) { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success:
                                    print("Note successfully created!")
                                    onCreated()
                                    isVisible = false
                                case .failure(let error):
                                    print("Failed to create note: \(error.localizedDescription)")
                                    
                                }
                            }
                        }
                    } else {
                        if generatedNote.isEmpty {
                            guard let fileURL = selectedFileURL else { return }
                            
                            AINetworkManager.shared.generateNote(fileURL: fileURL) { result in
                                DispatchQueue.main.async {
                                    switch result {
                                    case .success(let note):
                                        self.generatedNote = note
                                        print("Generated note successfully")
                                    case .failure(let error):
                                        print("Failed to generate note: \(error.localizedDescription)")
                                    }
                                }
                            }
                        } else {
                            NoteNetworkManager.shared.createNote(
                                folderId: folderId,
                                title: "DEFAULT TITLE",
                                note: generatedNote
                            ) { result in
                                DispatchQueue.main.async {
                                    switch result {
                                    case .success:
                                        print("Generated note uploaded successfully")
                                        onCreated()
                                        isVisible = false
                                    case .failure(let error):
                                        print("Failed to upload generated note: \(error.localizedDescription)")
                                    }
                                }
                            }
                        }
                    }
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


