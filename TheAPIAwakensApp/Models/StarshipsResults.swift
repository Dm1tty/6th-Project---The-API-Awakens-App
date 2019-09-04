//
//  StarshipsResults.swift
//  TheAPIAwakensApp
//
//  Created by Dzmitry Matsiulka on 9/1/19.
//  Copyright © 2019 Dzmitry M. All rights reserved.
//




import Foundation

// MARK: - StarshipsResult
struct StarshipsResult: Codable {
    let name, model, manufacturer, costInCredits: String
    let length, maxAtmospheringSpeed, crew, passengers: String
    let cargoCapacity, consumables: String
    let hyperdriveRating, mglt, starshipClass: String?
    let pilots, films: [String]
    let created, edited: String
    let url: String
    let vehicleClass: String?
    
    enum CodingKeys: String, CodingKey {
        case name, model, manufacturer
        case costInCredits = "cost_in_credits"
        case length
        case maxAtmospheringSpeed = "max_atmosphering_speed"
        case crew, passengers
        case cargoCapacity = "cargo_capacity"
        case consumables
        case hyperdriveRating = "hyperdrive_rating"
        case mglt = "MGLT"
        case starshipClass = "starship_class"
        case pilots, films, created, edited, url
        case vehicleClass = "vehicle_class"
    }
}
