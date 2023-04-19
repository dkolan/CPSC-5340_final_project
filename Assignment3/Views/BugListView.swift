//
//  BugListView.swift
//  Assignment3
//
//  Created by Dan Kolan on 4/19/23.
//

import SwiftUI

struct BugListView: View {
    @ObservedObject var BugVM = BugViewModel()
    @EnvironmentObject var locationDataManager: LocationDataManager

    let BugIconBaseUrl = "https://acnhcdn.com/latest/MenuIcon/Bug"

    var body: some View {
        VStack {
            Toggle("Currently Available", isOn: $BugVM.currentlyAvailableToggle)
                .padding([.leading, .trailing], 20)
            List {
                ForEach(BugVM.searchResults) { Bug in
                    NavigationLink {
                        BugDetail(Bug: Bug)
                    } label: {
                        HStack {
                            Image(systemName: BugVM.favoriteBug
                                .contains(where: { $0.id == Bug.id }) ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .onTapGesture {
                                    BugVM.toggleFavorite(Bug: Bug)
                                }
                            IconView(url: Bug.image_url, frameWidth: 50, frameHeight: 50)
                            Text(Bug.name.capitalized)
                        }
                    }
                }
            }
            .task {
                await BugVM.fetchData()
            }
            .listStyle(.grouped)
            .navigationTitle("Bugs")
            .alert(isPresented: $BugVM.hasError, error: BugVM.error) {
                Text("Error.")
            }
            .searchable(text: $BugVM.searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
        .onAppear {
            BugVM.hemisphere = locationDataManager.hemisphere ?? "north" // default assumption user is north hemisphere
        }
        .padding(5)
        .navigationBarItems(trailing: Button(action: {
            BugVM.isFavoritesOnly.toggle()
        }) {
            Text("Favorites")
            Image(systemName: BugVM.isFavoritesOnly ? "star.fill" : "star")
                .foregroundColor(.yellow)
        })
    }
}

struct BugListView_Previews: PreviewProvider {
    static var previews: some View {
        BugListView()
    }
}
