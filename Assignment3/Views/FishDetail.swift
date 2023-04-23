//
//  FishDetail.swift
//  Assignment3
//
//  Created by Dan Kolan on 3/20/23.
//

import SwiftUI

struct FishDetail: View {
    @StateObject var fishVM = FishViewModel()
    @EnvironmentObject var locationDataManager: LocationDataManager
    @State var imageCardZoomed: Bool = false

    var fish : FishModel
    
    var northTimeString: String {
        return fish.north.availability_array.map { $0.time }.joined(separator: "; ")
    }
    
    var southTimeString: String {
        return fish.south.availability_array.map { $0.time }.joined(separator: "; ")
    }
    
    var months: String {
        return fishVM.hemisphere == "north" ? fish.north.months : fish.south.months
    }
    
    var time: String {
        return fishVM.hemisphere == "north" ? northTimeString : southTimeString
    }

    
    var body: some View {
        ZStack {
            Color("ACNHBackground").ignoresSafeArea()
            GeometryReader { geometry in
                VStack {
                    ImageCardView(url: fish.render_url, frameWidth: imageCardZoomed ? geometry.size.width : geometry.size.width / 4,
                                  frameHeight: imageCardZoomed ? geometry.size.height : geometry.size.height / 4)
                        .onTapGesture {
                            withAnimation {
                                imageCardZoomed.toggle()
                            }
                        }
                    Spacer()
                        .padding()
                    ScrollView {
                        DetailView(icon: "calendar", header: "Months Available:", value: months, textColor: Color("ACNHText"))
                        DetailView(icon: "clock", header: "Time Available:", value: time, textColor: Color("ACNHText"))
                        DetailView(icon: "location", header: "Location:", value: fish.location, textColor: Color("ACNHText"))
                        if !fish.rarity.isEmpty {
                            DetailView(icon: "magnifyingglass", header: "Rarity:", value: fish.rarity, textColor: Color("ACNHText"))
                        }
                        DetailView(icon: "binoculars", header: "Shadow:", value: fish.shadow_size, textColor: Color("ACNHText"))
                        DetailView(icon: "banknote", header: "Nook Price:", value: String(fish.sell_nook), textColor: Color("ACNHText"))
                        DetailView(icon: "banknote", header: "CJ's Price:", value: String(fish.sell_cj), textColor: Color("ACNHText"))
                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.75)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(fish.name.capitalized)
                            .font(.largeTitle.bold())
                            .foregroundColor(Color("ACNHText"))
                            .accessibilityAddTraits(.isHeader)
                    }
                }
                .onAppear {
                    fishVM.hemisphere = locationDataManager.hemisphere ?? "north" // default assumption user is north hemisphere
                }
            }
        }
    }
}

//struct FishDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        FishDetail()
//    }
//}
