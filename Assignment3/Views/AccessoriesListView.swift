//
//  AccessoriesListView.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/23/23.
//

import SwiftUI

struct AccessoriesListView: View {
    @StateObject var accessoriesVM = AccessoriesViewModel()
    @EnvironmentObject var locationDataManager: LocationDataManager

    var body: some View {
        ZStack {
            Color("ACNHBackground").ignoresSafeArea()
            VStack {
                List {
                    ForEach(accessoriesVM.searchResults) { accessories in
                        NavigationLink {
                            AccessoriesDetail(accessories: accessories)
                        } label: {
                            HStack {
                                Image(systemName: accessoriesVM.favoriteAccessories
                                    .contains(where: { $0.id == accessories.id }) ? "star.fill" : "star")
                                .onTapGesture {
                                    accessoriesVM.toggleFavorite(accessories: accessories)
                                }
                                IconView(url: accessories.variations[0].imageUrl, frameWidth: 50, frameHeight: 50)
                                Text(accessories.name.capitalized)
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
                    await accessoriesVM.fetchData()
                }
                .alert(isPresented: $accessoriesVM.hasError, error: accessoriesVM.error) {
                    Text("Error.")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .listStyle(.plain)
                .blendMode(accessoriesVM.searchResults.isEmpty ? .destinationOver : .normal)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .navigationTitle("Accessoriess")
                .foregroundColor(Color("ACNHText"))
                .searchable(text: $accessoriesVM.searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
            .background(Color("ACNHBackground"))
            .padding(5)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Accessoriess").font(.title)
                            .foregroundColor(Color("ACNHText"))
                    }
                }
            }
            .navigationBarItems(trailing: Button(action: {
                accessoriesVM.isFavoritesOnly.toggle()
            }) {
                Text("Favorites")
                Image(systemName: accessoriesVM.isFavoritesOnly ? "star.fill" : "star")
                    .foregroundColor(Color("ACNHText"))
            })
        }
    }
}

//struct AccessoriesListView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccessoriesListView()
//    }
//}

