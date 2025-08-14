import SwiftUI

//
//  ContentView.swift
//  blissAppsTechChallenge
//
//  Created by Alex Faria on 08/08/2025.
//

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var context
    
    @StateObject var emojiViewModel: EmojiViewModel
    @StateObject private var avatarViewModel: AvatarViewModel
    @StateObject private var avatarListViewModel: AvatarListViewModel
    
    @State private var showSavedAvatars = false

    init() {
        
        let context = PersistenceController.shared.container.viewContext
        _emojiViewModel = StateObject(wrappedValue: EmojiViewModel(context: context))
        _avatarViewModel = StateObject(wrappedValue: AvatarViewModel(context: context))
        _avatarListViewModel = StateObject(wrappedValue: AvatarListViewModel(context: context))
    }
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
            
                ZStack {
                    Rectangle()
                        .opacity(0)
                        .frame(height: 100)

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
                .padding()
                
                VStack(spacing: 12) {
                    
                    Button(Localizables.Buttons.random, systemImage: Images.random) {
                        
                        emojiViewModel.getRandomEmoji()
                    }
                    .labelStyle(.titleAndIcon)
                    .buttonStyle(.bordered)
                    .disabled(emojiViewModel.isLoading || emojiViewModel.emojis.isEmpty)
                    
                    NavigationLink(destination: EmojiListView(viewModel: emojiViewModel)) {
                        
                        Label(Localizables.Buttons.emojiList, systemImage: Images.emoji)
                    }
                    .labelStyle(.titleAndIcon)
                    .buttonStyle(.bordered)
                    .disabled(emojiViewModel.isLoading)
                }
                .padding(.vertical)
                
                VStack(spacing: 12) {
                    
                    HStack {
                        
                        TextField(Localizables.Buttons.search, text: $avatarViewModel.query)
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
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            Text(avatar.login).font(.headline)
                        }
                        .padding()
                    }

                    if let msg = avatarViewModel.errorMessage {
                        
                        Text(msg).foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
                
                Button {
                    
                    avatarListViewModel.loadAvatars()   // load BEFORE navigating
                    showSavedAvatars = true
                } label: {
                    
                    Label(Localizables.Buttons.avatars, systemImage: Images.avatars)
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.bordered)
                .disabled(avatarViewModel.hasNoAvatars)
                .navigationDestination(isPresented: $showSavedAvatars) {
                    
                    AvatarListView(viewModel: avatarListViewModel)
                }
            }
            .padding(.horizontal, 50)
            .task {
                
                emojiViewModel.loadEmojis()
            }
            .navigationTitle(Localizables.Titles.pageTitle)
        }
    }
}

//MARK: - Constants
private enum Localizables {
    
    enum Buttons {
        
        static let random = "Random Emoji"
        static let emojiList = "Emoji List"
        static let search = "Username"
        static let avatars = "Saved Avatares"
    }
    
    enum Titles {
        
        static let pageTitle = "Emojipedia 📒"
    }
}

private enum Images {
    
    static let random = "shuffle"
    static let emoji = "list.bullet"
    static let search = "magnifyingglass"
    static let avatars = "person.2.crop.square.stack"
}

//MARK: - Preview
#Preview {
    
    ContentView()
}
