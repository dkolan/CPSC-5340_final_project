//
//  ImageCardView.swift
//  Assignment3
//
//  Created by Dan Kolan on 3/14/23.
//

import SwiftUI

struct ImageCardView: View {
    var url : String
    var frameWidth : CGFloat
    var frameHeight : CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: url)) {
            image in
            image.resizable()
                .scaledToFit()
                .cornerRadius(20)
                .frame(width: frameWidth, height: frameHeight)
        } placeholder: {
            ProgressView()
        }
    }
}

struct ImageCardView_Previews: PreviewProvider {
    static var previews: some View {
        ImageCardView(url: "https://acnhapi.com/v1/images/villagers/1", frameWidth: 200, frameHeight: 200)
    }
}
