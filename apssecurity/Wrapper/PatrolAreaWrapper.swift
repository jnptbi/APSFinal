//
//  PatrolAreaWrapper.swift
//  APS Security
//
//  Created by Vishal Patel on 07/10/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import Foundation

struct PatrolAreaWrapper: Codable {
    let status: Int
    let message: String
    let data: PatrolAreaData
}

// MARK: - DataClass
struct PatrolAreaData: Codable {
    let vehiclePatrolArea: [vehiclePatrolArea]

    enum CodingKeys: String, CodingKey {
        case vehiclePatrolArea = "patrol_area"
    }
}

// MARK: - PatrolArea
struct vehiclePatrolArea: Codable {
    let patrolID, patrolAreaName:String

    enum CodingKeys: String, CodingKey {
        case patrolID = "patrol_id"
        case patrolAreaName = "patrol_area_name"
    }
}
