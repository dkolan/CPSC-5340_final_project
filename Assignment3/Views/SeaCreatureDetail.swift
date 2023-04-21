//
//  SeaCreatureDetail.swift
//  Assignment3
//
//  Created by Dan Kolan on 4/19/23.
//

import SwiftUI

struct SeaCreatureDetail: View {
    @ObservedObject var seaCreatureVM = SeaCreatureViewModel()
    @EnvironmentObject var locationDataManager: LocationDataManager

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
            VStack {
                ImageCardView(url: seaCreature.render_url, frameWidth: 200, frameHeight: 200)
                ScrollView {
                    DetailView(icon: "calendar", header: "Months Available:", value: months, textColor: Color("ACNHText"))
                    DetailView(icon: "clock", header: "Time Available:", value: time, textColor: Color("ACNHText"))
                    DetailView(icon: "binoculars", header: "Shadow Size:", value: seaCreature.shadow_size, textColor: Color("ACNHText"))
                    DetailView(icon: "binoculars", header: "Shadow Movement:", value: seaCreature.shadow_movement, textColor: Color("ACNHText"))
                    if !seaCreature.rarity.isEmpty {
                        DetailView(icon: "magnifyingglass", header: "Rarity:", value: seaCreature.rarity, textColor: Color("ACNHText"))
                    }
                    DetailView(icon: "banknote", header: "Nook Price:", value: String(seaCreature.sell_nook), textColor: Color("ACNHText"))                }
                .listStyle(PlainListStyle())
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(seaCreature.name.capitalized)
                        .font(.largeTitle.bold())
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

//struct SeaCreatureDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        SeaCreatureDetail()
//    }
//}
