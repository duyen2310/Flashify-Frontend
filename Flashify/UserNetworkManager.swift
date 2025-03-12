//
//  UserNetworkManager.swift
//  Flashify
//
//  Created by Ky Duyen on 12/3/25.
//

import Foundation
import KeychainSwift

class UserNetworkManager {
    static let shared = UserNetworkManager()
    
    private let baseUrl = "http://127.0.0.1:5000/user" // Replace with your backend URL
    private let keychain = KeychainSwift()
    
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/login") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let body: [String: Any] = ["email": email, "password": password]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(NetworkError.invalidRequestBody))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = httpBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.unknownError))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.httpError(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let accessToken = jsonResponse["accessToken"] as? String {
                    
                    self.keychain.set(accessToken, forKey: "accessToken") // Store token securely
                    completion(.success(accessToken)) // Return the access token
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    /// Retrieve the stored access token
    func getAccessToken() -> String? {
        return keychain.get("accessToken")
    }
    /// Fetch user profile (requires stored token)
    func fetchUserProfile(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/profile") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        guard let token = keychain.get("accessToken") else {
            completion(.failure(NetworkError.unauthorized))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.unknownError))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.httpError(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(jsonResponse))
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    /// Logout and remove stored token
    func logout(completion: @escaping () -> Void) {
        keychain.delete("accessToken")
        completion()
    }
    
    
    func signUp(username: String, email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)/signup") else {
            completion(.failure(NetworkError.invalidURL))  // Return custom error if URL is invalid
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "username": username,
            "email": email,
            "password": password
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(NetworkError.invalidRequestBody))  // Handle invalid body serialization
            return
        }
        
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")  // Print error
                completion(.failure(error))  // Return error
                return
            }
            
            guard let data = data else {
                print("No data received")  // Print error if no data
                completion(.failure(NetworkError.noData))  // Handle missing data
                return
            }
            
            // Handle the HTTP response status code
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                print("HTTP Error: \(httpResponse.statusCode)")  // Print HTTP error
                completion(.failure(NetworkError.httpError(statusCode: httpResponse.statusCode)))  // Handle HTTP errors
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let token = json["accessToken"] as? String {
                    completion(.success(token))  // Return token on success
                } else {
                    print("Invalid response format")  // Print error if response format is invalid
                    completion(.failure(NetworkError.invalidResponse))  // Handle invalid response
                }
            } catch {
                print("Error parsing JSON: \(error)")  // Print error if JSON parsing fails
                completion(.failure(error))  // Return error
            }
        }.resume()
    }
}
    /// Custom error types
    enum NetworkError: Error {
        case invalidURL
        case invalidRequestBody
        case noData
        case invalidResponse
        case unauthorized
        case httpError(statusCode: Int)
        case unknownError
    }
