//
//  ClothingNavigationView.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/20/23.
//

import SwiftUI

struct ClothingNavigationView: View {
    @State var gridLayout: [GridItem] = [GridItem(.adaptive(minimum: 180))]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: gridLayout,
                          alignment: .leading) {
                    NavigationLink {
                        BottomListView()
                    } label: {
                        NavigationCardView(
                            name: "Bottoms",
                            type: "",
                            imgUrl: "https://dodo.ac/np/images/b/b6/Acid-Washed_Jeans_%28Blue%29_NH_Icon.png",
                            cardColor: Color("ACNHCardBackground"),
                            scrimTransparency: 0.0
                        )
                    }
                    NavigationLink {
                        TopListView()
                    } label: {
                        NavigationCardView(
                            name: "Tops",
                            type: "",
                            imgUrl: "https://dodo.ac/np/images/8/84/Acid-Washed_Jacket_%28Blue%29_NH_Icon.png",
                            cardColor: Color("ACNHCardBackground"),
                            scrimTransparency: 0.0
                        )
                    }
                    NavigationLink {
                        ShoeListView()
                    } label: {
                        NavigationCardView(
                            name: "Shoes",
                            type: "",
                            imgUrl: "https://dodo.ac/np/images/7/70/Visual-Punk_Boots_NH_Icon.png",
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
                        Text("Clothing").font(.title)
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
struct ClothingNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        ClothingNavigationView()
    }
}
