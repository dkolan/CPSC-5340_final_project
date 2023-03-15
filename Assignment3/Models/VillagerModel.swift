//
//  CharacterModel.swift
//  Assignment3
//
//  Created by Dan Kolan on 3/14/23.
//

import Foundation

struct Villagers {
    let villagers : [VillagerModel]
}

struct VillagerModel: Identifiable, Codable {
    let id : Int
    let name : NameModel
    let personality : String
    let birthdayString : String
    let birthday : String
    let species : String
    let gender : String
    let hobby : String
    let catchPhrase : String
    let icon_uri : String
    let image_uri : String
    let saying : String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case personality
        case birthdayString = "birthday-string"
        case birthday
        case species
        case gender
        case hobby
        case catchPhrase = "catch-phrase"
        case icon_uri
        case image_uri
        case saying
    }
}

// Not extracted because of it's simplicity
struct NameModel: Codable {
    let nameUsEn : String
    
    enum CodingKeys: String, CodingKey {
        case nameUsEn = "name-USen"
    }
    
}
