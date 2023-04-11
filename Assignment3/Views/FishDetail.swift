////
////  FishDetail.swift
////  Assignment3
////
////  Created by Dan Kolan on 3/20/23.
////
//
//import SwiftUI
//
//struct FishDetail: View {
//    var fish : FishModel
//    
//    var body: some View {
//        let monthArrayNorthernStart = fish.availability.monthArrayNorthern.first ?? 1
//        let monthArrayNorthernEnd = fish.availability.monthArrayNorthern.last ?? 12
//        let monthArraySouthernStart = fish.availability.monthArraySouthern.first ?? 1
//        let monthArraySouthernEnd = fish.availability.monthArraySouthern.last ?? 12
//        
//        let northernStartMonth = DateFormatter().monthSymbols[monthArrayNorthernStart - 1]
//        let northernEndMonth = DateFormatter().monthSymbols[monthArrayNorthernEnd - 1]
//        let southernStartMonth = DateFormatter().monthSymbols[monthArraySouthernStart - 1]
//        let southernEndMonth = DateFormatter().monthSymbols[monthArraySouthernEnd - 1]
//        
//        let fishAvailabilityTime = fish.availability.time == "" ? "24 Hours" : fish.availability.time
//
//        VStack {
//            ImageCardView(url: fish.image_uri, frameWidth: 200, frameHeight: 200)
//            List {
//                Text("Months Available: \n\(northernStartMonth)-\(northernEndMonth) (Northern Hemisphere)\n\(southernStartMonth)-\(southernEndMonth) (Southern Hemisphere)")
//                Text("Time Available: \(fishAvailabilityTime)")
//                Text("Location: \(fish.availability.location)")
//                Text("Rarity: \(fish.availability.rarity)")
//                Text("Shadow: \(fish.shadow)")
//                Text("Nook Price: \(fish.price)")
//                Text("CJ's Price: \(fish.priceCj)")
//            }
//            .listStyle(PlainListStyle())
//        }
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .principal) {
//                Text(fish.name.nameUsEn.capitalized)
//                    .font(.largeTitle.bold())
//                    .accessibilityAddTraits(.isHeader)
//            }
//        }
//     }
//}
//
////struct FishDetail_Previews: PreviewProvider {
////    static var previews: some View {
////        FishDetail()
////    }
////}
