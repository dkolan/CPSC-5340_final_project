//
//  FossilModel.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/22/23.
//

import Foundation

struct Fossil: Codable {
    let data: [FossilModel]
}

struct FossilModel: Codable {
    let name: String
    let url: String
    let image_url: String
    let fossil_group: String
    let interactable: Bool
    let sell: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
        case image_url
        case fossil_group
        case interactable
        case sell
    }
}

extension FossilModel: Identifiable {
    var id: String { return name }
}
