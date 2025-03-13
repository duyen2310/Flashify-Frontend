//
//  NoteNetworkManager.swift
//  Flashify
//
//  Created by Ky Duyen on 13/3/25.
//

import Foundation
import KeychainSwift

class NoteNetworkManager {
    private let keychain = KeychainSwift()
    static let shared = NoteNetworkManager()

    private let baseURL = "http://127.0.0.1:5000/note"
    
    func getAccessToken() -> String? {
        return keychain.get("accessToken")
    }
    
    func getNotes(for folderId: Int, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let urlString = "\(baseURL)/\(folderId)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Get the access token from Keychain
        guard let token = getAccessToken() else {
            completion(.failure(NetworkError.unauthorized))
            return
        }
        
        // Set Authorization header
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Perform network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 1, userInfo: nil)))
                return
            }
            
            // Debugging: Print response
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
            }
            
            do {
                // Decode JSON response
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(jsonResponse))
                } else {
                    completion(.failure(NSError(domain: "Invalid JSON format", code: 2, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

