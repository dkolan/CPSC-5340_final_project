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
            ImageCardView(url: villager.image_uri)
            List {
                Text("Name: \(villager.name.nameUsEn)")
                Text("Birthday: \(villager.birthdayString)")
                Text("Personality: \(villager.personality)")
                Text("Species: \(villager.species)")
                Text("Gender: \(villager.gender)")
                Text("Hobby: \(villager.hobby)")
                Text("Catchphrase: \(villager.catchPhrase)")
                Text("Saying: \(villager.saying)")
            }
            .listStyle(PlainListStyle())
        }
     }
}

//struct VillagerDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        VillagerDetail()
//    }
//}
