//
//  ParametersService.swift
//  AirQualityApp
//
//  Created by Léo NICOLAS on 10/12/2020.
//

import Foundation

// Class that manages the Parameters
class ParametersService {
    // The keys for the UserDefaults
    struct Keys {
        static let country = "country"
        static let countryIndex = "countryIndex"
        static let airParameter = "airParameter"
        static let airParameterIndex = "airParameterIndex"
    }

    // The isoCode country choiced by the user
    static var country: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.country) ?? "FR"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.country)
        }
    }

    // The index of country choiced by the user
    static var countryIndex: Int {
        get {
            return UserDefaults.standard.integer(forKey: Keys.countryIndex)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.countryIndex)
        }
    }

    // The airParameter choiced by the user
    static var airParameter: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.airParameter) ?? "pm25"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.airParameter)
        }
    }

    // The index in the segmentedControl of the airParameter choiced by the user
    static var airParameterIndex: Int {
        get {
            return UserDefaults.standard.integer(forKey: Keys.airParameterIndex)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.airParameterIndex)
        }
    }
}
