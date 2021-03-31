//
//  InsertFileWrapper.swift
//  APS Security
//
//  Created by phycom on 12/10/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import Foundation

struct InsertFileWrapper: Codable {
    let status: Int
    let message: String
    let data: [FileInsertData]
}

struct FileInsertData: Codable {
    let image_id: String
    let image_name: String

    enum CodingKeys: String, CodingKey {
        case image_id = "image_id"
        case image_name = "image_name"
    }
}


struct uploadImagesWrapper: Codable {
    let status: Int
    let message: String
    let image_id: [[Int]]
}
