//
//  TopListView.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/22/23.
//

import SwiftUI

struct TopListView: View {
    @StateObject var topVM = TopViewModel()
    @EnvironmentObject var locationDataManager: LocationDataManager

    var body: some View {
        ZStack {
            Color("ACNHBackground").ignoresSafeArea()
            VStack {
                List {
                    ForEach(topVM.searchResults) { top in
//                        var p1 = print(topVM.searchResults[0].variations[0].imageUrl)
                        NavigationLink {
                            TopDetail(top: top)
                        } label: {
                            HStack {
                                Image(systemName: topVM.favoriteTop
                                    .contains(where: { $0.id == top.id }) ? "star.fill" : "star")
                                .onTapGesture {
                                    topVM.toggleFavorite(top: top)
                                }
                                IconView(url: top.variations[0].imageUrl, frameWidth: 50, frameHeight: 50)
                                Text(top.name.capitalized)
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
                    await topVM.fetchData()
                }
                .alert(isPresented: $topVM.hasError, error: topVM.error) {
                    Text("Error.")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .listStyle(.plain)
                .blendMode(topVM.searchResults.isEmpty ? .destinationOver : .normal)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .navigationTitle("Tops")
                .foregroundColor(Color("ACNHText"))
                .searchable(text: $topVM.searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
            .background(Color("ACNHBackground"))
            .padding(5)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Tops").font(.title)
                            .foregroundColor(Color("ACNHText"))
                    }
                }
            }
            .navigationBarItems(trailing: Button(action: {
                topVM.isFavoritesOnly.toggle()
            }) {
                Text("Favorites")
                Image(systemName: topVM.isFavoritesOnly ? "star.fill" : "star")
                    .foregroundColor(Color("ACNHText"))
            })
        }
    }
}

//struct TopListView_Previews: PreviewProvider {
//    static var previews: some View {
//        TopListView()
//    }
//}
