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
        ZStack {
            Color("ACNHBackground").ignoresSafeArea()
            VStack {
                ImageCardView(url: "\(villagerCardBaseUrl)\(villager.id.capitalized).png", frameWidth: 200, frameHeight: 200)
                ScrollView {
                    DetailView(icon: "calendar", header: "Birthday:", value: "\(villager.birthday_month) \(villager.birthday_day)", textColor: Color("ACNHText"))
                    DetailView(icon: "person.crop.circle.badge.questionmark", header: "Personality:", value: villager.personality, textColor: Color("ACNHText"))
                    DetailView(icon: "pawprint.circle", header: "Species:", value: villager.species, textColor: Color("ACNHText"))
                    DetailView(icon: "cross.circle", header: "Gender:", value: villager.gender, textColor: Color("ACNHText"))
                    DetailView(icon: "quote.bubble", header: "Catchphrase:", value: "\"\(villager.phrase)\"", textColor: Color("ACNHText"))
                    DetailView(icon: "mic", header: "Saying:", value: "\"\(villager.quote)\"", textColor: Color("ACNHText"))
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(villager.name)
                        .font(.largeTitle.bold())
                        .foregroundColor(Color("ACNHText"))
                        .accessibilityAddTraits(.isHeader)
                }
            }
        }
     }
}

//struct VillagerDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        VillagerDetail()
//    }
//}
