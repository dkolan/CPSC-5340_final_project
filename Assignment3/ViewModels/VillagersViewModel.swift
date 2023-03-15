//
//  VillagersViewModel.swift
//  Assignment3
//
//  Created by Dan Kolan on 3/15/23.
//

import Foundation

class VillagersViewModel : ObservableObject {
    @Published private(set) var villagersData = [VillagerModel]()
    private let url = "https://acnhapi.com/v1a/villagers/"
    
    func fetchData() {
        if let url = URL(string: self.url) {
            URLSession
                .shared
                .dataTask(with: url) { data, response, error in
                    if let error = error {
                        print(error)
                    } else {
                        if let data = data {
                            do {
                                let results = try JSONDecoder().decode([VillagerModel].self, from: data)
                                DispatchQueue.main.async {
                                    self.villagersData = results
                                }
                            } catch {
                                print(error)
                            }
                        }
                    }
                }.resume()
        }
    }
}
