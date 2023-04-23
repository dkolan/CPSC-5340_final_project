//
//  ShoeViewModel.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/23/23.
//

import Foundation

class ShoeViewModel: ObservableObject {
    @Published private(set) var shoeData = [ShoeModel]()
    @Published private(set) var favoriteShoe = [ShoeModel]()
    @Published var searchText: String = ""
    @Published var searchField: ShoeViewModel.SearchField = .name
    @Published var hasError = false
    @Published var error: ShoeModelError?
    @Published var isFavoritesOnly = false {
        didSet {
            searchText = ""
        }
    }
    private let favoriteShoeKey = "favoriteBug"
    private let url = "https://api.nookipedia.com/nh/clothing?api_key=b15ac011-8ba5-4d29-974b-97118f9df0dd&category=Shoes"
    
    enum SearchField: String, CaseIterable {
        case name
        var displayName: String {
            switch self {
            case .name: return "Name"
            }
        }
    }
    
    @MainActor
    func fetchData() async {
        if let url = URL(string: self.url) {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let results = try JSONDecoder().decode([ShoeModel]?.self, from: data) else {
                    self.hasError.toggle()
                    self.error = ShoeModelError.decodeError
//                    print(results[0])
                    return
                }
                self.shoeData = results.sorted { $0.name.capitalized < $1.name.capitalized}
            } catch {
                self.hasError.toggle()
                self.error = ShoeModelError.customError(error: error)
            }
        }
    }
    
    var searchResults: [ShoeModel] {
        var res: [ShoeModel]
        if searchText.isEmpty {
            res = isFavoritesOnly ? favoriteShoe : shoeData
        } else {
            res = isFavoritesOnly ? favoriteShoe.filter { $0.name.lowercased().contains(searchText.lowercased()) } : shoeData.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        return res
    }
    
    private func loadFavoriteShoe() {
        if let data = UserDefaults.standard.data(forKey: favoriteShoeKey),
           let favorites = try? JSONDecoder().decode([ShoeModel].self, from: data) {
            self.favoriteShoe = favorites
        }
    }
    
    private func saveFavoriteShoe() {
        if let data = try? JSONEncoder().encode(favoriteShoe) {
            UserDefaults.standard.set(data, forKey: favoriteShoeKey)
        }
    }
    
    func toggleFavorite(shoe: ShoeModel) {
        if let index = favoriteShoe.firstIndex(where: { $0.id == shoe.id }) {
            favoriteShoe.remove(at: index)
        } else {
            favoriteShoe.append(shoe)
        }
        favoriteShoe = favoriteShoe.sorted {$0.name < $1.name}
        saveFavoriteShoe()
    }
}

extension ShoeViewModel {
    enum ShoeModelError : LocalizedError {
        case decodeError
        case customError(error: Error)

        var errorDescription: String? {
            switch self {
            case .decodeError:
                return "Decoding error."
            case .customError(let error):
                return error.localizedDescription
            }
        }
    }
}
