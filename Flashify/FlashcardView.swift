//
//  FlashcardView.swift
//  Flashify
//
//  Created by Aum Zaveri on 2025-03-01.
//
import SwiftUI

struct FlashcardView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var isVisible: Bool
    @State private var question: String = "In what way does calculus contribute to the field of engineering?"
    @State private var answer: String = "very very much"
    @State private var flipped: Bool = false
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.6)) {
                    flipped.toggle()
                }
            }) {
                ZStack {
                    CardFace(content: question, isShowing: !flipped)
                    
                    CardFace(content: answer, isShowing: flipped)
                        .rotation3DEffect(
                            .degrees(180),
                            axis: (x: 0, y: 1, z: 0)
                        )
                }
                .rotation3DEffect(
                    .degrees(flipped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0),
                    perspective: 0.5
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct CardFace: View {
    let content: String
    let isShowing: Bool
    
    var body: some View {
        Text(content)
            .font(Font.custom("Teko-Bold", size: 26))
            .foregroundColor(Color(hex: "#7A7B9E"))
            .frame(width: 300, height: 200)
            .background(Color.white)
            .cornerRadius(12)
            .opacity(isShowing ? 1 : 0)
    }
}


#Preview {
    FlashcardView(isVisible: .constant(true))
}