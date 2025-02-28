//
//  ContentView.swift
//  Flashify
//
//  Created by Ky Duyen on 28/2/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showSignUp = false

    var body: some View {
        if showSignUp {
            SignUpView()
        } else {
            SplashLogoView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            showSignUp = true
                        }
                    }
                }
        }
    }
}


extension Color {
    init(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&int)
        let red = Double((int >> 16) & 0xFF) / 255.0
        let green = Double((int >> 8) & 0xFF) / 255.0
        let blue = Double(int & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}
#Preview {
    ContentView() 
}
