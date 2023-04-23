//
//  HeadwearModel.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/23/23.
//

import Foundation

struct Headwear: Codable {
    let data: [HeadwearModel]
}

struct HeadwearModel: Codable {
    let url: String
    let name: String
    let category: String
    let sell: Int
    let variationTotal: Int
    let villEquip: Bool
    let seasonality: String
    let versionAdded: String
    let unlocked: Bool
    let notes: String
    let labelThemes: [String]
    let styles: [String]
    let availability: [AvailabilityModel]
    let buy: [BuyModel]
    let variations: [VariationModel]

    enum CodingKeys: String, CodingKey {
        case url
        case name
        case category
        case sell
        case variationTotal = "variation_total"
        case villEquip = "vill_equip"
        case seasonality
        case versionAdded = "version_added"
        case unlocked, notes
        case labelThemes = "label_themes"
        case styles
        case availability
        case buy
        case variations
    }
}

extension HeadwearModel: Identifiable {
    var id: String { return name }
}
