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
    @State private var messages: String = "Calculus studies change using limits, derivatives, and integrals. Limits define function behavior near points. Derivatives measure rates of change, like velocity. Basic rules include power, product, quotient, and chain rules. Integrals find areas under curves. Calculus studies change using limits, derivatives, and integrals. Limits define function behavior near points. Derivatives measure rates of change, like velocity. Basic rules include power, product, quotient, and chain rules. Integrals find areas under curves. Limits define function behavior near points. Derivatives measure rates of change, like velocity. Basic rules include power, product, quotient, and chain rules. Integrals find areas under curves."
    
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
                    Text(messages)
                        .font(Font.custom("Teko-Bold", size: 25))
                        .foregroundColor(Color(hex: "4D4D9A"))
                }
                .padding()
            }
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}