//
//  Films.swift
//  TheAPIAwakensApp
//
//  Created by Dzmitry Matsiulka on 9/2/19.
//  Copyright © 2019 Dzmitry M. All rights reserved.
//



import Foundation

// MARK: - Films
struct Films: Codable {
    let count: Int
    let next, previous: JSONNull?
    let results: [FilmsResult]
}
