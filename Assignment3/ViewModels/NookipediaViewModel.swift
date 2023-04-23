//
//  NookipediaViewModel.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/11/23.
//

import Foundation

struct NookpediaViewModel {
    static var apiKey: String {
      get {
        guard let filePath = Bundle.main.path(forResource: "Nookipedia-Info", ofType: "plist") else {
          fatalError("Couldn't find file 'Nookipedia-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
          fatalError("Couldn't find key 'API_KEY' in 'Nookipedia-Info.plist'.")
        }
        return value
      }
    }
}
