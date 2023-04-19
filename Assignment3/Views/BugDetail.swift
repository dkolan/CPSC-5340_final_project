//
//  BugDetail.swift
//  Assignment3
//
//  Created by Dan Kolan on 4/19/23.
//

import SwiftUI

struct BugDetail: View {
    @ObservedObject var BugVM = BugViewModel()
    @EnvironmentObject var locationDataManager: LocationDataManager

    var Bug : BugModel

    var northTimeString: String {
        return Bug.north.availability_array.map { $0.time }.joined(separator: "; ")
    }

    var southTimeString: String {
        return Bug.south.availability_array.map { $0.time }.joined(separator: "; ")
    }

    var body: some View {
        VStack {
            ImageCardView(url: Bug.render_url, frameWidth: 200, frameHeight: 200)
            List {
                if (BugVM.hemisphere == "north") {
                    Text("Months Available: \(Bug.north.months)")
                    Text("Time Available: \(northTimeString)")
                 }
                 else if (BugVM.hemisphere == "south") {
                     Text("Months Available: \(Bug.south.months)")
                     Text("Time Available: \(southTimeString)")
                }
                Text("Location: \(Bug.location)")
                if !Bug.rarity.isEmpty {
                    Text("Rarity: \(Bug.rarity)")
                }
                Text("Nook Price: \(Bug.sell_nook)")
                Text("CJ's Price: \(Bug.sell_flick)")
            }
            .listStyle(PlainListStyle())
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(Bug.name.capitalized)
                    .font(.largeTitle.bold())
                    .accessibilityAddTraits(.isHeader)
            }
        }
        .onAppear {
            BugVM.hemisphere = locationDataManager.hemisphere ?? "north" // default assumption user is north hemisphere
        }
     }
}

//struct BugDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        BugDetail()
//    }
//}
