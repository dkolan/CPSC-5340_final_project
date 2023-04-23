//
//  ShoeListView.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/23/23.
//

import SwiftUI

struct ShoeListView: View {
    @StateObject var shoeVM = ShoeViewModel()
    @EnvironmentObject var locationDataManager: LocationDataManager

    var body: some View {
        ZStack {
            Color("ACNHBackground").ignoresSafeArea()
            VStack {
                List {
                    ForEach(shoeVM.searchResults) { shoe in
                        NavigationLink {
                            ShoeDetail(shoe: shoe)
                        } label: {
                            HStack {
                                Image(systemName: shoeVM.favoriteShoe
                                    .contains(where: { $0.id == shoe.id }) ? "star.fill" : "star")
                                .onTapGesture {
                                    shoeVM.toggleFavorite(shoe: shoe)
                                }
                                IconView(url: shoe.variations[0].imageUrl, frameWidth: 50, frameHeight: 50)
                                Text(shoe.name.capitalized)
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
                    await shoeVM.fetchData()
                }
                .alert(isPresented: $shoeVM.hasError, error: shoeVM.error) {
                    Text("Error.")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .listStyle(.plain)
                .blendMode(shoeVM.searchResults.isEmpty ? .destinationOver : .normal)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .navigationTitle("Shoes")
                .foregroundColor(Color("ACNHText"))
                .searchable(text: $shoeVM.searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
            .background(Color("ACNHBackground"))
            .padding(5)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Shoes").font(.title)
                            .foregroundColor(Color("ACNHText"))
                    }
                }
            }
            .navigationBarItems(trailing: Button(action: {
                shoeVM.isFavoritesOnly.toggle()
            }) {
                Text("Favorites")
                Image(systemName: shoeVM.isFavoritesOnly ? "star.fill" : "star")
                    .foregroundColor(Color("ACNHText"))
            })
        }
    }
}

//struct ShoeListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShoeListView()
//    }
//}

