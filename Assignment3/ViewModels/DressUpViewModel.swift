//
//  DressUpViewModel.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/23/23.
//

import Foundation

class DressUpViewModel: ObservableObject {
    @Published private(set) var dressUpData = [DressUpModel]()
    @Published private(set) var favoriteDressUp = [DressUpModel]()
    @Published var searchText: String = ""
    @Published var searchField: DressUpViewModel.SearchField = .name
    @Published var hasError = false
    @Published var error: DressUpModelError?
    @Published var isFavoritesOnly = false {
        didSet {
            searchText = ""
        }
    }
    private let favoriteDressUpKey = "favoriteBug"
    private let url = "https://api.nookipedia.com/nh/clothing?api_key=b15ac011-8ba5-4d29-974b-97118f9df0dd&category=dress-up"
    
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
                guard let results = try JSONDecoder().decode([DressUpModel]?.self, from: data) else {
                    self.hasError.toggle()
                    self.error = DressUpModelError.decodeError
//                    print(results[0])
                    return
                }
                self.dressUpData = results.sorted { $0.name.capitalized < $1.name.capitalized}
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
             }
            catch {
                self.hasError.toggle()
                self.error = DressUpModelError.customError(error: error)
                print(self.error)

            }
        }
    }
    
    var searchResults: [DressUpModel] {
        var res: [DressUpModel]
        if searchText.isEmpty {
            res = isFavoritesOnly ? favoriteDressUp : dressUpData
        } else {
            res = isFavoritesOnly ? favoriteDressUp.filter { $0.name.lowercased().contains(searchText.lowercased()) } : dressUpData.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        return res
    }
    
    private func loadFavoriteDressUp() {
        if let data = UserDefaults.standard.data(forKey: favoriteDressUpKey),
           let favorites = try? JSONDecoder().decode([DressUpModel].self, from: data) {
            self.favoriteDressUp = favorites
        }
    }
    
    private func saveFavoriteDressUp() {
        if let data = try? JSONEncoder().encode(favoriteDressUp) {
            UserDefaults.standard.set(data, forKey: favoriteDressUpKey)
        }
    }
    
    func toggleFavorite(dressUp: DressUpModel) {
        if let index = favoriteDressUp.firstIndex(where: { $0.id == dressUp.id }) {
            favoriteDressUp.remove(at: index)
        } else {
            favoriteDressUp.append(dressUp)
        }
        favoriteDressUp = favoriteDressUp.sorted {$0.name < $1.name}
        saveFavoriteDressUp()
    }
}

extension DressUpViewModel {
    enum DressUpModelError : LocalizedError {
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

