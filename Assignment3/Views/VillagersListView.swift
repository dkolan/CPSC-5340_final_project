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
        List {
            ForEach(villagersVM.villagersData) { villager in
                NavigationLink {
                    VillagerDetail(villager: villager)
                } label: {
                    Text(villager.name.nameUsEn)
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
    }
}

struct VillagersListView_Previews: PreviewProvider {
    static var previews: some View {
        VillagersListView()
    }
}
