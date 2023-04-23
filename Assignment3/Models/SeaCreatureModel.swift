//
//  SeaCreatureModel.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 4/19/23.
//

import Foundation

struct SeaCreature : Codable {
    let data : [SeaCreatureModel]
}

struct SeaCreatureModel: Identifiable, Codable {
    let name : String
    let id : Int
    let image_url : String
    let render_url : String
    let shadow_size : String
    let shadow_movement : String
    let rarity : String
    let sell_nook : Int
    let north : SeaCreatureAvailabilityModel
    let south : SeaCreatureAvailabilityModel

    enum CodingKeys: String, CodingKey {
        case name
        case id = "number"
        case image_url
        case render_url
        case shadow_size
        case shadow_movement
        case rarity
        case sell_nook
        case north
        case south
    }
}

struct SeaCreatureAvailabilityModel: Codable {
    let availability_array : [SeaCreatureMonthTimeModel]
    let times_by_month : TimesByMonthModel
    let months : String
    let months_array : [Int]

    enum CodingKeys: String, CodingKey {
        case availability_array
        case times_by_month
        case months
        case months_array
    }
}

struct SeaCreatureMonthTimeModel: Codable {
    let months : String
    let time : String

    enum CodingKeys: String, CodingKey {
        case months
        case time
    }
}
