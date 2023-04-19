//
//  BugModel.swift
//  Assignment3
//
//  Created by Dan Kolan on 4/19/23.
//

import Foundation

struct Bug : Codable {
    let data : [BugModel]
}

struct BugModel: Identifiable, Codable {
    let name : String
    let id : Int
    let image_url : String
    let render_url : String
    let location : String
    let rarity : String
    let sell_nook : Int
    let sell_flick : Int
    let north : BugAvailabilityModel
    let south : BugAvailabilityModel

    enum CodingKeys: String, CodingKey {
        case name
        case id = "number"
        case image_url
        case render_url
        case location
        case rarity
        case sell_nook
        case sell_flick
        case north
        case south
    }
}

struct BugAvailabilityModel: Codable {
    let availability_array : [BugMonthTimeModel]
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

struct BugMonthTimeModel: Codable {
    let months : String
    let time : String

    enum CodingKeys: String, CodingKey {
        case months
        case time
    }
}
