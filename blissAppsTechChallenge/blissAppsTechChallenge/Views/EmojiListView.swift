import SwiftUI

//
//  EmojiListView.swift
//  blissAppsTechChallenge
//
//  Created by Alex Faria on 08/08/2025.
//


struct EmojiListView: View {
    
    @ObservedObject var viewModel: EmojiViewModel
    @State private var items: [Emoji] = []
    
    init(viewModel: EmojiViewModel) {
        
        self.viewModel = viewModel
        _items = State(initialValue: viewModel.emojis)
    }
    
    var body: some View {
        
        ScrollView {
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60), spacing: 8)], spacing: 8) {
                
                ForEach(items) { emoji in
                    
                    if let url = URL(string: emoji.url) {
                        
                        AsyncImage(url: url) { result in
                            
                            switch result {
                                
                            case.success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .onTapGesture {
                                        
                                        items.removeAll { $0.id == emoji.id }
                                    }
                                
                            case .failure(_):
                                Image(systemName: Images.invalid)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.red)
                                    .frame(width: 50, height: 50)
                                
                            default:
                                ProgressView()
                                    .frame(width: 50, height: 50)
                            }
                            
                        }
                    }
                }
            }
        }
        .refreshable {
            
            withAnimation(
                .spring(
                    response: 0.35,
                    dampingFraction: 0.8)
            ) {
                
                items = viewModel.emojis
            }
        }
        .navigationTitle(Localizables.Titles.pageTitle)
    }
}

//MARK: - Constants
private enum Localizables {
    
    enum Titles {
        
        static let pageTitle = "Emoji List"
    }
}

private enum Images {
    
    static let invalid = "xmark.octagon.fill"
}

//MARK: - Preview
#Preview {
    
    func generatePreviewEmojis() -> [Emoji] {
        
        let baseEmojis = [
            Emoji(id: "smile", url: "https://github.githubassets.com/images/icons/emoji/unicode/1f604.png?v8"),
            Emoji(id: "heart", url: "https://github.githubassets.com/images/icons/emoji/unicode/2764.png?v8"),
            Emoji(id: "tada", url: "https://github.githubassets.com/images/icons/emoji/unicode/1f389.png?v8")
        ]
        
        return (0..<60).map { index in
            let emoji = baseEmojis[index % baseEmojis.count]
            return Emoji(id: "\(emoji.id)\(index)", url: emoji.url)
        }
    }
    
    let previewController = PersistenceController(inMemory: true)
    let previewViewModel = EmojiViewModel(context: previewController.container.viewContext)
    previewViewModel.emojis = generatePreviewEmojis()
    
    return NavigationStack {
        EmojiListView(viewModel: previewViewModel)
    }
}
