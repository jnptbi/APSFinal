//
//  VehicleUnitWrapper.swift
//  APS Security
//
//  Created by Vishal Patel on 06/10/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct VehicleUnitWrapper: Codable {
    let status: Int
    let message: String
    let data: VehicleUnitDataClass
}

// MARK: - DataClass
struct VehicleUnitDataClass: Codable {
    let vehicleUnitList: [vehicleUnitList]

    enum CodingKeys: String, CodingKey {
        case vehicleUnitList = "patrol_area"
    }
}

// MARK: - PatrolArea
struct vehicleUnitList: Codable {
    var vehicleID, vehicleName, vehicleRego, vehicleModel: String

    enum CodingKeys: String, CodingKey {
        case vehicleID = "vehicle_id"
        case vehicleName = "vehicle_name"
        case vehicleRego = "vehicle_rego"
        case vehicleModel = "vehicle_model"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        vehicleID = try container.decode(String.self, forKey: .vehicleID)
        vehicleName = try container.decode(String.self, forKey: .vehicleName)
        vehicleRego = try container.decode(String.self, forKey: .vehicleRego)
        vehicleModel = try container.decode(String.self, forKey: .vehicleModel)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(vehicleID, forKey: .vehicleID)
        try container.encode(vehicleName, forKey: .vehicleName)
        try container.encode(vehicleRego, forKey: .vehicleRego)
        try container.encode(vehicleModel, forKey: .vehicleModel)
    }
    
}
