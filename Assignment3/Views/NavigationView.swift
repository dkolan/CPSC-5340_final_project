//
//  NavigationView.swift
//  Assignment3
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
                                scrimTransparency: 0.15
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
                                scrimTransparency: 0.15
                            )
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Text("Animal Crossing Reference").font(.title)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .tint(.white)
        }
    }
}

struct CategoryNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView()
    }
}
