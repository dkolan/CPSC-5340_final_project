////
////  FishModel.swift
////  Assignment3
////
////  Created by Dan Kolan on 3/19/23.
////

import Foundation

struct Fish : Codable {
    let data : [FishModel]
}

struct FishModel: Identifiable, Codable {
    let name : String
    let id : Int
    let image_url : String
    let render_url : String
    let location : String
    let shadow_size : String
    let rarity : String
    let sell_nook : Int
    let sell_cj : Int
    let north : FishAvailabilityModel
    let south : FishAvailabilityModel
    
    enum CodingKeys: String, CodingKey {
        case name
        case id = "number"
        case image_url
        case render_url
        case location
        case rarity
        case shadow_size
        case sell_nook
        case sell_cj
        case north
        case south
    }
}

struct FishAvailabilityModel: Codable {
    let availability_array : [FishMonthTimeModel]
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

struct FishMonthTimeModel: Codable {
    let months : String
    let time : String
    
    enum CodingKeys: String, CodingKey {
        case months
        case time
    }
}

struct TimesByMonthModel: Codable {
    let january : String
    let february : String
    let march : String
    let april : String
    let may : String
    let june : String
    let july : String
    let august : String
    let september : String
    let october : String
    let november : String
    let december : String
    
    enum CodingKeys: String, CodingKey {
        case january = "1"
        case february = "2"
        case march = "3"
        case april = "4"
        case may = "5"
        case june = "6"
        case july = "7"
        case august = "8"
        case september = "9"
        case october = "10"
        case november = "11"
        case december = "12"
    }
}
