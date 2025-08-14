import Foundation
import CoreData

//
//  EmojiViewModel.swift
//  blissAppsTechChallenge
//
//  Created by Alex Faria on 08/08/2025.
//

@MainActor
final class EmojiViewModel: ObservableObject {
    
    @Published var emojis: [Emoji] = []
    @Published var isLoading: Bool = false
    @Published var randomEmoji: Emoji?
    
    private let store: EmojiStore
    
    init(context: NSManagedObjectContext) {
        
        self.store = EmojiStore(context: context)
    }
    
    func loadEmojis() {
        
        guard !isLoading else { return }
        
        isLoading = true
        
        Task {
            
            if store.hasEmoji() {
                
                let loaded = store.load()
                self.emojis = loaded
                isLoading = false
            } else {
                
                do {
                    
                    let fetched = try await EmojiService.shared.fetchEmojis()
                    store.save(emojis: fetched)
                    self.emojis = fetched
                    isLoading = false
                } catch {
                    
                    print("Error fetching emojis: ", error)
                    isLoading = false
                }
            }
        }
    }
    
    func getRandomEmoji() {
        
        guard !emojis.isEmpty else { return }
        
        randomEmoji = emojis.randomElement()
    }
}
