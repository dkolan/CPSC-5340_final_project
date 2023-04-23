//
//  FossilViewModel.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/22/23.
//

import Foundation

class FossilViewModel: ObservableObject {
    @Published private(set) var fossilData = [FossilModel]()
    @Published private(set) var favoriteFossil = [FossilModel]()
    @Published var searchText: String = ""
    @Published var searchField: FossilViewModel.SearchField = .name
    @Published var hasError = false
    @Published var error: FossilModelError?
    @Published var isFavoritesOnly = false {
        didSet {
            searchText = ""
        }
    }
    private let favoriteFossilKey = "favoriteFossil"
    private let url = "https://api.nookipedia.com/nh/fossils/individuals?api_key=\(NookpediaViewModel.apiKey)"

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
                guard let results = try JSONDecoder().decode([FossilModel]?.self, from: data) else {
                    self.hasError.toggle()
                    self.error = FossilModelError.decodeError
                    return
                }
                self.fossilData = results.sorted { $0.name.capitalized < $1.name.capitalized}
            } catch {
                self.hasError.toggle()
                self.error = FossilModelError.customError(error: error)
                print(error)
            }
        }
    }

    var searchResults: [FossilModel] {
        var res : [FossilModel]
        if searchText.isEmpty {
            res = isFavoritesOnly ? favoriteFossil : fossilData
        } else {
            res = isFavoritesOnly ? favoriteFossil.filter { $0.name.lowercased().contains(searchText.lowercased()) } : fossilData.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }

        return res
    }

    private func loadFavoriteFossil() {
        if let data = UserDefaults.standard.data(forKey: favoriteFossilKey),
           let favorites = try? JSONDecoder().decode([FossilModel].self, from: data) {
            self.favoriteFossil = favorites
        }
    }

    private func saveFavoriteFossil() {
        if let data = try? JSONEncoder().encode(favoriteFossil) {
            UserDefaults.standard.set(data, forKey: favoriteFossilKey)
        }
    }

    func toggleFavorite(fossil: FossilModel) {
        if let index = favoriteFossil.firstIndex(where: { $0.id == fossil.id }) {
            favoriteFossil.remove(at: index)
        } else {
            favoriteFossil.append(fossil)
        }
        favoriteFossil = favoriteFossil.sorted {$0.name < $1.name}
        saveFavoriteFossil()
    }
}

extension FossilViewModel {
    enum FossilModelError : LocalizedError {
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
