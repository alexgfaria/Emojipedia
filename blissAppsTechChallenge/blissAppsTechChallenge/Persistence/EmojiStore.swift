import CoreData

//
//  EmojiStore.swift
//  blissAppsTechChallenge
//
//  Created by Alex Faria on 08/08/2025.
//

class EmojiStore {
    
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
}
