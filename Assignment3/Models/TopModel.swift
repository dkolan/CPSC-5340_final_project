//
//  TopModel.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/22/23.
//

import Foundation

struct Top: Codable {
    let data: [TopModel]
}

struct TopModel: Codable {
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

extension TopModel: Identifiable {
    var id: String { return name }
}

struct AvailabilityModel: Codable {
    let from: String
    let note: String
}

struct BuyModel: Codable {
    let price: Int
    let currency: String
}

struct VariationModel: Codable {
    let variation: String
    let imageUrl: String
    let colors: [String]

    enum CodingKeys: String, CodingKey {
        case variation
        case imageUrl = "image_url"
        case colors
    }
}

extension VariationModel: Identifiable {
    var id: String { return imageUrl }
}
