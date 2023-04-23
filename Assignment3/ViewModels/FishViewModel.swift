////
////  FishViewModel.swift
////  ACNH Reference
////
////  Created by Dan Kolan on 3/19/23.
////
//
import Foundation
import CoreLocation

class FishViewModel : ObservableObject {
    @Published private(set) var fishData = [FishModel]()
    @Published private(set) var favoriteFish = [FishModel]()
    @Published var searchText: String = ""
    @Published var searchField: FishViewModel.SearchField = .name
    @Published var currentlyAvailableToggle : Bool = false
    @Published var hasError = false
    @Published var error: FishModelError?
    @Published var hemisphere: String = ""
    @Published var isFavoritesOnly = false {
        didSet {
            searchText = ""
        }
    }
    private let favoriteFishKey = "favoriteFish"
    private let url = "https://api.nookipedia.com/nh/fish?api_key=\(NookpediaViewModel.apiKey)"
    
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
                guard let results = try JSONDecoder().decode([FishModel]?.self, from: data) else {
                    self.hasError.toggle()
                    self.error = FishModelError.decodeError
                    return
                }
                self.fishData = results.sorted { $0.name.capitalized < $1.name.capitalized}
            } catch {
                self.hasError.toggle()
                self.error = FishModelError.customError(error: error)
            }
        }
    }
    
    var searchResults: [FishModel] {
        var res : [FishModel]
        if searchText.isEmpty {
            res = isFavoritesOnly ? favoriteFish : fishData
        } else {
            res = isFavoritesOnly ? favoriteFish.filter { $0.name.lowercased().contains(searchText.lowercased()) } : fishData.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }

        if currentlyAvailableToggle {
            let currentMonth = Calendar.current.component(.month, from: Date())
            res = hemisphere == "north" ?
                res.filter { $0.north.months_array.contains(currentMonth) }
                : res.filter { $0.south.months_array.contains(currentMonth) }
        }
        
        return res
    }

    private func loadFavoriteFish() {
        if let data = UserDefaults.standard.data(forKey: favoriteFishKey),
           let favorites = try? JSONDecoder().decode([FishModel].self, from: data) {
            self.favoriteFish = favorites
        }
    }

    private func saveFavoriteFish() {
        if let data = try? JSONEncoder().encode(favoriteFish) {
            UserDefaults.standard.set(data, forKey: favoriteFishKey)
        }
    }

    func toggleFavorite(fish: FishModel) {
        if let index = favoriteFish.firstIndex(where: { $0.id == fish.id }) {
            favoriteFish.remove(at: index)
        } else {
            favoriteFish.append(fish)
        }
        favoriteFish = favoriteFish.sorted {$0.name < $1.name}
        saveFavoriteFish()
    }

}

extension FishViewModel {
    enum FishModelError : LocalizedError {
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
