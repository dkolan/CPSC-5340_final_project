//
//  SeaCreatureListView.swift
//  Assignment3
//
//  Created by Dan Kolan on 4/19/23.
//

import SwiftUI

struct SeaCreatureListView: View {
    @ObservedObject var SeaCreatureVM = SeaCreatureViewModel()
    @EnvironmentObject var locationDataManager: LocationDataManager

    let SeaCreatureIconBaseUrl = "https://acnhcdn.com/latest/MenuIcon/SeaCreature"

    var body: some View {
        VStack {
            Toggle("Currently Available", isOn: $SeaCreatureVM.currentlyAvailableToggle)
                .padding([.leading, .trailing], 20)
            List {
                ForEach(SeaCreatureVM.searchResults) { SeaCreature in
                    NavigationLink {
                        SeaCreatureDetail(SeaCreature: SeaCreature)
                    } label: {
                        HStack {
                            Image(systemName: SeaCreatureVM.favoriteSeaCreature
                                .contains(where: { $0.id == SeaCreature.id }) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .onTapGesture {
                                    SeaCreatureVM.toggleFavorite(SeaCreature: SeaCreature)
                                }
                            IconView(url: SeaCreature.image_url, frameWidth: 50, frameHeight: 50)
                            Text(SeaCreature.name.capitalized)
                        }
                    }
                }
            }
            .task {
                await SeaCreatureVM.fetchData()
            }
            .listStyle(.grouped)
            .navigationTitle("SeaCreatures")
            .alert(isPresented: $SeaCreatureVM.hasError, error: SeaCreatureVM.error) {
                Text("Error.")
            }
            .searchable(text: $SeaCreatureVM.searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
        .onAppear {
            SeaCreatureVM.hemisphere = locationDataManager.hemisphere ?? "north" // default assumption user is north hemisphere
        }
        .padding(5)
        .navigationBarItems(trailing: Button(action: {
            SeaCreatureVM.isFavoritesOnly.toggle()
        }) {
            Text("Favorites")
            Image(systemName: SeaCreatureVM.isFavoritesOnly ? "star.fill" : "star")
                .foregroundColor(.yellow)
        })
    }
}

struct SeaCreatureListView_Previews: PreviewProvider {
    static var previews: some View {
        SeaCreatureListView()
    }
}
