//
//  ArtModel.swift
//  Assignment3
//
//  Created by Dan Kolan on 4/21/23.
//

import Foundation

struct Art {
    let data: [ArtModel]
}

struct ArtModel: Codable {
    let name: String
    let url: String
    let has_fake: Bool
    let art_name: String
    let art_type: String
    let author: String
    let year: String
    let art_style: String
    let buy: Int
    let sell: Int
    let availability: String
    let real_info: RealInfoModel
    let fake_info: FakeInfoModel?
}

extension ArtModel: Identifiable {
    var id: String { return name }
}

struct RealInfoModel: Codable {
    let image_url: String
    let texture_url: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case image_url
        case texture_url
        case description
    }
}

struct FakeInfoModel: Codable {
    let image_url: String
    let texture_url: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case image_url
        case texture_url
        case description
    }
}
