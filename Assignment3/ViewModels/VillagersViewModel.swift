//
//  VillagersViewModel.swift
//  Assignment3
//
//  Created by Dan Kolan on 3/15/23.
//

import Foundation

class VillagersViewModel : ObservableObject {
    @Published private(set) var villagersData = [VillagerModel]()
    @Published var hasError = false
    @Published var error : VillagerModelError?
    private let url = "https://acnhapi.com/v1a/villagers/"
    
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
                self.villagersData = results
            } catch {
                self.hasError.toggle()
                self.error = VillagerModelError.customError(error: error)
            }
        }

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
