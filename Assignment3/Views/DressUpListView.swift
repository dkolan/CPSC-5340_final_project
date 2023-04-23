//
//  DressUpListView.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/23/23.
//

import SwiftUI

struct DressUpListView: View {
    @StateObject var dressUpVM = DressUpViewModel()
    @EnvironmentObject var locationDataManager: LocationDataManager

    var body: some View {
        ZStack {
            Color("ACNHBackground").ignoresSafeArea()
            VStack {
                List {
                    ForEach(dressUpVM.searchResults) { dressUp in
                        NavigationLink {
                            DressUpDetail(dressUp: dressUp)
                        } label: {
                            HStack {
                                Image(systemName: dressUpVM.favoriteDressUp
                                    .contains(where: { $0.id == dressUp.id }) ? "star.fill" : "star")
                                .onTapGesture {
                                    dressUpVM.toggleFavorite(dressUp: dressUp)
                                }
                                IconView(url: dressUp.variations[0].imageUrl, frameWidth: 50, frameHeight: 50)
                                Text(dressUp.name.capitalized)
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
                    await dressUpVM.fetchData()
                }
                .alert(isPresented: $dressUpVM.hasError, error: dressUpVM.error) {
                    Text("Error.")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .listStyle(.plain)
                .blendMode(dressUpVM.searchResults.isEmpty ? .destinationOver : .normal)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .navigationTitle("DressUps")
                .foregroundColor(Color("ACNHText"))
                .searchable(text: $dressUpVM.searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
            .background(Color("ACNHBackground"))
            .padding(5)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Dress-Ups").font(.title)
                            .foregroundColor(Color("ACNHText"))
                    }
                }
            }
            .navigationBarItems(trailing: Button(action: {
                dressUpVM.isFavoritesOnly.toggle()
            }) {
                Text("Favorites")
                Image(systemName: dressUpVM.isFavoritesOnly ? "star.fill" : "star")
                    .foregroundColor(Color("ACNHText"))
            })
        }
    }
}

//struct DressUpListView_Previews: PreviewProvider {
//    static var previews: some View {
//        DressUpListView()
//    }
//}
