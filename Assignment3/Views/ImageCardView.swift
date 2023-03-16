//
//  ImageCardView.swift
//  Assignment3
//
//  Created by Dan Kolan on 3/14/23.
//

import SwiftUI

struct ImageCardView: View {
    var url : String
    
    var body: some View {
        AsyncImage(url: URL(string: url)) {
            image in
            image.resizable()
                .scaledToFit()
                .cornerRadius(20)
                .frame(width: 200, height: 200)
        } placeholder: {
            ProgressView()
        }
    }
}

struct ImageCardView_Previews: PreviewProvider {
    static var previews: some View {
        ImageCardView(url: "https://acnhapi.com/v1/images/villagers/1")
    }
}
