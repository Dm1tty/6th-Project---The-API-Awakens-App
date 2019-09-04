//
//  FilmsResult.swift
//  TheAPIAwakensApp
//
//  Created by Dzmitry Matsiulka on 9/2/19.
//  Copyright © 2019 Dzmitry M. All rights reserved.
//



import Foundation

// MARK: - FilmsResult
struct FilmsResult: Codable {
    let title: String
    let episodeID: Int
    let openingCrawl, director, producer, releaseDate: String
    let characters, planets, starships, vehicles: [String]
    let species: [String]
    let created, edited: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case episodeID = "episode_id"
        case openingCrawl = "opening_crawl"
        case director, producer
        case releaseDate = "release_date"
        case characters, planets, starships, vehicles, species, created, edited, url
    }
}
