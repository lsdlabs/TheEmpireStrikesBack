//
//  CharacterData.swift
//  TheEmpireStrikesBack
//
//  Created by Lauren Small on 12/26/18.
//  Copyright © 2018 Lauren Small. All rights reserved.
//

import Foundation

struct CharacterData: Codable {
    let name: String
    let birth_year: String
    let gender: String?
    let homeworld: String
    let species: [String]
    let mass: String
}
