//
//  AirQualityList.swift
//  AirQualityApp
//
//  Created by Léo NICOLAS on 08/12/2020.
//

import Foundation

// MARK: - AirQualityList
struct AirQualityList: Decodable {
    let meta: Meta
    let results: [Result]
}

// MARK: - Meta
struct Meta: Decodable {
    let name, license: String
    let website: String
    let page, limit, found: Int
}

// MARK: - Result
struct Result: Decodable {
    let location: String
    let parameter: String
    let value: Double
    let unit: String
    let coordinates: Coordinates
    let country: String
    let city: String
}

// MARK: - Coordinates
struct Coordinates: Decodable {
    let latitude, longitude: Double
}
