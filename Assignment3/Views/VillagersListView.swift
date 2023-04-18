//
//  VillagersListView.swift
//  Assignment3
//
//  Created by Dan Kolan on 3/16/23.
//

import SwiftUI

struct VillagersListView: View {
    @ObservedObject var villagersVM = VillagersViewModel()
    let villagerIconBaseUrl = "https://acnhcdn.com/latest/NpcIcon/"

    var body: some View {
        VStack {
            Picker("Search By", selection: $villagersVM.searchField) {
                ForEach(VillagersViewModel.SearchField.allCases, id: \.self) { field in
                    Text(field.displayName).tag(field)
                }
            }
            .pickerStyle(.segmented)
//            HStack {
//                Button(action: { villagersVM.isFavoritesOnly.toggle() }) {
//                    Image(systemName: villagersVM.isFavoritesOnly ? "star.fill" : "star")
//                        .foregroundColor(.yellow)
//                    Text("Favorites")
//                }
//            }
//            .padding(5)
            List {
                ForEach(villagersVM.searchResults) { villager in
                    NavigationLink {
                        VillagerDetail(villager: villager)
                    } label: {
                        HStack {
                            Image(systemName: villagersVM.favoriteVillagers
                                .contains(where: { $0.id == villager.id }) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .onTapGesture {
                                    villagersVM.toggleFavorite(villager: villager)
                                }
                            IconView(url: "\(villagerIconBaseUrl)\(villager.id).png", frameWidth: 50, frameHeight: 50)
                            Text(villager.name)
                        }
                    }
                }
            }
            .task {
                await villagersVM.fetchData()
            }
            .listStyle(.grouped)
            .navigationTitle("Villagers")
            .alert(isPresented: $villagersVM.hasError, error: villagersVM.error) {
                Text("Error.")
            }
            .searchable(text: $villagersVM.searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
        .padding(5)
        .navigationBarItems(trailing: Button(action: {
            villagersVM.isFavoritesOnly.toggle()
        }) {
            Text("Favorites")
            Image(systemName: villagersVM.isFavoritesOnly ? "star.fill" : "star")
                .foregroundColor(.yellow)
        })
    }
}

struct VillagersListView_Previews: PreviewProvider {
    static var previews: some View {
        VillagersListView()
    }
}
