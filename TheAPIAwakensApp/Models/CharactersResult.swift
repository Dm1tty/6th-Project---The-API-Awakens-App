//
//  CharactersResult.swift
//  TheAPIAwakensApp
//
//  Created by Dzmitry Matsiulka on 9/1/19.
//  Copyright © 2019 Dzmitry M. All rights reserved.
//



import Foundation

// MARK: - CharactersResult
struct CharactersResult: Codable {
    let name, height, mass, hairColor: String
    let skinColor, eyeColor, birthYear: String
    let gender: Gender
    let homeworld: String
    let films, species, vehicles, starships: [String]
    let created, edited: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name, height, mass
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
        case gender, homeworld, films, species, vehicles, starships, created, edited, url
    }
}
