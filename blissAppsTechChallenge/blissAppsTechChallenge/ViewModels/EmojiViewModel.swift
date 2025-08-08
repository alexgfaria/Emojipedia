import Foundation
import CoreData

//
//  EmojiViewModel.swift
//  blissAppsTechChallenge
//
//  Created by Alex Faria on 08/08/2025.
//

class EmojiViewModel: ObservableObject {
    
    @Published var emojis: [Emoji] = []
    private let store: EmojiStore
    
    init(context: NSManagedObjectContext) {
        
        self.store = EmojiStore(context: context)
    }
    
    func loadEmojis() {
        
        Task {
            
            do {
                
                let fetched = try await EmojiService.shared.fetchEmojis()
                store.save(emojis: fetched)
                
                await MainActor.run {
                    
                    self.emojis = fetched
                }
            } catch {
                
                print("Error fetching emojis: ", error)
            }
        }
    }
}
