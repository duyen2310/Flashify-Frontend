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
                if let responseString = String(data: data, encoding: .utf8) {
                       print("Response: \(responseString)")
                   }
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


    
    func generateNote(text: String?, fileData: Data?, fileName: String?, completion: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: URL(string: "\(baseURL)/note")!)
        request.httpMethod = "POST"

        guard let token = getAccessToken() else {
            completion(.failure(NetworkError.unauthorized))
            return
        }

        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        if let text = text {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"text\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(text)\r\n".data(using: .utf8)!)
        }

        if let fileData = fileData, let fileName = fileName {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
            body.append(fileData)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data, let note = String(data: data, encoding: .utf8) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            completion(.success(note))
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

            completion(.success(responseString))
        }.resume()
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

            completion(.success(responseString))
        }.resume()
    }


}
