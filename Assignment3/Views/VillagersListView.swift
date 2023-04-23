//
//  VillagersListView.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 3/16/23.
//

import SwiftUI

struct VillagersListView: View {
    @StateObject var villagersVM = VillagersViewModel()
    let villagerIconBaseUrl = "https://acnhcdn.com/latest/NpcIcon/"

    var body: some View {
        ZStack {
            Color("ACNHBackground").ignoresSafeArea()
            VStack {
                Picker("Search By", selection: $villagersVM.searchField) {
                    ForEach(VillagersViewModel.SearchField.allCases, id: \.self) { field in
                        Text(field.displayName).tag(field)
                            .foregroundColor(Color("ACNHText"))
                    }
                }
                .pickerStyle(.segmented)
                VStack {
                    List {
                        ForEach(villagersVM.searchResults) { villager in
                            NavigationLink {
                                VillagerDetail(villager: villager)
                            } label: {
                                HStack {
                                    Image(systemName: villagersVM.favoriteVillagers
                                        .contains(where: { $0.id == villager.id }) ? "star.fill" : "star")
                                    .foregroundColor(Color("ACNHText"))
                                    .onTapGesture {
                                        villagersVM.toggleFavorite(villager: villager)
                                    }
                                    IconView(url: "\(villagerIconBaseUrl)\(villager.id).png", frameWidth: 50, frameHeight: 50)
                                    Text(villager.name)
                                        .foregroundColor(Color("ACNHText"))
                                }
                            }
                            .listRowBackground(
                                Capsule()
                                    .foregroundColor(Color("ACNHCardBackground"))
                                    .padding(5)
                            )
                            .listRowSeparator(.hidden)
                        }
                    }
                    .task {
                        await villagersVM.fetchData()
                    }
                    .alert(isPresented: $villagersVM.hasError, error: villagersVM.error) {
                        Text("Error.")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("ACNHBackground"))
                    .listStyle(.plain)
                    .blendMode(villagersVM.searchResults.isEmpty ? .destinationOver : .normal)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .navigationTitle("Villagers")
                    .searchable(text: $villagersVM.searchText, placement: .navigationBarDrawer(displayMode: .always))
                }
            }
            .background(Color("ACNHBackground"))
            .padding(5)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Villagers").font(.title)
                            .foregroundColor(Color("ACNHText"))
                    }
                }
            }
            .navigationBarItems(trailing: Button(action: {
                villagersVM.isFavoritesOnly.toggle()
            }) {
                Text("Favorites")
                Image(systemName: villagersVM.isFavoritesOnly ? "star.fill" : "star")
                    .foregroundColor(Color("ACNHText"))
            })
        }
        .preferredColorScheme(.dark)
    }
}

struct VillagersListView_Previews: PreviewProvider {
    static var previews: some View {
        VillagersListView()
    }
}
