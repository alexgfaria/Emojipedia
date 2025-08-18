import SwiftUI

//
//  AvatarListView.swift
//  blissAppsTechChallenge
//
//  Created by Alex Faria on 13/08/2025.
//

struct AvatarListView: View {
    
    @ObservedObject var viewModel: AvatarListViewModel
    @State private var avatarToDelete: Avatar?
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        
        ScrollView {
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 20)], spacing: 20) {
                
                ForEach(viewModel.items, id: \.login) { avatar in
                    
                    if let ui = UIImage(data: avatar.imageData) {
                        
                        Image(uiImage: ui)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .onTapGesture {
                                
                                avatarToDelete = avatar
                                showDeleteConfirmation = true
                            }
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
        }
        .onAppear {
            
            viewModel.loadAvatars()
        }
        .onReceive(NotificationCenter.default.publisher(for: .avatarsDidChange)) { _ in
            
            viewModel.loadAvatars()
        }
        .confirmationDialog(
            Localizables.Dialog.title,
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            
            Button(Localizables.Dialog.delete, role: .destructive) {
                
                if let avatar = avatarToDelete {
                    
                    withAnimation {
                        
                        viewModel.deleteAvatar(login: avatar.login)
                    }
                }
            }
            Button(Localizables.Dialog.cancel, role: .cancel) {
                
                avatarToDelete = nil
            }
        }
        .navigationTitle(Localizables.Titles.pageTitle)
    }
}

//MARK: - Constants
private enum Localizables {
    
    enum Dialog {
        
        static let title = "Delete This Avatar?"
        static let delete = "Delete"
        static let cancel = "Cancel"
    }
    
    enum Titles {
        
        static let pageTitle = "Avatar List"
    }
}
