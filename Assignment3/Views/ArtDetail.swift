//
//  ArtDetail.swift
//  Assignment3
//
//  Created by Dan Kolan on 4/21/23.
//

import SwiftUI

struct ArtDetail: View {
    @StateObject var artVM = ArtViewModel()

    var art : ArtModel

    var body: some View {
        ZStack {
            Color("ACNHBackground").ignoresSafeArea()
            VStack {
                TabView {
                    ImageCardView(url: art.real_info.image_url, frameWidth: 200, frameHeight: 200)
                    if let fakeInfo = art.fake_info {
                        ImageCardView(url: fakeInfo.image_url, frameWidth: 200, frameHeight: 200)
                    }
                    ImageCardView(url: art.real_info.texture_url, frameWidth: 200, frameHeight: 200)
                    if let fakeInfo = art.fake_info {
                        ImageCardView(url: fakeInfo.texture_url, frameWidth: 200, frameHeight: 200)
                    }
                }
                .tabViewStyle(.page)
                .frame(height: 250)
                ScrollView {
                    DetailView(icon: "info.bubble", header: "Real Name:", value: art.art_name, textColor: Color("ACNHText"))
                    DetailView(icon: "person", header: "Artist:", value: art.author, textColor: Color("ACNHText"))
                    DetailView(icon: "calendar", header: "Year:", value: art.year, textColor: Color("ACNHText"))
                    DetailView(icon: "paintbrush.pointed", header: "Style:", value: art.art_style, textColor: Color("ACNHText"))
                    HStack {
                        DetailView(icon: "dollarsign.circle", header: "Buy:", value: String(art.buy), textColor: Color("ACNHText"))
                        DetailView(icon: "dollarsign.circle", header: "Sell:", value: String(art.sell), textColor: Color("ACNHText"))
                    }
                    DetailView(icon: "location", header: "Location:", value: art.availability, textColor: Color("ACNHText"))
                    DetailView(icon: "questionmark.app", header: "Real Description:", value: art.real_info.description, textColor: Color("ACNHText"))
                    if let fakeInfo = art.fake_info {
                        DetailView(icon: "questionmark.app", header: "Fake Description:", value: fakeInfo.description, textColor: Color("ACNHText"))
                    }
//                    DetailView(icon: "theatermask.and.paintbrush", header: "Type:", value: art.art_type, textColor: Color("ACNHText"))
                    Spacer()
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(art.name.capitalized)
                        .font(.largeTitle.bold())
                        .foregroundColor(Color("ACNHText"))
                        .accessibilityAddTraits(.isHeader)
                }
            }
        }
    }
}

//struct ArtDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        ArtDetail()
//    }
//}
