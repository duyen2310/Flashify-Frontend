//
//  SplashLogoView.swift
//  Flashify
//
//  Created by Ky Duyen on 28/2/25.
//

import SwiftUI

struct SplashLogoView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(hex: "7B83EB"), Color.white]),
                                      startPoint: .top,
                                      endPoint: .bottom)
                           .edgesIgnoringSafeArea(.all)
                       

            Text("Flashify")
                .font(Font.custom("Teko-Bold", size: 96))                .foregroundColor(.white)
                .shadow(radius: 5)
        }
    }
}

#Preview {
    SplashLogoView()
}