//
//  BottomViewModel.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/23/23.
//

import Foundation

class BottomViewModel: ObservableObject {
    @Published private(set) var bottomData = [BottomModel]()
    @Published private(set) var favoriteBottom = [BottomModel]()
    @Published var searchText: String = ""
    @Published var searchField: BottomViewModel.SearchField = .name
    @Published var hasError = false
    @Published var error: BottomModelError?
    @Published var isFavoritesOnly = false {
        didSet {
            searchText = ""
        }
    }
    private let favoriteBottomKey = "favoriteBug"
    private let url = "https://api.nookipedia.com/nh/clothing?api_key=b15ac011-8ba5-4d29-974b-97118f9df0dd&category=Bottoms"
    
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
                guard let results = try JSONDecoder().decode([BottomModel]?.self, from: data) else {
                    self.hasError.toggle()
                    self.error = BottomModelError.decodeError
//                    print(results[0])
                    return
                }
                self.bottomData = results.sorted { $0.name.capitalized < $1.name.capitalized}
            } catch {
                self.hasError.toggle()
                self.error = BottomModelError.customError(error: error)
            }
        }
    }
    
    var searchResults: [BottomModel] {
        var res: [BottomModel]
        if searchText.isEmpty {
            res = isFavoritesOnly ? favoriteBottom : bottomData
        } else {
            res = isFavoritesOnly ? favoriteBottom.filter { $0.name.lowercased().contains(searchText.lowercased()) } : bottomData.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        return res
    }
    
    private func loadFavoriteBottom() {
        if let data = UserDefaults.standard.data(forKey: favoriteBottomKey),
           let favorites = try? JSONDecoder().decode([BottomModel].self, from: data) {
            self.favoriteBottom = favorites
        }
    }
    
    private func saveFavoriteBottom() {
        if let data = try? JSONEncoder().encode(favoriteBottom) {
            UserDefaults.standard.set(data, forKey: favoriteBottomKey)
        }
    }
    
    func toggleFavorite(bottom: BottomModel) {
        if let index = favoriteBottom.firstIndex(where: { $0.id == bottom.id }) {
            favoriteBottom.remove(at: index)
        } else {
            favoriteBottom.append(bottom)
        }
        favoriteBottom = favoriteBottom.sorted {$0.name < $1.name}
        saveFavoriteBottom()
    }
}

extension BottomViewModel {
    enum BottomModelError : LocalizedError {
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

