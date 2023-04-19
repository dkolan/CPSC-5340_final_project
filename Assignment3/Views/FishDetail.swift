//
//  FishDetail.swift
//  Assignment3
//
//  Created by Dan Kolan on 3/20/23.
//

import SwiftUI

struct FishDetail: View {
    @ObservedObject var fishVM = FishViewModel()
    @EnvironmentObject var locationDataManager: LocationDataManager

    var fish : FishModel
    
    var northTimeString: String {
        return fish.north.availability_array.map { $0.time }.joined(separator: "; ")
    }
    
    var southTimeString: String {
        return fish.south.availability_array.map { $0.time }.joined(separator: "; ")
    }
    
    var body: some View {
        VStack {
            ImageCardView(url: fish.render_url, frameWidth: 200, frameHeight: 200)
            List {
                if (fishVM.hemisphere == "north") {
                    Text("Months Available: \(fish.north.months)")
                    Text("Time Available: \(northTimeString)")
                 }
                 else if (fishVM.hemisphere == "south") {
                     Text("Months Available: \(fish.south.months)")
                     Text("Time Available: \(southTimeString)")
                }
                Text("Location: \(fish.location)")
                Text("Rarity: \(fish.rarity)")
                Text("Shadow: \(fish.shadow_size)")
                Text("Nook Price: \(fish.sell_nook)")
                Text("CJ's Price: \(fish.sell_cj)")
            }
            .listStyle(PlainListStyle())
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(fish.name.capitalized)
                    .font(.largeTitle.bold())
                    .accessibilityAddTraits(.isHeader)
            }
        }
        .onAppear {
            fishVM.hemisphere = locationDataManager.hemisphere ?? "north" // default assumption user is north hemisphere
        }
     }
}


//struct FishDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        FishDetail()
//    }
//}
