import Foundation

//
//  EmojiService.swift
//  blissAppsTechChallenge
//
//  Created by Alex Faria on 08/08/2025.
//

final class EmojiService {
    
    static let shared = EmojiService()
    
    private let url = URL(string: "https://api.github.com/emojis")!
    
    func fetchEmojis() async throws -> [Emoji] {
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let rawDict = try JSONDecoder().decode([String:String].self, from: data)
     
        return rawDict.map {
            
            Emoji(id: $0.key, url: $0.value)
        }
    }
}
