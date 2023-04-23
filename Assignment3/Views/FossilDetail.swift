//
//  FossilDetail.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/22/23.
//

import SwiftUI

struct FossilDetail: View {
    @StateObject var FossilVM = FossilViewModel()
    @EnvironmentObject var locationDataManager: LocationDataManager
    @State var imageCardZoomed: Bool = false

    var fossil : FossilModel

    var body: some View {
        ZStack {
            Color("ACNHBackground").ignoresSafeArea()
            GeometryReader { geometry in
                VStack {
                    ImageCardView(url: fossil.image_url, frameWidth: imageCardZoomed ? geometry.size.width : geometry.size.width / 4,
                                  frameHeight: imageCardZoomed ? geometry.size.height : geometry.size.height / 4)
                        .onTapGesture {
                            withAnimation {
                                imageCardZoomed.toggle()
                            }
                        }
                    Spacer()
                        .padding()
                    ScrollView {
                        if !fossil.fossil_group.isEmpty {
                            DetailView(icon: "magnifyingglass", header: "Fossil Group:", value: fossil.fossil_group, textColor: Color("ACNHText"))
                        }
                        
                        DetailView(icon: "hand.tap", header: "Interactive:", value: fossil.interactable ? "✔️" : "❌", textColor: Color("ACNHText"))
                        
                        DetailView(icon: "banknote", header: "Sell Price:", value: String(fossil.sell), textColor: Color("ACNHText"))
                        Spacer()
                            .frame(height: geometry.size.height * 0.15)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.75)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text(fossil.name.capitalized)
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

//struct FossilDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        FossilDetail()
//    }
//}
