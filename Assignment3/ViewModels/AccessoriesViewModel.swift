//
//  AccessoriesViewModel.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/23/23.
//

import Foundation

class AccessoriesViewModel: ObservableObject {
    @Published private(set) var accessoriesData = [AccessoriesModel]()
    @Published private(set) var favoriteAccessories = [AccessoriesModel]()
    @Published var searchText: String = ""
    @Published var searchField: AccessoriesViewModel.SearchField = .name
    @Published var hasError = false
    @Published var error: AccessoriesModelError?
    @Published var isFavoritesOnly = false {
        didSet {
            searchText = ""
        }
    }
    private let favoriteAccessoriesKey = "favoriteBug"
    private let url = "https://api.nookipedia.com/nh/clothing?api_key=b15ac011-8ba5-4d29-974b-97118f9df0dd&category=accessories"
    
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
                guard let results = try JSONDecoder().decode([AccessoriesModel]?.self, from: data) else {
                    self.hasError.toggle()
                    self.error = AccessoriesModelError.decodeError
//                    print(results[0])
                    return
                }
                self.accessoriesData = results.sorted { $0.name.capitalized < $1.name.capitalized}
            } catch {
                self.hasError.toggle()
                self.error = AccessoriesModelError.customError(error: error)
            }
        }
    }
    
    var searchResults: [AccessoriesModel] {
        var res: [AccessoriesModel]
        if searchText.isEmpty {
            res = isFavoritesOnly ? favoriteAccessories : accessoriesData
        } else {
            res = isFavoritesOnly ? favoriteAccessories.filter { $0.name.lowercased().contains(searchText.lowercased()) } : accessoriesData.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        return res
    }
    
    private func loadFavoriteAccessories() {
        if let data = UserDefaults.standard.data(forKey: favoriteAccessoriesKey),
           let favorites = try? JSONDecoder().decode([AccessoriesModel].self, from: data) {
            self.favoriteAccessories = favorites
        }
    }
    
    private func saveFavoriteAccessories() {
        if let data = try? JSONEncoder().encode(favoriteAccessories) {
            UserDefaults.standard.set(data, forKey: favoriteAccessoriesKey)
        }
    }
    
    func toggleFavorite(accessories: AccessoriesModel) {
        if let index = favoriteAccessories.firstIndex(where: { $0.id == accessories.id }) {
            favoriteAccessories.remove(at: index)
        } else {
            favoriteAccessories.append(accessories)
        }
        favoriteAccessories = favoriteAccessories.sorted {$0.name < $1.name}
        saveFavoriteAccessories()
    }
}

extension AccessoriesViewModel {
    enum AccessoriesModelError : LocalizedError {
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
