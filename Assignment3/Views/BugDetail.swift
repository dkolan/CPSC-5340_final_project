//
//  BugDetail.swift
//  Assignment3
//
//  Created by Dan Kolan on 4/19/23.
//

import SwiftUI

struct BugDetail: View {
    @StateObject var BugVM = BugViewModel()
    @EnvironmentObject var locationDataManager: LocationDataManager
    @State var imageCardZoomed: Bool = false

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
            GeometryReader { geometry in
                VStack {
                    ImageCardView(url: bug.render_url, frameWidth: imageCardZoomed ? geometry.size.width : geometry.size.width / 4,
                                  frameHeight: imageCardZoomed ? geometry.size.height : geometry.size.height / 4)
                        .onTapGesture {
                            withAnimation {
                                imageCardZoomed.toggle()
                            }
                        }
                    Spacer()
                        .padding()
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
                            .frame(height: geometry.size.height * 0.15)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.75)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text(bug.name.capitalized)
                                .font(.title)
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
}

struct DetailView: View {
    var icon: String
    var header: String
    var value: String
    var textColor: Color
    
    var body: some View {
        HStack {
            Text("\(Image(systemName: icon)) ")
                .foregroundColor(textColor) +
            Text("\(header) ")
                .font(.headline)
                .foregroundColor(textColor) +
            Text("\(value) ")
                .font(.body)
                .foregroundColor(textColor)
        }
        .padding()
        .frame(minWidth: 0.0, maxWidth: .infinity, alignment: .leading)
        .background(Color("ACNHCardBackground"))
//        .background(LinearGradient(colors: [Color("ACNHCardBackground"), Color("ACNHBackground")], startPoint: .bottomLeading, endPoint: .trailing))
        .cornerRadius(15)
//        .shadow(color: Color("ACNHCardBackground")
//        .opacity(0.4), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 20)
    }
}

//struct BugDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        BugDetail()
//    }
//}
