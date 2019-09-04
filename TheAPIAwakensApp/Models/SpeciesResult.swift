//
//  SpeciesResult.swift
//  TheAPIAwakensApp
//
//  Created by Dzmitry Matsiulka on 9/2/19.
//  Copyright © 2019 Dzmitry M. All rights reserved.
//


import Foundation

// MARK: - SpeciesResult
struct SpeciesResult: Codable {
    let name, classification: String
    let designation: Designation
    let averageHeight, skinColors, hairColors, eyeColors: String
    let averageLifespan: String
    let homeworld: String?
    let language: String
    let people, films: [String]
    let created, edited: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name, classification, designation
        case averageHeight = "average_height"
        case skinColors = "skin_colors"
        case hairColors = "hair_colors"
        case eyeColors = "eye_colors"
        case averageLifespan = "average_lifespan"
        case homeworld, language, people, films, created, edited, url
    }
}
