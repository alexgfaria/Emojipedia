import Foundation
import SwiftUI

//
//  AppleRepoViewModel.swift
//  blissAppsTechChallenge
//
//  Created by Alex Faria on 14/08/2025.
//

@MainActor
final class AppleRepoViewModel: ObservableObject {
    
    @Published private(set) var repos: [AppleRepo] = []
    @Published private(set) var isLoading = false
    @Published private(set) var hasMore = true
    
    private let user = "apple"
    private let pageSize = 10
    private var page = 0
    
    func resetAndLoad() {
        
        repos.removeAll()
        page = 0
        hasMore = true
        loadNextPage()
    }
    
    func loadNextPage() {
        
        guard !isLoading, hasMore else { return }
        isLoading = true
        page += 1
        
        Task {
            
            do {
                
                let chunk = try await AppleRepoService.shared.fetchAppleRepos(
                    user: user,
                    page: page,
                    perPage: pageSize
                )
                repos.append(contentsOf: chunk)
                hasMore = (chunk.count == pageSize)
            } catch {
                
                hasMore = false
                print("Error fetching repos: ", error)
            }
            
            isLoading = false
        }
    }
}
