//
//  FossilListView.swift
//  Assignment3
//
//  Created by Dan Kolan on 4/22/23.
//

import SwiftUI

struct FossilListView: View {
    @StateObject var fossilVM = FossilViewModel()
    @EnvironmentObject var locationDataManager: LocationDataManager

    let FossilIconBaseUrl = "https://acnhcdn.com/latest/MenuIcon/Fossil"

    var body: some View {
        ZStack {
            Color("ACNHBackground").ignoresSafeArea()
            VStack {
                List {
                    ForEach(fossilVM.searchResults) { fossil in
                        NavigationLink {
                            FossilDetail(fossil: fossil)
                        } label: {
                            HStack {
                                Image(systemName: fossilVM.favoriteFossil
                                    .contains(where: { $0.id == fossil.id }) ? "star.fill" : "star")
                                .foregroundColor(Color("ACNHText"))
                                .onTapGesture {
                                    fossilVM.toggleFavorite(fossil: fossil)
                                }
                                IconView(url: fossil.image_url, frameWidth: 50, frameHeight: 50)
                                Text(fossil.name.capitalized)
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
                    await fossilVM.fetchData()
                }
                .alert(isPresented: $fossilVM.hasError, error: fossilVM.error) {
                    Text("Error.")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .listStyle(.plain)
                .blendMode(fossilVM.searchResults.isEmpty ? .destinationOver : .normal)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .navigationTitle("Fossils")
                .foregroundColor(Color("ACNHText"))
                .searchable(text: $fossilVM.searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
            .background(Color("ACNHBackground"))
            .padding(5)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Fossils").font(.title)
                            .foregroundColor(Color("ACNHText"))
                    }
                }
            }
            .navigationBarItems(trailing: Button(action: {
                fossilVM.isFavoritesOnly.toggle()
            }) {
                Text("Favorites")
                Image(systemName: fossilVM.isFavoritesOnly ? "star.fill" : "star")
                    .foregroundColor(Color("ACNHText"))
            })
        }
    }
}

struct FossilListView_Previews: PreviewProvider {
    static var previews: some View {
        FossilListView()
    }
}
