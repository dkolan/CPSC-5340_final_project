//
//  FishListView.swift
//  Assignment3
//
//  Created by Dan Kolan on 3/20/23.
//

import SwiftUI

struct FishListView: View {
    @ObservedObject var fishVM = FishViewModel()
    
    var body: some View {
        VStack {
            Picker("Search By", selection: $fishVM.searchField) {
                ForEach(FishViewModel.SearchField.allCases, id: \.self) { field in
                    Text(field.displayName).tag(field)
                }
            }
            .pickerStyle(.segmented)
            List {
                ForEach(fishVM.searchResults) { fish in
                    NavigationLink {
                        FishDetail(fish: fish)
                    } label: {
                        HStack {
//                            ImageCardView(url: fish.icon_uri, frameWidth: 50, frameHeight: 50)
                            Text(fish.name.nameUsEn.capitalized)
                        }
                    }
                }
            }
            .task {
                await fishVM.fetchData()
            }
            .listStyle(.grouped)
            .navigationTitle("Villagers")
            .alert(isPresented: $fishVM.hasError, error: fishVM.error) {
                Text("Error.")
            }
            .searchable(text: $fishVM.searchText)
        }
    }
}

struct FishListView_Previews: PreviewProvider {
    static var previews: some View {
        FishListView()
    }
}
