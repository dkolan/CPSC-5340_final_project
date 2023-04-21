//
//  BugViewModel.swift
//  Assignment3
//
//  Created by Dan Kolan on 4/19/23.
//

import Foundation
import CoreLocation

class BugViewModel : ObservableObject {
    @Published private(set) var BugData = [BugModel]()
    @Published private(set) var favoriteBug = [BugModel]()
    @Published var searchText: String = ""
    @Published var searchField: BugViewModel.SearchField = .name
    @Published var currentlyAvailableToggle : Bool = false
    @Published var hasError = false
    @Published var error: BugModelError?
    @Published var hemisphere: String = ""
    @Published var isFavoritesOnly = false {
        didSet {
            searchText = ""
        }
    }
    private let favoriteBugKey = "favoriteBug"
    private let url = "https://api.nookipedia.com/nh/bugs?api_key=\(NookpediaViewModel.apiKey)"

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
                guard let results = try JSONDecoder().decode([BugModel]?.self, from: data) else {
                    self.hasError.toggle()
                    self.error = BugModelError.decodeError
                    return
                }
                self.BugData = results.sorted { $0.name.capitalized < $1.name.capitalized}
            } catch {
                self.hasError.toggle()
                self.error = BugModelError.customError(error: error)
            }
        }
    }

    var searchResults: [BugModel] {
        var res : [BugModel]
        if searchText.isEmpty {
            res = isFavoritesOnly ? favoriteBug : BugData
        } else {
            res = isFavoritesOnly ? favoriteBug.filter { $0.name.lowercased().contains(searchText.lowercased()) } : BugData.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }

        if currentlyAvailableToggle {
            let currentMonth = Calendar.current.component(.month, from: Date())
            res = hemisphere == "north" ?
                res.filter { $0.north.months_array.contains(currentMonth) }
                : res.filter { $0.south.months_array.contains(currentMonth) }
        }

        return res
    }

    private func loadFavoriteBug() {
        if let data = UserDefaults.standard.data(forKey: favoriteBugKey),
           let favorites = try? JSONDecoder().decode([BugModel].self, from: data) {
            self.favoriteBug = favorites
        }
    }

    private func saveFavoriteBug() {
        if let data = try? JSONEncoder().encode(favoriteBug) {
            UserDefaults.standard.set(data, forKey: favoriteBugKey)
        }
    }

    func toggleFavorite(Bug: BugModel) {
        if let index = favoriteBug.firstIndex(where: { $0.id == Bug.id }) {
            favoriteBug.remove(at: index)
        } else {
            favoriteBug.append(Bug)
        }
        favoriteBug = favoriteBug.sorted {$0.name < $1.name}
        saveFavoriteBug()
    }

}

extension BugViewModel {
    enum BugModelError : LocalizedError {
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
