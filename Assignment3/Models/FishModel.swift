////
////  FishModel.swift
////  Assignment3
////
////  Created by Dan Kolan on 3/19/23.
////
//
//import Foundation
//
//struct Fish : Codable {
//    let data : [FishModel]
//}
//
//struct FishModel: Identifiable, Codable {
//    let id : Int
//    let name : NameModel
//    let availability : FishAvailabilityModel
//    let shadow : String
//    let price : Int
//    let priceCj : Int
//    let icon_uri : String
//    let image_uri : String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case availability
//        case shadow
//        case price
//        case priceCj = "price-cj"
//        case icon_uri
//        case image_uri
//    }
//}
//
//struct FishAvailabilityModel: Codable {
//    let time : String
//    let isAllDay : Bool
//    let isAllYear : Bool
//    let location : String
//    let rarity : String
//    let monthArrayNorthern : [Int]
//    let monthArraySouthern : [Int]
//    
//    enum CodingKeys: String, CodingKey {
//        case time
//        case isAllDay
//        case isAllYear
//        case location
//        case rarity
//        case monthArrayNorthern = "month-array-northern"
//        case monthArraySouthern = "month-array-southern"
//    }
//}
