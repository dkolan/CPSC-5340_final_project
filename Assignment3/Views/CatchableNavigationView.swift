//
//  CatchableNavigationView.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/20/23.
//

import SwiftUI

struct CatchableNavigationView: View {
    @State var gridLayout: [GridItem] = [GridItem(.adaptive(minimum: 180))]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: gridLayout,
                          alignment: .leading) {
                    NavigationLink {
                        BugListView()
                    } label: {
                        NavigationCardView(
                            name: "Bugs",
                            type: "",
                            imgUrl: "https://dodo.ac/np/images/8/81/Great_Purple_Emperor_NH_Icon.png",
                            cardColor: Color("ACNHCardBackground"),
                            scrimTransparency: 0.0
                        )
                    }
                    NavigationLink {
                        FishListView()
                    } label: {
                        NavigationCardView(
                            name: "Fish",
                            type: "",
                            imgUrl: "https://dodo.ac/np/images/b/b3/Olive_Flounder_NH_Icon.png",
                            cardColor: Color("ACNHCardBackground"),
                            scrimTransparency: 0.0
                        )
                    }
                    NavigationLink {
                        SeaCreatureListView()
                    } label: {
                        NavigationCardView(
                            name: "Sea Creatures",
                            type: "",
                            imgUrl: "https://dodo.ac/np/images/c/ca/Gigas_Giant_Clam_NH_Icon.png",
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
                        Text("Catchables").font(.title)
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
struct CatchableNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        CatchableNavigationView()
    }
}
