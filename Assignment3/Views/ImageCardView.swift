//
//  ImageCardView.swift
//  Assignment3
//
//  Created by Dan Kolan on 3/14/23.
//

import SwiftUI
import Kingfisher

struct ImageCardView: View {
    var url : String
    var frameWidth : CGFloat
    var frameHeight : CGFloat
    
    var body: some View {
        KFImage(URL(string: url)!)
            .placeholder {
                ProgressView()
            }
            .cacheOriginalImage()
            .retry(maxCount: 3, interval: .seconds(5))
            .resizable()
            .frame(width: frameWidth, height: frameHeight)
            .cornerRadius(20)
            .onAppear {
//                Debug checking if images are successfulyl cached
//                print("url: \(url) cached: \(KingfisherManager.shared.cache.isCached(forKey:url))")
            }
    }
}

struct ImageCardView_Previews: PreviewProvider {
    static var previews: some View {
        ImageCardView(url: "https://acnhapi.com/v1/images/villagers/1", frameWidth: 200, frameHeight: 200)
    }
}
