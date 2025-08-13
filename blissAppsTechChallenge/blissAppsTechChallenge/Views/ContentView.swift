import SwiftUI

//
//  ContentView.swift
//  blissAppsTechChallenge
//
//  Created by Alex Faria on 08/08/2025.
//

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var context
    @StateObject var viewModel: EmojiViewModel
    @State private var showEmojiList = false

    init() {
        let context = PersistenceController.shared.container.viewContext
        _viewModel = StateObject(wrappedValue: EmojiViewModel(context: context))
    }
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
            
                ZStack {
                    Rectangle()
                        .opacity(0)
                        .frame(height: 100)

                    if let emoji = viewModel.randomEmoji {
                        
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
                
                Button("Random Emoji", systemImage: "shuffle") {
                    
                    viewModel.getRandomEmoji()
                }
                .padding()
                .labelStyle(.titleAndIcon)
                .buttonStyle(.bordered)
                .disabled(viewModel.isLoading)
                
                NavigationLink(destination: EmojiListView(viewModel: viewModel)) {
                    
                    Label("Emoji List", systemImage: "list.bullet")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .labelStyle(.titleAndIcon)
                .buttonStyle(.bordered)
            }
            .task {
                
                viewModel.loadEmojis()
            }
            .navigationTitle("Emojipedia 📒")
        }
    }
}

#Preview {
    
    ContentView()
}
