//
//  BottomListView.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/23/23.
//

import SwiftUI

struct BottomListView: View {
    @StateObject var bottomVM = BottomViewModel()
    @EnvironmentObject var locationDataManager: LocationDataManager

    var body: some View {
        ZStack {
            Color("ACNHBackground").ignoresSafeArea()
            VStack {
                List {
                    ForEach(bottomVM.searchResults) { bottom in
                        NavigationLink {
                            BottomDetail(bottom: bottom)
                        } label: {
                            HStack {
                                Image(systemName: bottomVM.favoriteBottom
                                    .contains(where: { $0.id == bottom.id }) ? "star.fill" : "star")
                                .onTapGesture {
                                    bottomVM.toggleFavorite(bottom: bottom)
                                }
                                IconView(url: bottom.variations[0].imageUrl, frameWidth: 50, frameHeight: 50)
                                Text(bottom.name.capitalized)
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
                    await bottomVM.fetchData()
                }
                .alert(isPresented: $bottomVM.hasError, error: bottomVM.error) {
                    Text("Error.")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .listStyle(.plain)
                .blendMode(bottomVM.searchResults.isEmpty ? .destinationOver : .normal)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .navigationTitle("Bottoms")
                .foregroundColor(Color("ACNHText"))
                .searchable(text: $bottomVM.searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
            .background(Color("ACNHBackground"))
            .padding(5)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Bottoms").font(.title)
                            .foregroundColor(Color("ACNHText"))
                    }
                }
            }
            .navigationBarItems(trailing: Button(action: {
                bottomVM.isFavoritesOnly.toggle()
            }) {
                Text("Favorites")
                Image(systemName: bottomVM.isFavoritesOnly ? "star.fill" : "star")
                    .foregroundColor(Color("ACNHText"))
            })
        }
    }
}

//struct BottomListView_Previews: PreviewProvider {
//    static var previews: some View {
//        BottomListView()
//    }
//}
