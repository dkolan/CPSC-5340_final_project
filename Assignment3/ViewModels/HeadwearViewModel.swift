//
//  HeadwearViewModel.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/23/23.
//

import Foundation

class HeadwearViewModel: ObservableObject {
    @Published private(set) var headwearData = [HeadwearModel]()
    @Published private(set) var favoriteHeadwear = [HeadwearModel]()
    @Published var searchText: String = ""
    @Published var searchField: HeadwearViewModel.SearchField = .name
    @Published var hasError = false
    @Published var error: HeadwearModelError?
    @Published var isFavoritesOnly = false {
        didSet {
            searchText = ""
        }
    }
    private let favoriteHeadwearKey = "favoriteBug"
    private let url = "https://api.nookipedia.com/nh/clothing?api_key=b15ac011-8ba5-4d29-974b-97118f9df0dd&category=headwear"
    
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
                guard let results = try JSONDecoder().decode([HeadwearModel]?.self, from: data) else {
                    self.hasError.toggle()
                    self.error = HeadwearModelError.decodeError
//                    print(results[0])
                    return
                }
                self.headwearData = results.sorted { $0.name.capitalized < $1.name.capitalized}
            } catch {
                self.hasError.toggle()
                self.error = HeadwearModelError.customError(error: error)
            }
        }
    }
    
    var searchResults: [HeadwearModel] {
        var res: [HeadwearModel]
        if searchText.isEmpty {
            res = isFavoritesOnly ? favoriteHeadwear : headwearData
        } else {
            res = isFavoritesOnly ? favoriteHeadwear.filter { $0.name.lowercased().contains(searchText.lowercased()) } : headwearData.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        return res
    }
    
    private func loadFavoriteHeadwear() {
        if let data = UserDefaults.standard.data(forKey: favoriteHeadwearKey),
           let favorites = try? JSONDecoder().decode([HeadwearModel].self, from: data) {
            self.favoriteHeadwear = favorites
        }
    }
    
    private func saveFavoriteHeadwear() {
        if let data = try? JSONEncoder().encode(favoriteHeadwear) {
            UserDefaults.standard.set(data, forKey: favoriteHeadwearKey)
        }
    }
    
    func toggleFavorite(headwear: HeadwearModel) {
        if let index = favoriteHeadwear.firstIndex(where: { $0.id == headwear.id }) {
            favoriteHeadwear.remove(at: index)
        } else {
            favoriteHeadwear.append(headwear)
        }
        favoriteHeadwear = favoriteHeadwear.sorted {$0.name < $1.name}
        saveFavoriteHeadwear()
    }
}

extension HeadwearViewModel {
    enum HeadwearModelError : LocalizedError {
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
