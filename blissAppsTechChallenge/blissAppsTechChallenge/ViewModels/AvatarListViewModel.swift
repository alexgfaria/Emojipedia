import SwiftUI
import CoreData

//
//  AvatarListViewModel.swift
//  blissAppsTechChallenge
//
//  Created by Alex Faria on 13/08/2025.
//

@MainActor
final class AvatarListViewModel: ObservableObject {
    
    @Published var items: [Avatar] = []
    private let store: AvatarStore
    
    init(context: NSManagedObjectContext) {
        
        self.store = AvatarStore(context: context)
    }
    
    func loadAvatars() {
        
        items = store.fetchAllAvatars()
    }
    
    func deleteAvatar(login: String) {
        
        store.deleteAvatar(login: login)
        loadAvatars()
    }
}
