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

    var bug : BugModel

    var northTimeString: String {
        return bug.north.availability_array.map { $0.time }.joined(separator: "; ")
    }

    var southTimeString: String {
        return bug.south.availability_array.map { $0.time }.joined(separator: "; ")
    }
    
    var months: String {
        return BugVM.hemisphere == "north" ? bug.north.months : bug.south.months
    }
    
    var time: String {
        return BugVM.hemisphere == "north" ? northTimeString : southTimeString
    }

    var body: some View {
        ZStack {
            Color("ACNHBackground").ignoresSafeArea()
                VStack {
                    ImageCardView(url: bug.render_url, frameWidth: 200, frameHeight: 200)
                    ScrollView {
                        DetailView(icon: "calendar", header: "Months Available:", value: months, textColor: Color("ACNHText"))
                        DetailView(icon: "clock", header: "Time Available:", value: time, textColor: Color("ACNHText"))
                        DetailView(icon: "location", header: "Location:", value: bug.location, textColor: Color("ACNHText"))
                        if !bug.rarity.isEmpty {
                            DetailView(icon: "magnifyingglass", header: "Rarity:", value: bug.rarity, textColor: Color("ACNHText"))
                        }
                        DetailView(icon: "banknote", header: "Nook Price:", value: String(bug.sell_nook), textColor: Color("ACNHText"))
                        DetailView(icon: "banknote", header: "Flick's Price:", value: String(bug.sell_flick), textColor: Color("ACNHText"))
                        Spacer()
                    }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(bug.name.capitalized)
                            .font(.largeTitle.bold())
                            .foregroundColor(Color("ACNHText"))
                            .accessibilityAddTraits(.isHeader)
                    }
                }
                .onAppear {
                    BugVM.hemisphere = locationDataManager.hemisphere ?? "north" // default assumption user is north hemisphere
                }
            }
        }
     }
}

struct DetailView: View {
    var icon: String
    var header: String
    var value: String
    var textColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(textColor)
            Text(header)
                .font(.headline)
                .foregroundColor(textColor)
            Text(value)
                .font(.body)
                .foregroundColor(textColor)
        }
        .padding()
        .frame(minWidth: 0.0, maxWidth: .infinity, alignment: .leading)
        .background(Color("ACNHCardBackground"))
//        .background(LinearGradient(colors: [Color("ACNHCardBackground"), Color("ACNHBackground")], startPoint: .bottomLeading, endPoint: .trailing))
        .cornerRadius(15)
        .shadow(color: Color("ACNHCardBackground")
        .opacity(0.4), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 20)
    }
}

//struct BugDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        BugDetail()
//    }
//}
