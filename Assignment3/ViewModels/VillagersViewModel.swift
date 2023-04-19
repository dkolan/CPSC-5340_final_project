//
//  VillagersViewModel.swift
//  Assignment3
//
//  Created by Dan Kolan on 3/15/23.
//

import Foundation

class VillagersViewModel : ObservableObject {
    @Published private(set) var villagersData = [VillagerModel]()
    @Published private(set) var favoriteVillagers = [VillagerModel]()
    @Published var searchText: String = ""
    @Published var searchField: VillagersViewModel.SearchField = .name
    @Published var hasError = false
    @Published var error : VillagerModelError?
    @Published var isFavoritesOnly = false {
        didSet {
            searchText = ""
        }
    }
    private let favoriteVillagersKey = "favoriteVillagers"
    private let url = "https://api.nookipedia.com/villagers?api_key=\(NookpediaViewModel.apiKey)"
    
    init() {
        loadFavoriteVillagers()
    }

    enum SearchField: String, CaseIterable {
        case name
        case personality
        case species
        var displayName: String {
            switch self {
            case .name: return "Name"
            case .personality: return "Personality"
            case .species: return "Species"
            }
        }
    }

    @MainActor
    func fetchData() async {
        if let url = URL(string: self.url) {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let results = try JSONDecoder().decode([VillagerModel]?.self, from: data) else {
                    self.hasError.toggle()
                    self.error = VillagerModelError.decodeError
                    return
                }
                let newHorizonVillagers = results.filter { result in
                    return result.appearances.contains("NH")
                }
                self.villagersData = newHorizonVillagers.sorted { $0.name < $1.name}
            } catch {
                self.hasError.toggle()
                self.error = VillagerModelError.customError(error: error)
            }
        }
    }

    var searchResults: [VillagerModel] {
        var res: [VillagerModel]
        if searchText.isEmpty {
            res = isFavoritesOnly ? favoriteVillagers : villagersData
        } else {
            switch searchField {
            case .name:
                res = isFavoritesOnly ? favoriteVillagers.filter { $0.name.lowercased().contains(searchText.lowercased()) } : villagersData.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            case .personality:
                res = isFavoritesOnly ? favoriteVillagers.filter { $0.personality.lowercased().contains(searchText.lowercased()) } : villagersData.filter { $0.personality.lowercased().contains(searchText.lowercased()) }
            case .species:
                res = isFavoritesOnly ? favoriteVillagers.filter { $0.species.lowercased().contains(searchText.lowercased()) } : villagersData.filter { $0.species.lowercased().contains(searchText.lowercased()) }
            }
        }
        return res
    }

    private func loadFavoriteVillagers() {
        if let data = UserDefaults.standard.data(forKey: favoriteVillagersKey),
           let favorites = try? JSONDecoder().decode([VillagerModel].self, from: data) {
            self.favoriteVillagers = favorites
        }
    }

    private func saveFavoriteVillagers() {
        if let data = try? JSONEncoder().encode(favoriteVillagers) {
            UserDefaults.standard.set(data, forKey: favoriteVillagersKey)
        }
    }

    func toggleFavorite(villager: VillagerModel) {
        if let index = favoriteVillagers.firstIndex(where: { $0.id == villager.id }) {
            favoriteVillagers.remove(at: index)
        } else {
            favoriteVillagers.append(villager)
        }
        favoriteVillagers = favoriteVillagers.sorted {$0.name < $1.name}
        saveFavoriteVillagers()
    }
}

extension VillagersViewModel {
    enum VillagerModelError : LocalizedError {
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
