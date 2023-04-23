//
//  ArtListView.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/21/23.
//

import SwiftUI

struct ArtListView: View {
    @StateObject var artVM = ArtViewModel()

    let artIconBaseUrl = "https://acnhcdn.com/latest/MenuIcon/Art"

    var body: some View {
        ZStack {
            Color("ACNHBackground").ignoresSafeArea()
            VStack {
                Toggle("Has Fake", isOn: $artVM.hasFakeToggle)
                    .foregroundColor(Color("ACNHText"))
                    .padding([.leading, .trailing], 20)
                List {
                    ForEach(artVM.searchResults) { art in
                        NavigationLink {
                            ArtDetail(art: art)
                        } label: {
                            HStack {
                                Image(systemName: artVM.favoriteArt
                                    .contains(where: { $0.name == art.name }) ? "star.fill" : "star")
                                .foregroundColor(Color("ACNHText"))
                                .onTapGesture {
                                    artVM.toggleFavorite(art: art)
                                }
                                IconView(url: art.real_info.image_url, frameWidth: 50, frameHeight: 50)
                                Text(art.name)
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
                    await artVM.fetchData()
                }
                .alert(isPresented: $artVM.hasError, error: artVM.error) {
                    Text("Error.")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("ACNHBackground"))
                .listStyle(.plain)
                .blendMode(artVM.searchResults.isEmpty ? .destinationOver : .normal)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .navigationTitle("Art")
                .searchable(text: $artVM.searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
            .background(Color("ACNHBackground"))
            .padding(5)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Art").font(.title)
                            .foregroundColor(Color("ACNHText"))
                    }
                }
            }
            .navigationBarItems(trailing: Button(action: {
                artVM.isFavoritesOnly.toggle()
            }) {
                Text("Favorites")
                Image(systemName: artVM.isFavoritesOnly ? "star.fill" : "star")
                    .foregroundColor(Color("ACNHText"))
            })
        }
    }
}


struct ArtListView_Previews: PreviewProvider {
    static var previews: some View {
        ArtListView()
    }
}
