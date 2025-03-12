import Foundation

class SessionManager: ObservableObject {
    static let shared = SessionManager()
    
    @Published var accessToken: String? {
        didSet {
            if let token = accessToken {
                UserDefaults.standard.set(token, forKey: "accessToken")
            } else {
                UserDefaults.standard.removeObject(forKey: "accessToken")
            }
        }
    }

    private init() {
        if let savedToken = UserDefaults.standard.string(forKey: "accessToken") {
            accessToken = savedToken
        }
    }
    
    func logout() {
        accessToken = nil
    }
}
