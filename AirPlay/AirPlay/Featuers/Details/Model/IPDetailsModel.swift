//
//  IPDetailsModel.swift
//  AirPlay
//
//  Created by Aj on 17/08/24.
//

import Foundation

struct IPDetailsModel: Codable {
    let ip, hostname, city, region: String?
    let country, loc, org, postal: String?
    let timezone: String?
    let readme: String?
}
