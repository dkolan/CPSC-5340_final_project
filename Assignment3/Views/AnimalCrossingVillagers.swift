//
// ContentView.swift : Assignment3
//
// Copyright © 2023 Auburn University.
// All Rights Reserved.


import SwiftUI

struct AnimalCrossingVillagers: View {
    
    @ObservedObject var villagersVM = VillagersViewModel()
    
    var body: some View {
        NavigationStack {
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AnimalCrossingVillagers()
    }
}
