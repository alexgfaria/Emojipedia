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

    //MARK: - Save operations
    func save(_ avatar: Avatar) {
        
        NotificationCenter.default.post(name: .avatarsDidChange, object: nil)
        
        // upsert
        let req: NSFetchRequest<AvatarEntity> = AvatarEntity.fetchRequest()
        
        req.predicate = NSPredicate(format: "login ==[c] %@", avatar.login)
        
        let entity = (try? context.fetch(req).first) ?? AvatarEntity(context: context)
        
        entity.login = avatar.login
        entity.avatarURL = avatar.avatarURL
        entity.imageData = avatar.imageData
        
        try? context.save()
    }
    
    //MARK: - Load operations
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
    
    func fetchAllAvatars() -> [Avatar] {
        
        let req: NSFetchRequest<AvatarEntity> = AvatarEntity.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(key: "login", ascending: true)]
        
        do {
            
            let rows = try context.fetch(req)
            return rows.compactMap { object in
                
                guard let login = object.login,
                      let url = object.avatarURL,
                      let data = object.imageData else { return nil }
                
                return Avatar(
                    login: login,
                    avatarURL: url,
                    imageData: data
                )
            }
        } catch {
            
            print("Error fetching all avatars: ", error)
            return []
        }
    }
    
    //MARK: - Delete operations
    func deleteAvatar(login: String) {
        
        NotificationCenter.default.post(name: .avatarsDidChange, object: nil)
        
        let req: NSFetchRequest<AvatarEntity> = AvatarEntity.fetchRequest()
        req.predicate = NSPredicate(format: "login ==[c] %@", login)
        req.fetchLimit = 1
        
        if let object = try? context.fetch(req).first {
            
            context.delete(object)
            try? context.save()
        }
    }
}


//MARK: - Notification
extension Notification.Name {
    
    static let avatarsDidChange = Notification.Name("avatarsDidChange")
}
