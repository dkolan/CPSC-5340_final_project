//
//  FishListView.swift
//  Assignment3
//
//  Created by Dan Kolan on 3/20/23.
//

import SwiftUI

struct FishListView: View {
    @ObservedObject var fishVM = FishViewModel()
    @EnvironmentObject var locationDataManager: LocationDataManager
    
    let fishIconBaseUrl = "https://acnhcdn.com/latest/MenuIcon/Fish"
    
    var body: some View {
        VStack {
            Toggle("Currently Available", isOn: $fishVM.currentlyAvailableToggle)
                .padding([.leading, .trailing], 20)
            List {
                ForEach(fishVM.searchResults) { fish in
                    NavigationLink {
                        FishDetail(fish: fish)
                    } label: {
//                        HStack {
//                            IconView(url: fish.image_url, frameWidth: 50, frameHeight: 50)
//                            Text(fish.name.capitalized)
//                        }
                        HStack {
                            Image(systemName: fishVM.favoriteFish
                                .contains(where: { $0.id == fish.id }) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .onTapGesture {
                                    fishVM.toggleFavorite(fish: fish)
                                }
                            IconView(url: fish.image_url, frameWidth: 50, frameHeight: 50)
                            Text(fish.name.capitalized)
                        }
                    }
                }
            }
            .task {
                await fishVM.fetchData()
            }
            .listStyle(.grouped)
            .navigationTitle("Fish")
            .alert(isPresented: $fishVM.hasError, error: fishVM.error) {
                Text("Error.")
            }
            .searchable(text: $fishVM.searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
        .onAppear {
            fishVM.hemisphere = locationDataManager.hemisphere ?? "north" // default assumption user is north hemisphere
        }
        .padding(5)
        .navigationBarItems(trailing: Button(action: {
            fishVM.isFavoritesOnly.toggle()
        }) {
            Text("Favorites")
            Image(systemName: fishVM.isFavoritesOnly ? "star.fill" : "star")
                .foregroundColor(.yellow)
        })
    }
}

struct FishListView_Previews: PreviewProvider {
    static var previews: some View {
        FishListView()
    }
}
