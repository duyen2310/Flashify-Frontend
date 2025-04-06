//
//  AINetworkManager.swift
//  Flashify
//
//  Created by Ky Duyen on 5/4/25.
//
import Foundation
import KeychainSwift

class AINetworkManager{
    private let keychain = KeychainSwift()
    static let shared = AINetworkManager()
    
    private let baseURL = "http://127.0.0.1:5000/ai"
    
    func getAccessToken() -> String? {
        return keychain.get("accessToken")
    }
    func generateFlashcards(fileURL: URL, completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        let url = URL(string: "\(baseURL)/flashcard")!
        
        var request = URLRequest(url: url)
        guard let token = getAccessToken() else {
            completion(.failure(NetworkError.unauthorized))
            return
        }
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        

        let filename = fileURL.lastPathComponent
        let fileData = try? Data(contentsOf: fileURL)
        let mimeType = "text/plain" // or "application/json" if .json
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(fileData ?? Data())
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }

            if let data = data {
                do {
                    // Parse the response JSON into a dictionary
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let flashcards = jsonResponse["flashcards"] as? [[String: String]] {
                        completion(.success(flashcards))
                    } else {
                        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON structure"])))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
            }
        }.resume()
    }


    
    func generateNote(fileURL: URL, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/note")!
        
        var request = URLRequest(url: url)
        guard let token = getAccessToken() else {
            completion(.failure(NetworkError.unauthorized))
            return
        }
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        let filename = fileURL.lastPathComponent
        let fileData = try? Data(contentsOf: fileURL)
        let mimeType = "text/plain" // or "application/json" if .json
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(fileData ?? Data())
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }

            if let data = data {
                do {
                    // Try to parse the response JSON
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let note = jsonResponse["note"] as? String {
                        // Success - passing the parsed note
                        completion(.success(note))
                    } else {
                        // Failure due to an invalid response structure
                        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON structure"])))
                    }
                } catch {
                    // If parsing the JSON fails
                    completion(.failure(error))
                }
            } else {
                // No data received
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
            }
        }.resume()
    }

    
    
    func interactWithFlashcard(folderId: Int, prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: URL(string: "\(baseURL)/flashcard/\(folderId)")!)
        request.httpMethod = "POST"
        
        guard let token = getAccessToken() else {
            completion(.failure(NetworkError.unauthorized))
            return
        }

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = [
            "prompt": prompt
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            do {
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                               let responseText = json["response"] as? String {
                                completion(.success(responseText)) // Just return the response text
                            } else {
                                completion(.failure(NSError(domain: "Invalid response format", code: -1, userInfo: nil)))
                            }
                        } catch {
                            completion(.failure(error))
                        }
                    }

                    .resume()
    }

    func interactWithNote(noteId: Int, prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: URL(string: "\(baseURL)/note/\(noteId)")!)
        request.httpMethod = "POST"
        
        guard let token = getAccessToken() else {
            completion(.failure(NetworkError.unauthorized))
            return
        }

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = [
            "prompt": prompt
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            do {
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                               let responseText = json["response"] as? String {
                                completion(.success(responseText)) // Just return the response text
                            } else {
                                completion(.failure(NSError(domain: "Invalid response format", code: -1, userInfo: nil)))
                            }
                        } catch {
                            completion(.failure(error))
                        }
                    }

                    .resume()
    }


}
