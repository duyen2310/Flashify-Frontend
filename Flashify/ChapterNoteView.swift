//
//  ChapterNoteView.swift
//  Flashify
//
//  Created by Aum Zaveri on 2025-03-01.
//

import SwiftUI
struct ChapterNoteView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var isVisible: Bool
    let note: (id: String, folderId: Int, note: String, title: String)
    @State private var flipped: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Chapter 1")
                    .font(Font.custom("Teko-Bold", size: 36))
                    .foregroundColor(Color(hex: "4D4D9A"))
                Spacer()
                Button(action: { isVisible = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
            .padding()

            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text(note.note)
                        .font(Font.custom("Teko-Bold", size: 25))
                        .foregroundColor(Color(hex: "4D4D9A"))
                }
                .padding()
            }
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}
