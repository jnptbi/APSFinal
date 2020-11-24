//
//  ShiftStartWrapper.swift
//  APS Security
//
//  Created by phycom on 12/10/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import Foundation

struct ShiftStartWrapper: Codable {
    let status: Int
    let message: String
    let shift_id: Int
}

struct SiteReportWrapper: Codable {
    let status: Int
    let message: String
    let site_report_id: Int
}

struct EndShiftWrapper: Codable {
    let status: Int
    let message: String
}

