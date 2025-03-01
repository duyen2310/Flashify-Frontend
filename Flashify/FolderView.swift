//
//  FolderView.swift
//  Flashify
//
//  Created by Ky Duyen on 28/2/25.
//
import SwiftUI

struct FolderView: View {
    var folderName: String
    @State private var selectedTab: String = "Flashcards"
    
    let flashcards = [
        "In what way does calculus contribute to the field of engineering?",
        "How does calculus contribute to advancement in computer science?",
        "What is the integral of f(x)=3x²f(x) = 3x + 2f(x)=3x²?",
        "What is the derivative of f(x)=x²f(x) = x²2f(x)=x2?",
        "What is the limit definition of a derivative?"
    ]
    
    let chapters = [
        "Chapter : 1",
        "Chapter : 2",
        "Chapter : 3",
        "Chapter : 4",
        "Chapter : 5"
    ]
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text(folderName)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .padding(.top, 50)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color(hex: "7B83EB"), Color(hex: "4D4D9A")]), startPoint: .top, endPoint: .bottom)
            )

            HStack {
                Button(action: { selectedTab = "Flashcards" }) {
                    Text("Flashcards")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(selectedTab == "Flashcards" ? Color.black : Color.white)
                        .foregroundColor(selectedTab == "Flashcards" ? .white : .black)
                        .cornerRadius(8)
                }
                
                Button(action: { selectedTab = "Notes" }) {
                    Text("Notes")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(selectedTab == "Notes" ? Color.black : Color.white)
                        .foregroundColor(selectedTab == "Notes" ? .white : .black)
                        .cornerRadius(8)
                }
            }
            .padding()
            .shadow(radius: 2)
            
            ScrollView {
                if selectedTab == "Flashcards" {
                    // Flashcards Grid
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 16) {
                        ForEach(flashcards, id: \.self) { flashcard in
                            Text(flashcard)
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding()
                                .frame(height: 120)
                                .frame(maxWidth: .infinity)
                                .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "7B83EB"), Color(hex: "4D4D9A")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .cornerRadius(12)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding()
                } else {
                    VStack(spacing: 12) {
                        ForEach(chapters, id: \.self) { chapter in
                            Text(chapter)
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "7B83EB"), Color(hex: "4D4D9A")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                }
            }
            
            Spacer()
            
            Button(action: {
            }) {
                Image(systemName: "command")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 4)
            }
            .padding(.bottom, 20)
            .padding(.trailing, 20)

        }
        .edgesIgnoringSafeArea(.top)
        .background(Color(hex: "E8EBFA").edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    FolderView(folderName: "Calculus")
}
