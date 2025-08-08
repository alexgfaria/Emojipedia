import Foundation
import Combine

//
//  EmojiViewModel.swift
//  blissAppsTechChallenge
//
//  Created by Alex Faria on 08/08/2025.
//

class EmojiViewModel: ObservableObject {
    
    @Published var emojis: [Emoji] = []
    
    func loadEmojis() {
        
        Task {
            
            do {
                
                let fetched = try await EmojiService.shared.fetchEmojis()
                
                await MainActor.run {
                    
                    self.emojis = fetched
                }
            } catch {
                
                print("Error fetching emojis: ", error)
            }
        }
    }
}
