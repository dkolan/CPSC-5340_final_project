//
//  VillagerDetail.swift
//  Assignment3
//
//  Created by Dan Kolan on 3/14/23.
//

import SwiftUI

private var Cyrano = VillagerModel(
    id: 1,
    name: NameModel(nameUsEn: "Cyrano"),
    personality: "Cranky",
    birthdayString: "March 9th",
    birthday: "9/3",
    species: "Anteater",
    gender: "Male",
    hobby: "Education",
    catchPhrase: "ah-CHOO",
    icon_uri: "https://acnhapi.com/v1/icons/villagers/1",
    image_uri: "https://acnhapi.com/v1/images/villagers/1",
    saying: "Don't punch your nose to spite your face."
)

private var villagers = [
    Cyrano
]


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
