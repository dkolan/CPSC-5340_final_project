//
//  SeaCreatureDetail.swift
//  Assignment3
//
//  Created by Dan Kolan on 4/19/23.
//

import SwiftUI

struct SeaCreatureDetail: View {
    @ObservedObject var SeaCreatureVM = SeaCreatureViewModel()
    @EnvironmentObject var locationDataManager: LocationDataManager

    var SeaCreature : SeaCreatureModel

    var northTimeString: String {
        return SeaCreature.north.availability_array.map { $0.time }.joined(separator: "; ")
    }

    var southTimeString: String {
        return SeaCreature.south.availability_array.map { $0.time }.joined(separator: "; ")
    }

    var body: some View {
        VStack {
            ImageCardView(url: SeaCreature.render_url, frameWidth: 200, frameHeight: 200)
            List {
                if (SeaCreatureVM.hemisphere == "north") {
                    Text("Months Available: \(SeaCreature.north.months)")
                    Text("Time Available: \(northTimeString)")
                 }
                 else if (SeaCreatureVM.hemisphere == "south") {
                     Text("Months Available: \(SeaCreature.south.months)")
                     Text("Time Available: \(southTimeString)")
                }
                Text("Shadow Size: \(SeaCreature.shadow_size)")
                Text("Shadow Movement: \(SeaCreature.shadow_movement)")
                if !SeaCreature.rarity.isEmpty {
                    Text("Rarity: \(SeaCreature.rarity)")
                }
                Text("Nook Price: \(SeaCreature.sell_nook)")
            }
            .listStyle(PlainListStyle())
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(SeaCreature.name.capitalized)
                    .font(.largeTitle.bold())
                    .accessibilityAddTraits(.isHeader)
            }
        }
        .onAppear {
            SeaCreatureVM.hemisphere = locationDataManager.hemisphere ?? "north" // default assumption user is north hemisphere
        }
     }
}

//struct SeaCreatureDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        SeaCreatureDetail()
//    }
//}
