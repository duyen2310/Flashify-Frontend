//
//  ProfilePopupView.swift
//  Flashify
//
//  Created by Ky Duyen on 1/3/25.
//

import SwiftUI
struct ProfilePopupView: View {
    var body: some View {
        VStack {
            Text("Profile")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "4D4D9A"))
                .padding()

            TextField("Username: John Doe", text: .constant(""))
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .disabled(true)

            TextField("Email: johndoe@gmail.com", text: .constant(""))
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .disabled(true)

            Spacer()
        }
        .padding()
        .frame(width: 300, height: 300)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

#Preview {
    ProfilePopupView()
}
