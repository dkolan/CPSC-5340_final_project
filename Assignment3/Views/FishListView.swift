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
        ZStack {
            Color("ACNHBackground").ignoresSafeArea()
            VStack {
                Toggle("Currently Available", isOn: $fishVM.currentlyAvailableToggle)
                    .padding([.leading, .trailing], 20)
                List {
                    ForEach(fishVM.searchResults) { fish in
                        NavigationLink {
                            FishDetail(fish: fish)
                        } label: {
                            HStack {
                                Image(systemName: fishVM.favoriteFish
                                    .contains(where: { $0.id == fish.id }) ? "star.fill" : "star")
                                .foregroundColor(.white)
                                .onTapGesture {
                                    fishVM.toggleFavorite(fish: fish)
                                }
                                IconView(url: fish.image_url, frameWidth: 50, frameHeight: 50)
                                Text(fish.name.capitalized)
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
                    }
                }
                .task {
                    await fishVM.fetchData()
                }
                .alert(isPresented: $fishVM.hasError, error: fishVM.error) {
                    Text("Error.")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("ACNHBackground"))
                .listStyle(.plain)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .navigationTitle("Fish")
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
                    .foregroundColor(.white)
            })
        }
    }
}

struct FishListView_Previews: PreviewProvider {
    static var previews: some View {
        FishListView()
    }
}
