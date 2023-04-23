//
//  HeadwearListView.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/23/23.
//

import SwiftUI

struct HeadwearListView: View {
    @StateObject var headwearVM = HeadwearViewModel()
    @EnvironmentObject var locationDataManager: LocationDataManager

    var body: some View {
        ZStack {
            Color("ACNHBackground").ignoresSafeArea()
            VStack {
                List {
                    ForEach(headwearVM.searchResults) { headwear in
                        NavigationLink {
                            HeadwearDetail(headwear: headwear)
                        } label: {
                            HStack {
                                Image(systemName: headwearVM.favoriteHeadwear
                                    .contains(where: { $0.id == headwear.id }) ? "star.fill" : "star")
                                .onTapGesture {
                                    headwearVM.toggleFavorite(headwear: headwear)
                                }
                                IconView(url: headwear.variations[0].imageUrl, frameWidth: 50, frameHeight: 50)
                                Text(headwear.name.capitalized)
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
                    await headwearVM.fetchData()
                }
                .alert(isPresented: $headwearVM.hasError, error: headwearVM.error) {
                    Text("Error.")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .listStyle(.plain)
                .blendMode(headwearVM.searchResults.isEmpty ? .destinationOver : .normal)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .navigationTitle("Headwears")
                .foregroundColor(Color("ACNHText"))
                .searchable(text: $headwearVM.searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
            .background(Color("ACNHBackground"))
            .padding(5)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Headwears").font(.title)
                            .foregroundColor(Color("ACNHText"))
                    }
                }
            }
            .navigationBarItems(trailing: Button(action: {
                headwearVM.isFavoritesOnly.toggle()
            }) {
                Text("Favorites")
                Image(systemName: headwearVM.isFavoritesOnly ? "star.fill" : "star")
                    .foregroundColor(Color("ACNHText"))
            })
        }
    }
}

//struct HeadwearListView_Previews: PreviewProvider {
//    static var previews: some View {
//        HeadwearListView()
//    }
//}
