//
//  VillagerDetail.swift
//  Assignment3
//
//  Created by Dan Kolan on 3/14/23.
//

import SwiftUI

struct VillagerDetail: View {
    var villager : VillagerModel
    let villagerCardBaseUrl = "https://acnhcdn.com/latest/NpcBromide/NpcNml"
    
    var body: some View {
        VStack {
            ImageCardView(url: "\(villagerCardBaseUrl)\(villager.id.capitalized).png", frameWidth: 200, frameHeight: 200)
            List {
               
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
