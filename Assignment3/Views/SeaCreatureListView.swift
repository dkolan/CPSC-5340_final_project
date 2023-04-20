//
//  SeaCreatureListView.swift
//  Assignment3
//
//  Created by Dan Kolan on 4/19/23.
//

import SwiftUI

struct SeaCreatureListView: View {
    @StateObject var seaCreatureVM = SeaCreatureViewModel()
    @EnvironmentObject var locationDataManager: LocationDataManager

    let seaCreatureIconBaseUrl = "https://acnhcdn.com/latest/MenuIcon/SeaCreature"

    var body: some View {
        ZStack {
            Color("ACNHBackground").ignoresSafeArea()
            VStack {
                Toggle("Currently Available", isOn: $seaCreatureVM.currentlyAvailableToggle)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .shadow(radius: 1.0)
                    .padding([.leading, .trailing], 20)
                List {
                    ForEach(seaCreatureVM.searchResults) { seaCreature in
                        NavigationLink {
                            SeaCreatureDetail(SeaCreature: seaCreature)
                        } label: {
                            HStack {
                                Image(systemName: seaCreatureVM.favoriteSeaCreature
                                    .contains(where: { $0.id == seaCreature.id }) ? "star.fill" : "star")
                                .foregroundColor(.white)
                                .onTapGesture {
                                    seaCreatureVM.toggleFavorite(SeaCreature: seaCreature)
                                }
                                IconView(url: seaCreature.image_url, frameWidth: 50, frameHeight: 50)
                                Text(seaCreature.name.capitalized)
                                    .foregroundColor(.white)
                            }
                        }
                        .listRowBackground(
                            Capsule()
                                .foregroundColor(Color("ACNHCardBackground"))
                                .overlay(
                                    Capsule()
                                        .foregroundColor(Color.black.opacity(0.2))
                                )
                                .padding(5)
                        )
                        .listRowSeparator(.hidden)
                    }
                }
                .task {
                    await seaCreatureVM.fetchData()
                }
                .alert(isPresented: $seaCreatureVM.hasError, error: seaCreatureVM.error) {
                    Text("Error.")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .listStyle(.plain)
                .blendMode(seaCreatureVM.searchResults.isEmpty ? .destinationOver : .normal)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .navigationTitle("Sea Creatures")
                .searchable(text: $seaCreatureVM.searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
            .onAppear {
                seaCreatureVM.hemisphere = locationDataManager.hemisphere ?? "north" // default assumption user is north hemisphere
            }
            .background(Color("ACNHBackground"))
            .padding(5)
            .navigationBarItems(trailing: Button(action: {
                seaCreatureVM.isFavoritesOnly.toggle()
            }) {
                Text("Favorites")
                Image(systemName: seaCreatureVM.isFavoritesOnly ? "star.fill" : "star")
                    .foregroundColor(.white)
            })
        }
    }
}

struct SeaCreatureListView_Previews: PreviewProvider {
    static var previews: some View {
        SeaCreatureListView()
    }
}
