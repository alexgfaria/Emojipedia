import SwiftUI
import CoreData

//
//  AvatarViewModel.swift
//  blissAppsTechChallenge
//
//  Created by Alex Faria on 13/08/2025.
//

@MainActor
final class AvatarViewModel: ObservableObject {
    
    @Published var query: String = ""
    @Published var avatar: Avatar?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let store: AvatarStore
    
    var hasNoAvatars: Bool {
        
        store.fetchAllAvatars().isEmpty
    }
    
    init(context: NSManagedObjectContext) {
        
        self.store = AvatarStore(context: context)
    }

    func search() {
        
        let login = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !login.isEmpty else { return }

        isLoading = true
        errorMessage = nil

        //username found in memory
        if let cached = store.get(login: login) {
            
            self.avatar = cached
            self.isLoading = false
            
            return
        }

        Task {
            
            do {
                
                let (login, imageURL) = try await AvatarService.shared.fetchUser(login: login)
                let imageData = try await AvatarService.shared.fetchImageData(from: imageURL)
                let avatar = Avatar(
                    login: login,
                    avatarURL: imageURL,
                    imageData: imageData
                )
                
                store.save(avatar)
                self.avatar = avatar
            } catch {
                
                self.errorMessage = "User not found. Please try again"
            }
            self.isLoading = false
        }
    }
}
