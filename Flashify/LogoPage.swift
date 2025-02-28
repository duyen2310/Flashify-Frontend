//
//  LogoPage.swift
//  Flashify
//
//  Created by Ky Duyen on 28/2/25.
//

import SwiftUI

struct LogoPage: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(hex: "7B83EB"), Color.white]),
                                      startPoint: .top,
                                      endPoint: .bottom)
                           .edgesIgnoringSafeArea(.all)
            
            Text("Flashify")
                .font(.system(size: 50, weight: .bold))
                .foregroundColor(.white)
                .shadow(radius: 5)
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
    LogoPage()
}
