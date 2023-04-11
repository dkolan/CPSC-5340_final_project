//
//  VillagersListView.swift
//  Assignment3
//
//  Created by Dan Kolan on 3/16/23.
//

import SwiftUI

struct VillagersListView: View {
    @ObservedObject var villagersVM = VillagersViewModel()

    var body: some View {
        VStack {
            Picker("Search By", selection: $villagersVM.searchField) {
                ForEach(VillagersViewModel.SearchField.allCases, id: \.self) { field in
                    Text(field.displayName).tag(field)
                }
            }
            .pickerStyle(.segmented)
            List {
                ForEach(villagersVM.searchResults) { villager in
                    NavigationLink {
                        VillagerDetail(villager: villager)
                    } label: {
                        HStack {
//                            ImageCardView(url: villager.icon_uri, frameWidth: 50, frameHeight: 50)
//                            Text(villager.name.nameUsEn)
                            IconView(url: villager.image_url, frameWidth: 50, frameHeight: 50, imageId: villager.id)
                            Text(villager.name)
                        }
                    }
                }
            }
            .task {
                await villagersVM.fetchData()
            }
            .listStyle(.grouped)
            .navigationTitle("Villagers")
            .alert(isPresented: $villagersVM.hasError, error: villagersVM.error) {
                Text("Error.")
            }
            .searchable(text: $villagersVM.searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
    }
}

struct VillagersListView_Previews: PreviewProvider {
    static var previews: some View {
        VillagersListView()
    }
}
