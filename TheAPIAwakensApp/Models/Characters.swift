//
//  Characters.swift
//  TheAPIAwakensApp
//
//  Created by Dzmitry Matsiulka on 9/1/19.
//  Copyright © 2019 Dzmitry M. All rights reserved.
//



import Foundation

// MARK: - Characters
struct Characters: Codable {
    let count: Int
    let next, previous: String?
    let results: [CharactersResult]
}
