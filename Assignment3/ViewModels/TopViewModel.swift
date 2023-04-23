//
//  TopViewModel.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/22/23.
//

import Foundation

class TopViewModel: ObservableObject {
    @Published private(set) var topData = [TopModel]()
    @Published private(set) var favoriteTop = [TopModel]()
    @Published var searchText: String = ""
    @Published var searchField: TopViewModel.SearchField = .name
    @Published var hasError = false
    @Published var error: TopModelError?
    @Published var isFavoritesOnly = false {
        didSet {
            searchText = ""
        }
    }
    private let favoriteTopKey = "favoriteBug"
    private let url = "https://api.nookipedia.com/nh/clothing?api_key=b15ac011-8ba5-4d29-974b-97118f9df0dd&category=Tops"
    
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
                guard let results = try JSONDecoder().decode([TopModel]?.self, from: data) else {
                    self.hasError.toggle()
                    self.error = TopModelError.decodeError
//                    print(results[0])
                    return
                }
                self.topData = results.sorted { $0.name.capitalized < $1.name.capitalized}
            } catch {
                self.hasError.toggle()
                self.error = TopModelError.customError(error: error)
            }
        }
    }
    
    var searchResults: [TopModel] {
        var res: [TopModel]
        if searchText.isEmpty {
            res = isFavoritesOnly ? favoriteTop : topData
        } else {
            res = isFavoritesOnly ? favoriteTop.filter { $0.name.lowercased().contains(searchText.lowercased()) } : topData.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        return res
    }
    
    private func loadFavoriteTop() {
        if let data = UserDefaults.standard.data(forKey: favoriteTopKey),
           let favorites = try? JSONDecoder().decode([TopModel].self, from: data) {
            self.favoriteTop = favorites
        }
    }
    
    private func saveFavoriteTop() {
        if let data = try? JSONEncoder().encode(favoriteTop) {
            UserDefaults.standard.set(data, forKey: favoriteTopKey)
        }
    }
    
    func toggleFavorite(top: TopModel) {
        if let index = favoriteTop.firstIndex(where: { $0.id == top.id }) {
            favoriteTop.remove(at: index)
        } else {
            favoriteTop.append(top)
        }
        favoriteTop = favoriteTop.sorted {$0.name < $1.name}
        saveFavoriteTop()
    }
}

extension TopViewModel {
    enum TopModelError : LocalizedError {
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
