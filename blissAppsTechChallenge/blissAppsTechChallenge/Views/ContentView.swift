//
//  ContentView.swift
//  blissAppsTechChallenge
//
//  Created by Alex Faria on 08/08/2025.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = EmojiViewModel()
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                Button("Get Emoji") {
                    
                    viewModel.loadEmojis()
                }
                .padding()
                
                ScrollView(.horizontal) {
                    
                    HStack {
                        
                        ForEach(viewModel.emojis.prefix(7)) { emoji in
                            
                            VStack {
                                
                                AsyncImage(url: URL(string: emoji.url)) { image in
                                        
                                    image.resizable().scaledToFit()
                                } placeholder: {
                                    
                                    ProgressView()
                                }
                                .frame(width: 50, height: 50)
                                
                                Text(emoji.id)
                                    .font(.caption2)
                            }
                            .padding(.horizontal, 4)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Emojipedia 📒")
        }
    }
}

#Preview {
    
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
