import CoreData

//
//  AvatarStore.swift
//  blissAppsTechChallenge
//
//  Created by Alex Faria on 13/08/2025.
//

final class AvatarStore {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        
        self.context = context
    }

    //load from memory
    func get(login: String) -> Avatar? {
        
        let req: NSFetchRequest<AvatarEntity> = AvatarEntity.fetchRequest()
        
        req.predicate = NSPredicate(format: "login ==[c] %@", login)
        req.fetchLimit = 1
        
        if let object = try? context.fetch(req).first,
           let url = object.avatarURL,
           let data = object.imageData {
            
            return Avatar(
                login: object.login ?? login,
                avatarURL: url,
                imageData: data
            )
        }
        
        return nil
    }

    //save on memory
    func save(_ avatar: Avatar) {
        
        // upsert
        let req: NSFetchRequest<AvatarEntity> = AvatarEntity.fetchRequest()
        
        req.predicate = NSPredicate(format: "login ==[c] %@", avatar.login)
        
        let entity = (try? context.fetch(req).first) ?? AvatarEntity(context: context)
        
        entity.login = avatar.login
        entity.avatarURL = avatar.avatarURL
        entity.imageData = avatar.imageData
        
        try? context.save()
    }
}
