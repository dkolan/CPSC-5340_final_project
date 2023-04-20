//
//  BugListView.swift
//  Assignment3
//
//  Created by Dan Kolan on 4/19/23.
//

import SwiftUI

struct ScrimView {
    var render: some ShapeStyle {
        Color.black
    }
}

struct BugListView: View {
    @ObservedObject var BugVM = BugViewModel()
    @EnvironmentObject var locationDataManager: LocationDataManager

    let BugIconBaseUrl = "https://acnhcdn.com/latest/MenuIcon/Bug"

    var body: some View {
        ZStack {
            Color("ACNHBackground").ignoresSafeArea()
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
                                .foregroundColor(.white)
                                .onTapGesture {
                                    BugVM.toggleFavorite(Bug: Bug)
                                }
                                IconView(url: Bug.image_url, frameWidth: 50, frameHeight: 50)
                                Text(Bug.name.capitalized)
                                    .foregroundColor(.white)
                            }
                        }
                        .listRowBackground(
                            Capsule()
                                .foregroundColor(Color("ACNHCardBackground"))
                                .overlay(
                                    Capsule()
                                        .foregroundColor(Color.black.opacity(0.2))
                                )
                                .padding(5)
                        )
                    }
                }
                .task {
                    await BugVM.fetchData()
                }
                .alert(isPresented: $BugVM.hasError, error: BugVM.error) {
                    Text("Error.")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("ACNHBackground"))
                .listStyle(.plain)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .navigationTitle("Bugs")
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
                    .foregroundColor(.white)
            })
        }
    }
}

struct BugListView_Previews: PreviewProvider {
    static var previews: some View {
        BugListView()
    }
}
