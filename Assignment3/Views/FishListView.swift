//
//  FishListView.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 3/20/23.
//

import SwiftUI

struct FishListView: View {
    @StateObject var fishVM = FishViewModel()
    @EnvironmentObject var locationDataManager: LocationDataManager
    
    let fishIconBaseUrl = "https://acnhcdn.com/latest/MenuIcon/Fish"
    
    var body: some View {
        ZStack {
            Color("ACNHBackground").ignoresSafeArea()
            VStack {
                Toggle("Currently Available", isOn: $fishVM.currentlyAvailableToggle)
                    .foregroundColor(Color("ACNHText"))
                    .padding([.leading, .trailing], 20)
                List {
                    ForEach(fishVM.searchResults) { fish in
                        NavigationLink {
                            FishDetail(fish: fish)
                        } label: {
                            HStack {
                                Image(systemName: fishVM.favoriteFish
                                    .contains(where: { $0.id == fish.id }) ? "star.fill" : "star")
                                .foregroundColor(Color("ACNHText"))
                                .onTapGesture {
                                    fishVM.toggleFavorite(fish: fish)
                                }
                                IconView(url: fish.image_url, frameWidth: 50, frameHeight: 50)
                                Text(fish.name.capitalized)
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
                    await fishVM.fetchData()
                }
                .alert(isPresented: $fishVM.hasError, error: fishVM.error) {
                    Text("Error.")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("ACNHBackground"))
                .listStyle(.plain)
                .blendMode(fishVM.searchResults.isEmpty ? .destinationOver : .normal)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .navigationTitle("Fish")
                .searchable(text: $fishVM.searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
            .onAppear {
                fishVM.hemisphere = locationDataManager.hemisphere ?? "north" // default assumption user is north hemisphere
            }
            .background(Color("ACNHBackground"))
            .padding(5)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Fish").font(.title)
                            .foregroundColor(Color("ACNHText"))
                    }
                }
            }
            .navigationBarItems(trailing: Button(action: {
                fishVM.isFavoritesOnly.toggle()
            }) {
                Text("Favorites")
                Image(systemName: fishVM.isFavoritesOnly ? "star.fill" : "star")
                    .foregroundColor(Color("ACNHText"))
            })
        }
    }
}

struct FishListView_Previews: PreviewProvider {
    static var previews: some View {
        FishListView()
    }
}
