//
//  FlashcardNetworkManager.swift
//  Flashify
//
//  Created by Ky Duyen on 13/3/25.
//

import Foundation
import KeychainSwift

class FlashcardNetworkManager {
    private let keychain = KeychainSwift()
    static let shared = FlashcardNetworkManager() // Fixed singleton instance

    private let baseURL = "http://127.0.0.1:5000/flashcard"
    
    func getAccessToken() -> String? {
        return keychain.get("accessToken")
    }
    
    func getFlashcards(for folderId: Int, completion: @escaping (Result<[String: Any], Error>) -> Void) {
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
    
    
    func createFlashcard(folderId: Int, question: String, answer: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let urlString = "\(baseURL)/\(folderId)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add Authorization header
        guard let token = getAccessToken() else {
            completion(.failure(NetworkError.unauthorized))
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Create JSON body
        let body: [String: Any] = [
            "question": question,
            "answer": answer
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: 1, userInfo: nil)))
                return
            }

            if (200...299).contains(httpResponse.statusCode) {
                completion(.success(()))
            } else {
                // Try to parse error message if available
                if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                    print("Server error: \(errorMessage)")
                }
                completion(.failure(NSError(domain: "Server returned status \(httpResponse.statusCode)", code: httpResponse.statusCode, userInfo: nil)))
            }
        }.resume()
    }

}

