//
//  Covid.swift
//  GetHospital
//
//  Created by Chaithra Shrikrishna on 16/07/20.
//  Copyright © 2020 Chaithra Shrikrishna. All rights reserved.
//

import Foundation

struct CovidDetails: Codable {
    let state: State?
}

struct State: Codable {
    let districtData: DistrictData?
    let stateCode: String
}

struct DistrictData: Codable {
    let notes: String
    let active: Int
    let confirmed: Int
    let deceased: Int
    let recovered: Int
    let delta: Delta?
}

struct Delta: Codable {
    let confirmed: Int
    let deceased: Int
    let recovered: Int
}
