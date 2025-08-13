import Foundation

//
//  AvatarService.swift
//  blissAppsTechChallenge
//
//  Created by Alex Faria on 13/08/2025.
//


final class AvatarService {
    
    static let shared = AvatarService()

    func fetchUser(login: String) async throws -> (login: String, avatarURL: String) {
        
        let url = URL(string: "https://api.github.com/users/\(login)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let object = try JSONDecoder().decode(UserDTO.self, from: data)
        
        return (object.login, object.avatar_url)
    }

    func fetchImageData(from urlString: String) async throws -> Data {
        
        let url = URL(string: urlString)!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return data
    }
}

private struct UserDTO: Decodable {
    
    let login: String
    let avatar_url: String
}
