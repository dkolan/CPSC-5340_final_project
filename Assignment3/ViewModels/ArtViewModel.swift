//
//  ArtViewModel.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/21/23.
//

import Foundation

class ArtViewModel: ObservableObject {
    @Published private(set) var artData = [ArtModel]()
    @Published private(set) var favoriteArt = [ArtModel]()
    @Published var searchText: String = ""
    @Published var searchField: ArtViewModel.SearchField = .name
    @Published var hasFakeToggle : Bool = false
    @Published var hasError = false
    @Published var error: ArtModelError?
    @Published var isFavoritesOnly = false {
        didSet {
            searchText = ""
        }
    }
    private let favoriteArtKey = "favoriteArt"
    private let url = "https://api.nookipedia.com/nh/art?api_key=b15ac011-8ba5-4d29-974b-97118f9df0dd"

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
                guard let results = try JSONDecoder().decode([ArtModel]?.self, from: data) else {
                    self.hasError.toggle()
                    self.error = ArtModelError.decodeError
                    return
                }
                self.artData = results.sorted { $0.name.capitalized < $1.name.capitalized}
            } catch {
                self.hasError.toggle()
                self.error = ArtModelError.customError(error: error)
            }
        }
    }

    var searchResults: [ArtModel] {
        var res : [ArtModel]
        if searchText.isEmpty {
            res = isFavoritesOnly ? favoriteArt : artData
        } else {
            res = isFavoritesOnly ? favoriteArt.filter { $0.name.lowercased().contains(searchText.lowercased()) } : artData.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }

        if hasFakeToggle {
            res = res.filter { $0.has_fake }
        }
        return res
    }

    private func loadFavoriteArt() {
        if let data = UserDefaults.standard.data(forKey: favoriteArtKey),
           let favorites = try? JSONDecoder().decode([ArtModel].self, from: data) {
            self.favoriteArt = favorites
        }
    }

    private func saveFavoriteArt() {
        if let data = try? JSONEncoder().encode(favoriteArt) {
            UserDefaults.standard.set(data, forKey: favoriteArtKey)
        }
    }

    func toggleFavorite(art: ArtModel) {
        if let index = favoriteArt.firstIndex(where: { $0.id == art.id }) {
            favoriteArt.remove(at: index)
        } else {
            favoriteArt.append(art)
        }
        favoriteArt = favoriteArt.sorted {$0.name < $1.name}
        saveFavoriteArt()
    }
}

extension ArtViewModel {
    enum ArtModelError : LocalizedError {
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
