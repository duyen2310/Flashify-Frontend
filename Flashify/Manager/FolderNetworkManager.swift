import Foundation
import KeychainSwift

class FolderNetworkManager {
    private let keychain = KeychainSwift()
    static let shared = FolderNetworkManager()
    
    private let baseURL = "http://127.0.0.1:5000/folder"
    func getAccessToken() -> String? {
        return keychain.get("accessToken")
    }
    func getFolders(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let url = URL(string: baseURL + "/") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Get the access token from the keychain
        guard let token = keychain.get("accessToken") else {
            completion(.failure(NetworkError.unauthorized))
            return
        }
        
        // Set the Authorization header
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Perform the network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NSError(domain: "Unknown error", code: 0, userInfo: nil)))
                return
            }
            
//            if let responseString = String(data: data, encoding: .utf8) {
//                print("Response: \(responseString)")
//            }
//            
            do {
                // Try to decode the response into a dictionary
                if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(jsonResponse))
                } else {
                    completion(.failure(NSError(domain: "Invalid data format", code: 1, userInfo: nil)))
                }
            } catch {
                print("Error decoding response: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }

    func createFolder(name: String, description: String, completion: @escaping (Result<String, Error>) -> Void) {
        print("Creating folder with name: \(name) and description: \(description)")
        
        guard let url = URL(string: baseURL + "/") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")

        guard let token = keychain.get("accessToken") else {
            completion(.failure(NetworkError.unauthorized))
            return
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")


        let body: [String: Any] = [
            "name": name,
            "description": description
        ]
        
        print("Request body: \(body)")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error)")
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for error in the network request
            if let error = error {
                print("Network error: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Error: Invalid response")
                let error = NSError(domain: "NetworkError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to get a valid response."])
                completion(.failure(error))
                return
            }
            
            print("Response status code: \(response.statusCode)")
            
            if response.statusCode == 201 {
                if let responseData = data {
                    print("Response data: \(String(describing: String(data: responseData, encoding: .utf8)))")
                }
                completion(.success("Folder created successfully"))
            } else {
                let errorMessage = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                print("Error response: \(errorMessage)")
                let error = NSError(domain: "NetworkError", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                completion(.failure(error))
            }
        }
        task.resume()
    }


    func updateFolder(id: Int, folderData: [String: Any], completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(id)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = SessionManager.shared.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: folderData)
            request.httpBody = jsonData
        } catch {
            print("Error serializing data: \(error)")
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NSError(domain: "Unknown error", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                completion(.success(jsonResponse as! [String: Any]))
            } catch {
                print("Error decoding response: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    func deleteFolder(id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
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
