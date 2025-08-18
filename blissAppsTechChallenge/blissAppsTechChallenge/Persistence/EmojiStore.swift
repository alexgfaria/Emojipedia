import CoreData

//
//  EmojiStore.swift
//  blissAppsTechChallenge
//
//  Created by Alex Faria on 08/08/2025.
//

final class EmojiStore {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        
        self.context = context
    }
    
    //Save emojis to core data
    func save(emojis: [Emoji]) {
        
        emojis.forEach { emoji in
            
            let entity = EmojiEntity(context: context)
            entity.id = emoji.id
            entity.url = emoji.url
        }
        
        do {
            
            try context.save()
        } catch {
            
            print("Error saving emojis: ", error)
        }
    }
    
    //Load emojis from core data
    func load() -> [Emoji] {
        
        let request: NSFetchRequest<EmojiEntity> = EmojiEntity.fetchRequest()
        
        do {
            
            let result = try context.fetch(request)
            
            return result.compactMap { entity in
            
                guard let id = entity.id,
                      let url = entity.url else { return nil }
                
                return Emoji(id: id, url: url)
            }
        } catch {
            
            print("Error loading emojis: ", error)
            return []
        }
    }
    
    //check memory for emoji
    func hasEmoji() -> Bool {
        
        let request: NSFetchRequest<EmojiEntity> = EmojiEntity.fetchRequest()
        request.fetchLimit = 1
        
        do {
            
            let count = try context.count(for: request)
            return count > 0
        } catch {
            
            return false
        }
    }
}
