//
//  SessionManager.swift
//  Flashify
//
//  Created by Ky Duyen on 12/3/25.
//

import Foundation

class SessionManager: ObservableObject {
    static let shared = SessionManager()
    
    @Published var accessToken: String?  // Global state

    private init() {}  // Prevent external instantiation
}
