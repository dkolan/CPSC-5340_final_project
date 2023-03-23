//
//  FishViewModel.swift
//  Assignment3
//
//  Created by Dan Kolan on 3/19/23.
//

import Foundation

class FishViewModel : ObservableObject {
    @Published private(set) var fishData = [FishModel]()
    @Published var searchText: String = ""
    @Published var searchField: FishViewModel.SearchField = .name
    @Published var currentlyAvailableToggle : Bool = false
    @Published var hasError = false
    @Published var error : FishModelError?
    private let url = "https://acnhapi.com/v1a/fish/"
    
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
                self.fishData = results.sorted { $0.name.nameUsEn.capitalized < $1.name.nameUsEn.capitalized}
            } catch {
                self.hasError.toggle()
                self.error = FishModelError.customError(error: error)
            }
        }
    }
    
    var searchResults: [FishModel] {
        var res : [FishModel]
        if searchText.isEmpty {
            res = fishData
        } else {
            res = fishData.filter { $0.name.nameUsEn.lowercased().contains(searchText.lowercased()) }
        }
        
        if currentlyAvailableToggle {
            let currentMonth = Calendar.current.component(.month, from: Date())
            res = res.filter { $0.availability.monthArrayNorthern.contains(currentMonth) }
        }
        
        return res
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
