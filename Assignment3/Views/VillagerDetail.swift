//
//  VillagerDetail.swift
//  Assignment3
//
//  Created by Dan Kolan on 3/14/23.
//

import SwiftUI

struct VillagerDetail: View {
    var villager : VillagerModel
    
    var body: some View {
        VStack {
//            ImageCardView(url: villager.image_uri, frameWidth: 200, frameHeight: 200)
            ImageCardView(url: villager.image_url, frameWidth: 200, frameHeight: 200, imageId: villager.id.capitalized)
            List {
//                Text("Birthday: \(villager.birthdayString)")
//                Text("Personality: \(villager.personality)")
//                Text("Species: \(villager.species)")
//                Text("Gender: \(villager.gender)")
//                Text("Hobby: \(villager.hobby)")
//                Text("Catchphrase: \(villager.catchPhrase)")
//                Text("Saying: \(villager.saying)")
                
                Text("Birthday: \(villager.birthday_month) \(villager.birthday_day)")
                Text("Personality: \(villager.personality)")
                Text("Species: \(villager.species)")
                Text("Gender: \(villager.gender)")
                Text("Catchphrase: \(villager.phrase)")
                Text("Saying: \(villager.quote)")
            }
            .listStyle(PlainListStyle())
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
//                Text(villager.name.nameUsEn)
                Text(villager.name)
                    .font(.largeTitle.bold())
                    .accessibilityAddTraits(.isHeader)
            }
        }
     }
}

//struct VillagerDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        VillagerDetail()
//    }
//}
