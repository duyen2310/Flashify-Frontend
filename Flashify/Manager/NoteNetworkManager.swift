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
    
    func createNote(folderId: Int, title: String, note: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let urlString = "\(baseURL)/\(folderId)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let token = getAccessToken() else {
            completion(.failure(NetworkError.unauthorized))
            return
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let requestBody: [String: Any] = [
            "title": title,
            "note": note
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "Server Error", code: 3, userInfo: nil)))
                return
            }
            
            completion(.success(()))
        }.resume()
    }
    
    func deleteNote(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(id)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        if let token = SessionManager.shared.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if error != nil {
                print("Error deleting folder: \(error!)")
                completion(.failure(error ?? NSError(domain: "Unknown error", code: 0, userInfo: nil)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 {
                completion(.success(()))
            } else {
                print("Error response: \(String(describing: response))")
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
            }
        }.resume()
    }

}

