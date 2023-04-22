//
//  NavigationCardView.swift
//  Assignment3
//
//  Created by Dan Kolan on 4/19/23.
//

import SwiftUI
import Kingfisher

struct NavigationCardView: View {
    var name: String
    var type: String
    var imgUrl: String
    var cardColor: Color
    var scrimTransparency: Double

    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                Spacer()
                Circle()
                    .fill(Color.white)
                    .frame(width: 80, height: 80)
                    .overlay(
                        KFImage(URL(string: imgUrl))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                    )
                Spacer()
            }
            Spacer()
            Text(name)
                .font(.title2)
                .foregroundColor(Color("ACNHText"))
            if !type.isEmpty {
                Text(type)
                    .font(.body)
                    .foregroundColor(Color("ACNHText"))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(cardColor.overlay(.black.opacity(scrimTransparency)))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(radius: 8)
        .padding(10)
    }
}

struct NavigationCardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationCardView(
            name: "Bugs",
            type: "Catchable",
            imgUrl: "https://dodo.ac/np/images/8/81/Great_Purple_Emperor_NH_Icon.png",
            cardColor: Color("ACNHCardBackground"),
            scrimTransparency: 0.15
        )
    }
}
