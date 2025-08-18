import SwiftUI

//
//  ContentView.swift
//  blissAppsTechChallenge
//
//  Created by Alex Faria on 08/08/2025.
//

struct ContentView: View {
        
    @StateObject var emojiViewModel: EmojiViewModel
    @StateObject private var avatarViewModel: AvatarViewModel
    @StateObject private var avatarListViewModel: AvatarListViewModel
    @StateObject private var appleRepoViewModel: AppleRepoViewModel
    
    @State private var showSavedAvatars = false
    @State private var showAppleRepos = false
    
    init() {
        
        let context = PersistenceController.shared.container.viewContext
        _emojiViewModel = StateObject(wrappedValue: EmojiViewModel(context: context))
        _avatarViewModel = StateObject(wrappedValue: AvatarViewModel(context: context))
        _avatarListViewModel = StateObject(wrappedValue: AvatarListViewModel(context: context))
        _appleRepoViewModel = StateObject(wrappedValue: AppleRepoViewModel())
    }
    
    var body: some View {
        
        NavigationStack {
            
            VStack(spacing: 16) {
                
                // MARK: - Random Emoji display
                ZStack {
                    
                    if let emoji = emojiViewModel.randomEmoji {
                        
                        VStack {
                            
                            AsyncImage(url: URL(string: emoji.url)) { image in
                                
                                image.resizable().scaledToFit()
                            } placeholder: {
                                
                                ProgressView()
                            }
                            .frame(width: 80, height: 80)
                            
                            Text(emoji.id)
                                .font(.caption)
                        }
                    }
                }
                .frame(height: 100)
                .padding()
                
                // MARK: - Random Emoji button
                Button {
                    emojiViewModel.getRandomEmoji()
                } label: {
                    Label(Localizables.Buttons.random, systemImage: Images.random)
                        .frame(maxWidth: .infinity)
                }
                .labelStyle(.titleAndIcon)
                .buttonStyle(.bordered)
                .buttonBorderShape(.roundedRectangle)
                .disabled(emojiViewModel.isLoading || emojiViewModel.emojis.isEmpty)
                
                // MARK: - Emoji List navigation
                NavigationLink(destination: EmojiListView(viewModel: emojiViewModel)) {
                    Label(Localizables.Buttons.emojiList, systemImage: Images.emoji)
                        .frame(maxWidth: .infinity)
                }
                .labelStyle(.titleAndIcon)
                .buttonStyle(.bordered)
                .buttonBorderShape(.roundedRectangle)
                .disabled(emojiViewModel.isLoading)
                
                // MARK: - Avatar Search section
                VStack {
                    
                    HStack(spacing: 12) {
                        
                        TextField(Localizables.Input.username, text: $avatarViewModel.query)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .textFieldStyle(.roundedBorder)
                        
                        Button {
                            
                            avatarViewModel.search()
                        } label: {
                            
                            Label(Localizables.Buttons.search, systemImage: Images.search)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(avatarViewModel.isLoading)
                    }
                    .frame(maxWidth: .infinity)
                    
                    if avatarViewModel.isLoading {
                        
                        ProgressView().padding(.top, 4)
                    }
                    
                    if avatarViewModel.errorMessage == nil,
                       let avatar = avatarViewModel.avatar {
                        
                        VStack(spacing: 8) {
                            
                            if let ui = UIImage(data: avatar.imageData) {
                                
                                Image(uiImage: ui)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            Text(avatar.login).font(.headline)
                        }
                    }
                    
                    if let msg = avatarViewModel.errorMessage {
                        
                        Text(msg).foregroundColor(.red)
                    }
                }
                .frame(maxWidth: .infinity)
                
                // MARK: - Saved Avatars navigation
                Button {
                    
                    avatarListViewModel.loadAvatars()   // load BEFORE navigating
                    showSavedAvatars = true
                } label: {
                    
                    Label(Localizables.Buttons.avatars, systemImage: Images.avatars)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.roundedRectangle)
                .disabled(avatarViewModel.hasNoAvatars)
                .navigationDestination(isPresented: $showSavedAvatars) {
                    
                    AvatarListView(viewModel: avatarListViewModel)
                }
                
                // MARK: - Apple Repos navigation
                Button {
                    
                    appleRepoViewModel.resetAndLoad()
                    showAppleRepos = true
                } label: {
                    
                    Label(Localizables.Buttons.repos, systemImage: Images.repos)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.roundedRectangle)
                .navigationDestination(isPresented: $showAppleRepos) {
                    
                    AppleRepoView(viewModel: appleRepoViewModel)
                }
                
                Spacer()
                
                GlowingText(text: Localizables.Titles.bottomTitle)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 24)
            .task {
                
                emojiViewModel.loadEmojis()
            }
            .navigationTitle(Localizables.Titles.pageTitle)
        }
    }
}

//MARK: - Constants
private enum Localizables {
    
    enum Input {
        
        static let username = "Username"
    }
    
    enum Buttons {
        
        static let random = "Random Emoji"
        static let emojiList = "Emoji List"
        static let search = "Search"
        static let avatars = "Saved Avatars"
        static let repos = "Apple Repos"
    }
    
    enum Titles {
        
        static let pageTitle = "Emojipedia 📒"
        static let bottomTitle = "made with ❤️ by Alex Faria"
    }
}

private enum Images {
    
    static let random = "shuffle"
    static let emoji = "list.bullet"
    static let search = "magnifyingglass"
    static let avatars = "person.2.crop.square.stack"
    static let repos = "shippingbox.fill"
}

//MARK: - Preview
#Preview {
    
    ContentView()
}

// MARK: - GlowingText View
struct GlowingText: View {
    
    let text: String
    @State private var glow: Bool = false
    
    var body: some View {
        
        Text(text)
            .overlay(
                Text(text)
                    .foregroundColor(.gray.opacity(0.2))
                    .blur(radius: 4)
                    .opacity(glow ? 1 : 0.2)
            )
            .onAppear {
                
                withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                    
                    glow = true
                }
            }
            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: UUID())
    }
}
