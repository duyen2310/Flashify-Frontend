//
//  CreateNewFolder.swift
//  Flashify
//
//  Created by Aum Zaveri on 2025-03-01.
//

import SwiftUI

struct CreateNewFolderView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var isVisible: Bool
    @State private var name: String = ""
    @State private var description: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create New Folder")
                    .font(Font.custom("Teko-Bold", size: 36))
                    .foregroundColor(Color(hex: "4D4E8C"))

                TextField("Folder Name", text: $name)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                TextField("Folder Description", text: $description)
                    .frame(height: 120)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            HStack {
                Button(action: {
                    print("New Folder added")
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
                    isVisible = false
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