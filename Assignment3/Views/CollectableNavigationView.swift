//
//  CollectableNavigationView.swift
//  Assignment3
//
//  Created by Dan Kolan on 4/21/23.
//

import SwiftUI

struct CollectableNavigationView: View {
    @State var gridLayout: [GridItem] = [GridItem(.adaptive(minimum: 180))]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: gridLayout,
                          alignment: .leading) {
                    NavigationLink {
                        ArtListView()
                    } label: {
                        NavigationCardView(
                            name: "Art",
                            type: "",
                            imgUrl: "https://dodo.ac/np/images/f/f7/Serene_Painting_NH_Icon.png",
                            cardColor: Color("ACNHCardBackground"),
                            scrimTransparency: 0.0
                        )
                    }
                    NavigationLink {
                        FossilListView()
                    } label: {
                        NavigationCardView(
                            name: "Fossils",
                            type: "",
                            imgUrl: "https://dodo.ac/np/images/7/7b/Spino_Skull_NH_Icon.png",
                            cardColor: Color("ACNHCardBackground"),
                            scrimTransparency: 0.0
                        )
                    }
//                    NavigationLink {
//                        SeaCreatureListView()
//                    } label: {
//                        NavigationCardView(
//                            name: "Sea Creatures",
//                            type: "",
//                            imgUrl: "https://dodo.ac/np/images/c/ca/Gigas_Giant_Clam_NH_Icon.png",
//                            cardColor: Color("ACNHCardBackground"),
//                            scrimTransparency: 0.0
//                        )
//                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Collectables")
                            .font(.title)
                            .foregroundColor(Color("ACNHText"))
                    }
                }
            }
            .background(Color("ACNHBackground"))
        }
        .tint(Color("ACNHText"))
        .shadow(radius: 1.0)
    }
}

struct CollectableNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        CollectableNavigationView()
    }
}
