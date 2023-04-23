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
            .retry(maxCount: 3, interval: .seconds(5))
            .cacheOriginalImage()
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: frameWidth, height: frameHeight)
            .onAppear {
//                Debug checking if images are successfulyl cached
//                print("url: \(url) cached: \(KingfisherManager.shared.cache.isCached(forKey:url))")
            }
    }
}

struct ImageCardView_Previews: PreviewProvider {
    static var previews: some View {
        ImageCardView(url: "https://acnhcdn.com/latest/NpcBromide/NpcNmlCat01.png",frameWidth: 200, frameHeight: 200)
    }
}
