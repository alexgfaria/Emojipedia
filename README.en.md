# Bliss Apps Challenge – iOS
Tech assessment for Bliss Apps

🌍 Available languages: [Português](README.pt.md) | [English](README.en.md)

## Challenge
The full statement is available [here](./challenge.pdf).

## Implemented Features

This project implements the requirements of the Bliss Apps technical challenge, using SwiftUI, MVVM architecture, Core Data for local persistence, and asynchronous networking with async/await.

### 1. Emojis
#### 1.1 Random Emoji
- When the button is tapped, a random emoji is selected and displayed at the top of the screen.

#### 1.2 Emoji List
- Emojis are fetched from GitHub’s public API (https://api.github.com/emojis) using an asynchronous request with error handling.
- The retrieved data is displayed in a SwiftUI grid.

##### 1.2.1 Emoji Deletion and Pull to Refresh
- The user can remove emojis from temporary memory by tapping on them.
- A pull-to-refresh gesture restores the complete list of emojis.

#### 1.3 Persistence with Core Data
- The emoji list is stored locally using Core Data.
- When opening the app, if persisted data exists, it is automatically loaded.

### 2. GitHub Avatars
#### 2.1 Avatar Search
- The user can search for GitHub avatars by username.
- The search uses the GitHub API and displays the corresponding avatar, with error handling for nonexistent users.

#### 2.2 Avatar Cache
- Retrieved avatars are stored locally (Core Data cache), avoiding unnecessary repeated requests.
- If the avatar is already cached, the app displays the cached version.

#### 2.3 List and Deletion
- All retrieved avatars are listed in a dedicated screen.
- The user can remove avatars individually from the local database by tapping and confirming in the dialog.

### 3. Apple Repositories
#### 3.1 Repository List
- The app lists Apple’s public repositories on GitHub, using the repositories API.

#### 3.2 Pagination
- The repositories screen implements pagination: when scrolling to the end of the list, new pages of repositories are automatically loaded.

## Technical Details and Extras
- **Persistence:** Core Data is used to store emojis and avatars locally.  
- **UI:** SwiftUI is used for all screens, with NavigationStack for navigation.  
- **Networking:** All requests are performed with async/await, including error handling and loading states.  
- **Cache:** Retrieved avatars are cached locally to speed up future searches.  
- **UI Refinements:** Use of borders, spacing, grid, and adaptive layouts.  
- **Architecture:** MVVM, with clear separation between business logic (ViewModels), networking services, and persistence stores.  

## Final Notes
The project follows MVVM architecture, with clear separation of concerns. Networking and persistence services (Core Data) are decoupled from the views. SwiftUI and NavigationStack simplify navigation and screen organization. The codebase is modular, making it easier to maintain and extend in the future.
