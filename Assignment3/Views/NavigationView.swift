//
//  NavigationView.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 3/20/23.
//

import SwiftUI
import Kingfisher

struct NavigationView: View {
    @State var gridLayout: [GridItem] = [GridItem(.adaptive(minimum: 180))]

    var body: some View {
        NavigationStack {
            ZStack {
                Color("ACNHBackground").ignoresSafeArea()
                ScrollView {
                    LazyVGrid(columns: gridLayout,
                              alignment: .leading) {
                        NavigationLink {
                            CatchableNavigationView()
                        } label: {
                            NavigationCardView(
                                name: "Catchables",
                                type: "",
                                imgUrl: "https://dodo.ac/np/images/b/b3/Olive_Flounder_NH_Icon.png",
                                cardColor: Color("ACNHCardBackground"),
                                scrimTransparency: 0.0
                            )
                        }
                        NavigationLink {
                            ClothingNavigationView()
                        } label: {
                            NavigationCardView(
                                name: "Clothing",
                                type: "",
                                imgUrl: "https://dodo.ac/np/images/8/84/Acid-Washed_Jacket_%28Blue%29_NH_Icon.png",
                                cardColor: Color("ACNHCardBackground"),
                                scrimTransparency: 0.0
                            )
                        }
                        NavigationLink {
                            CollectableNavigationView()
                        } label: {
                            NavigationCardView(
                                name: "Collectables",
                                type: "",
                                imgUrl: "https://dodo.ac/np/images/f/f7/Serene_Painting_NH_Icon.png",
                                cardColor: Color("ACNHCardBackground"),
                                scrimTransparency: 0.0
                            )
                        }
                        NavigationLink {
                            VillagersListView()
                        } label: {
                            NavigationCardView(
                                name: "Villagers",
                                type: "",
                                imgUrl: "https://acnhcdn.com/latest/NpcIcon/cat18.png",
                                cardColor: Color("ACNHCardBackground"),
                                scrimTransparency: 0.0
                            )
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Text("Animal Crossing Reference").font(.title)
                                .foregroundColor(Color("ACNHText"))
                        }
                    }
                }
            }
            .tint(Color("ACNHText"))
        }
        .preferredColorScheme(.light)
    }
}

struct CategoryNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView()
    }
}
