//
//  Planets.swift
//  TheAPIAwakensApp
//
//  Created by Dzmitry Matsiulka on 9/2/19.
//  Copyright © 2019 Dzmitry M. All rights reserved.
//


import Foundation

// MARK: - Planets
struct Planets: Codable {
    let name, rotationPeriod, orbitalPeriod, diameter: String
    let climate, gravity, terrain, surfaceWater: String
    let population: String
    let residents, films: [String]
    let created, edited: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case rotationPeriod = "rotation_period"
        case orbitalPeriod = "orbital_period"
        case diameter, climate, gravity, terrain
        case surfaceWater = "surface_water"
        case population, residents, films, created, edited, url
    }
}
