//
//  SeaCreatureDetail.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/19/23.
//

import SwiftUI

struct SeaCreatureDetail: View {
    @StateObject var seaCreatureVM = SeaCreatureViewModel()
    @EnvironmentObject var locationDataManager: LocationDataManager
    @State var imageCardZoomed: Bool = false

    var seaCreature : SeaCreatureModel

    var northTimeString: String {
        return seaCreature.north.availability_array.map { $0.time }.joined(separator: "; ")
    }

    var southTimeString: String {
        return seaCreature.south.availability_array.map { $0.time }.joined(separator: "; ")
    }
    
    var months: String {
        return seaCreatureVM.hemisphere == "north" ? seaCreature.north.months : seaCreature.south.months
    }
    
    var time: String {
        return seaCreatureVM.hemisphere == "north" ? northTimeString : southTimeString
    }

    var body: some View {
        ZStack {
            Color("ACNHBackground").ignoresSafeArea()
            GeometryReader { geometry in
                VStack {
                    ImageCardView(url: seaCreature.render_url, frameWidth: imageCardZoomed ? geometry.size.width : geometry.size.width / 4,
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
                        DetailView(icon: "binoculars", header: "Shadow Size:", value: seaCreature.shadow_size, textColor: Color("ACNHText"))
                        DetailView(icon: "binoculars", header: "Shadow Movement:", value: seaCreature.shadow_movement, textColor: Color("ACNHText"))
                        if !seaCreature.rarity.isEmpty {
                            DetailView(icon: "magnifyingglass", header: "Rarity:", value: seaCreature.rarity, textColor: Color("ACNHText"))
                        }
                        DetailView(icon: "banknote", header: "Nook Price:", value: String(seaCreature.sell_nook), textColor: Color("ACNHText"))
                        Spacer()
                            .frame(height: geometry.size.height * 0.15)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.75)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(seaCreature.name.capitalized)
                            .font(.title)
                            .foregroundColor(Color("ACNHText"))
                            .accessibilityAddTraits(.isHeader)
                    }
                }
                .onAppear {
                    seaCreatureVM.hemisphere = locationDataManager.hemisphere ?? "north" // default assumption user is north hemisphere
                }
                
            }
        }
    }
}

//struct SeaCreatureDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        SeaCreatureDetail()
//    }
//}
