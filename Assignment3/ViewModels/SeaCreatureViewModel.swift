//
//  SeaCreatureViewModel.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/19/23.
//

import Foundation
import CoreLocation

class SeaCreatureViewModel : ObservableObject {
    @Published private(set) var SeaCreatureData = [SeaCreatureModel]()
    @Published private(set) var favoriteSeaCreature = [SeaCreatureModel]()
    @Published var searchText: String = ""
    @Published var searchField: SeaCreatureViewModel.SearchField = .name
    @Published var currentlyAvailableToggle : Bool = false
    @Published var hasError = false
    @Published var error: SeaCreatureModelError?
    @Published var hemisphere: String = ""
    @Published var isFavoritesOnly = false {
        didSet {
            searchText = ""
        }
    }
    private let favoriteSeaCreatureKey = "favoriteSeaCreature"
    private let url = "https://api.nookipedia.com/nh/sea?api_key=\(NookpediaViewModel.apiKey)"

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
                guard let results = try JSONDecoder().decode([SeaCreatureModel]?.self, from: data) else {
                    self.hasError.toggle()
                    self.error = SeaCreatureModelError.decodeError
                    return
                }
                self.SeaCreatureData = results.sorted { $0.name.capitalized < $1.name.capitalized}
            } catch {
                self.hasError.toggle()
                self.error = SeaCreatureModelError.customError(error: error)
            }
        }
    }

    var searchResults: [SeaCreatureModel] {
        var res : [SeaCreatureModel]
        if searchText.isEmpty {
            res = isFavoritesOnly ? favoriteSeaCreature : SeaCreatureData
        } else {
            res = isFavoritesOnly ? favoriteSeaCreature.filter { $0.name.lowercased().contains(searchText.lowercased()) } : SeaCreatureData.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }

        if currentlyAvailableToggle {
            let currentMonth = Calendar.current.component(.month, from: Date())
            res = hemisphere == "north" ?
                res.filter { $0.north.months_array.contains(currentMonth) }
                : res.filter { $0.south.months_array.contains(currentMonth) }
        }

        return res
    }

    private func loadFavoriteSeaCreature() {
        if let data = UserDefaults.standard.data(forKey: favoriteSeaCreatureKey),
           let favorites = try? JSONDecoder().decode([SeaCreatureModel].self, from: data) {
            self.favoriteSeaCreature = favorites
        }
    }

    private func saveFavoriteSeaCreature() {
        if let data = try? JSONEncoder().encode(favoriteSeaCreature) {
            UserDefaults.standard.set(data, forKey: favoriteSeaCreatureKey)
        }
    }

    func toggleFavorite(SeaCreature: SeaCreatureModel) {
        if let index = favoriteSeaCreature.firstIndex(where: { $0.id == SeaCreature.id }) {
            favoriteSeaCreature.remove(at: index)
        } else {
            favoriteSeaCreature.append(SeaCreature)
        }
        favoriteSeaCreature = favoriteSeaCreature.sorted {$0.name < $1.name}
        saveFavoriteSeaCreature()
    }

}

extension SeaCreatureViewModel {
    enum SeaCreatureModelError : LocalizedError {
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
