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

    init() {
        let context = PersistenceController.shared.container.viewContext
        _viewModel = StateObject(wrappedValue: EmojiViewModel(context: context))
    }
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                Button("Get Emojis") {
                    
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
    
    ContentView()
}
