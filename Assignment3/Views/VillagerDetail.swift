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
    @State var imageCardZoomed: Bool = false
    
    var body: some View {
        ZStack {
            Color("ACNHBackground").ignoresSafeArea()
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    ImageCardView(url: "\(villagerCardBaseUrl)\(villager.id.capitalized).png",
                          frameWidth: imageCardZoomed ? geometry.size.width : geometry.size.width / 4,
                          frameHeight: imageCardZoomed ? geometry.size.height : geometry.size.height / 4)
                        .onTapGesture {
                            withAnimation {
                                imageCardZoomed.toggle()
                            }
                        }
                    Spacer()
                        .padding()
                    ScrollView {
                        DetailView(icon: "calendar", header: "Birthday:", value: "\(villager.birthday_month) \(villager.birthday_day)", textColor: Color("ACNHText"))
                        DetailView(icon: "person.crop.circle.badge.questionmark", header: "Personality:", value: villager.personality, textColor: Color("ACNHText"))
                        DetailView(icon: "pawprint.circle", header: "Species:", value: villager.species, textColor: Color("ACNHText"))
                        DetailView(icon: "cross.circle", header: "Gender:", value: villager.gender, textColor: Color("ACNHText"))
                        DetailView(icon: "quote.bubble", header: "Catchphrase:", value: "\"\(villager.phrase)\"", textColor: Color("ACNHText"))
                        DetailView(icon: "mic", header: "Saying:", value: "\"\(villager.quote)\"", textColor: Color("ACNHText"))
                        Spacer()
                            .frame(height: geometry.size.height * 0.15)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.75)
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
}

//struct VillagerDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        VillagerDetail()
//    }
//}
