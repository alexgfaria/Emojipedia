import SwiftUI

//
//  AppleRepoView.swift
//  blissAppsTechChallenge
//
//  Created by Alex Faria on 14/08/2025.
//

struct AppleRepoView: View {
    
    @ObservedObject var viewModel: AppleRepoViewModel
    
    var body: some View {
        
        List {
            
            ForEach(viewModel.repos) { repo in
                
                HStack {
                    
                    Image(systemName: Images.isPublic)
                    Text(repo.fullName)
                        .lineLimit(1)
                }
                .onAppear {
                    
                    if repo == viewModel.repos.last {
                        
                        viewModel.loadNextPage()
                    }
                }
            }
            
            if viewModel.isLoading {
                
                HStack {
                    
                    Spacer()
                    ProgressView().padding(.vertical, 12)
                    Spacer()
                }
            }
        }
        .listStyle(.automatic)
        .navigationTitle(Localizables.Titles.pageTitle)
        .onAppear {
            
            if viewModel.repos.isEmpty {
                
                viewModel.loadNextPage()
            }
        }
        .safeAreaInset(edge: .bottom) {
            
            if viewModel.isLoading {
                
                HStack {
                    
                    Spacer()
                    ProgressView()
                        .padding(.vertical, 10)
                    Spacer()
                }
            }
        }
    }
}

//MARK: - Constants
private enum Localizables {
    
    enum Titles {
        
        static let pageTitle = "Apple Repositories"
    }
}

private enum Images {
    
    static let isPublic = "shippingbox"
}
