//
//  VillagerModel.swift
//  ACNH Reference
//
//  Created by Dan Kolan on 3/14/23.
//

import Foundation

struct Villagers : Codable {
    let data : [VillagerModel]
}

struct VillagerModel: Identifiable, Codable {
    let name : String
    let id : String
    let image_url : String
    let species : String
    let personality : String
    let gender : String
    let birthday_month : String
    let birthday_day : String
    let quote : String
    let phrase : String
    let appearances : [String]
}
