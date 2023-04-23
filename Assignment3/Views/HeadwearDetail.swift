//
//  HeadwearDetail.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/23/23.
//

import SwiftUI

struct HeadwearDetail: View {
    @EnvironmentObject var locationDataManager: LocationDataManager
    @State var imageCardZoomed: Bool = false

    var headwear : HeadwearModel

    var body: some View {
        ZStack {
            Color("ACNHBackground").ignoresSafeArea()
            GeometryReader { geometry in
                VStack {
                    TabView {
                        ForEach(headwear.variations) { variation in
                            ImageCardView(url: variation.imageUrl, frameWidth: imageCardZoomed ? geometry.size.width : geometry.size.width / 4, frameHeight: imageCardZoomed ? geometry.size.height : geometry.size.height / 4)
                        }
                    }
                    .tabViewStyle(.page)
                    .frame(width: imageCardZoomed ? geometry.size.width : geometry.size.width / 4,
                           height: imageCardZoomed ? geometry.size.height : geometry.size.height / 4)
                    .onTapGesture {
                        withAnimation {
                            imageCardZoomed.toggle()
                        }
                    }
                    Spacer()
                        .padding()
                    ScrollView {
                        DetailView(icon: "cloud.sun", header: "Season:", value: headwear.seasonality, textColor: Color("ACNHText"))
                        DetailView(icon: "tshirt", header: "Themes:", value: headwear.labelThemes.joined(separator: ", "), textColor: Color("ACNHText"))
                        DetailView(icon: "tshirt", header: "Style:", value: headwear.styles.joined(separator: ", "), textColor: Color("ACNHText"))
                        
                        ForEach(Array(zip(headwear.availability.indices, headwear.availability)), id: \.0) { index, item in
                            
                            DetailView(icon: "cart.badge.plus", header: "Available:", value:
                                        item.note.isEmpty ? "\(item.from)" : "\(item.from) in \(item.note)", textColor: Color("ACNHText"))
                        }
                        HStack {
                            ForEach(Array(zip(headwear.buy.indices, headwear.buy)), id: \.0) { index, item in
                                DetailView(icon: "dollarsign.circle", header: "Price:", value: "\(item.price) \(item.currency)", textColor: Color("ACNHText"))
                            }
                        }
                        Spacer()
                            .frame(height: geometry.size.height * 0.15)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.75)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text(headwear.name.capitalized)
                                .font(.title)
                                .foregroundColor(Color("ACNHText"))
                                .accessibilityAddTraits(.isHeader)
                        }
                    }
                }
            }
        }
     }
}

//struct HeadwearDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        HeadwearDetail()
//    }
//}
