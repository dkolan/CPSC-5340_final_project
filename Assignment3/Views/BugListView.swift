//
//  BugListView.swift
//  Assignment3
//
//  Created by Dan Kolan on 4/19/23.
//

import SwiftUI

struct BugListView: View {
    @StateObject var bugVM = BugViewModel()
    @EnvironmentObject var locationDataManager: LocationDataManager

    let BugIconBaseUrl = "https://acnhcdn.com/latest/MenuIcon/Bug"

    var body: some View {
        ZStack {
            Color("ACNHBackground").ignoresSafeArea()
            VStack {
                Toggle("Currently Available", isOn: $bugVM.currentlyAvailableToggle)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .shadow(radius: 1.0)
                    .padding([.leading, .trailing], 20)
                List {
                    ForEach(bugVM.searchResults) { bug in
                        NavigationLink {
                            BugDetail(Bug: bug)
                        } label: {
                            HStack {
                                Image(systemName: bugVM.favoriteBug
                                    .contains(where: { $0.id == bug.id }) ? "star.fill" : "star")
                                .foregroundColor(.white)
                                .onTapGesture {
                                    bugVM.toggleFavorite(Bug: bug)
                                }
                                IconView(url: bug.image_url, frameWidth: 50, frameHeight: 50)
                                Text(bug.name.capitalized)
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
                        .listRowSeparator(.hidden)
                    }
                }
                .task {
                    await bugVM.fetchData()
                }
                .alert(isPresented: $bugVM.hasError, error: bugVM.error) {
                    Text("Error.")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .listStyle(.plain)
                .blendMode(bugVM.searchResults.isEmpty ? .destinationOver : .normal)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .navigationTitle("Bugs")
                .searchable(text: $bugVM.searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
            .onAppear {
                bugVM.hemisphere = locationDataManager.hemisphere ?? "north" // default assumption user is north hemisphere
            }
            .background(Color("ACNHBackground"))
            .padding(5)
            .navigationBarItems(trailing: Button(action: {
                bugVM.isFavoritesOnly.toggle()
            }) {
                Text("Favorites")
                Image(systemName: bugVM.isFavoritesOnly ? "star.fill" : "star")
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
