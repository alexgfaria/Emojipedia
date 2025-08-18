import Foundation

//
//  AppleRepoService.swift
//  blissAppsTechChallenge
//
//  Created by Alex Faria on 14/08/2025.
//

final class AppleRepoService {
    
    static let shared = AppleRepoService()
    
    private init() {}
    
    func fetchAppleRepos(
        user: String,
        page: Int,
        perPage: Int = 10
    ) async throws -> [AppleRepo] {
        
        var components = URLComponents(string: "https://api.github.com/users/\(user)/repos")!
        
        components.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(perPage))
        ]
        
        let url = components.url!
        let (data, _) = try await URLSession.shared.data(from: url)
        let dtos = try JSONDecoder().decode([AppleRepoDTO].self, from: data)
        
        return dtos.map {
            
            AppleRepo(
                id: $0.id,
                fullName: $0.full_name.replacingOccurrences(of: "apple/", with: "")
            )
        }
    }
    
    private struct AppleRepoDTO: Decodable {
        
        let id: Int
        let full_name: String
    }
}
