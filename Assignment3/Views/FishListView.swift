//
//  FishListView.swift
//  Assignment3
//
//  Created by Dan Kolan on 3/20/23.
//

import SwiftUI

struct FishListView: View {
    @ObservedObject var fishVM = FishViewModel()
    let fishIconBashUrl = "https://acnhcdn.com/latest/MenuIcon/Fish"
    
    var body: some View {
        VStack {
            Toggle("Currently Available", isOn: $fishVM.currentlyAvailableToggle)
                .padding([.leading, .trailing], 20)
            List {
                ForEach(fishVM.searchResults) { fish in
                    NavigationLink {
                        FishDetail(fish: fish)
                    } label: {
                        HStack {
                            IconView(url: "\(fishIconBashUrl)\(fish.id).png", frameWidth: 50, frameHeight: 50)
                            Text(fish.name.capitalized)
                        }
                    }
                }
            }
            .task {
                await fishVM.fetchData()
            }
            .listStyle(.grouped)
            .navigationTitle("Fish")
            .alert(isPresented: $fishVM.hasError, error: fishVM.error) {
                Text("Error.")
            }
            .searchable(text: $fishVM.searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
    }
}

struct FishListView_Previews: PreviewProvider {
    static var previews: some View {
        FishListView()
    }
}
