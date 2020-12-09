//
//  AirQualityService.swift
//  AirQualityApp
//
//  Created by Léo NICOLAS on 08/12/2020.
//

import Foundation

/// Class that manages the air quality API.
class AirQualityService {

    /// The main URL of the API that sends the air quality values.
    private static let airQualityURL = "https://api.openaq.org/v1/measurements"

    private var task: URLSessionDataTask?

    private var session = URLSession(configuration: .default)

    /// Initializer that is used for the unit test
    init(session: URLSession) {
        self.session = session
    }

    /**
     Function which creates an Url with a country and a parameter for the air quality API.
     - Calling this function adds a country and a givenParamerter to the airQualityURL.

     - Parameters:
        - country: The country we want the air quality values.
        - parameter: The air parameter we want to receive the values from the API.
     - Returns: A valid url for the air quality API or a nil.
     */
    private func airQualityURL(country: String, parameter: String) -> URL? {
        var APIAirQualityURL = URLComponents(string: AirQualityService.airQualityURL)
        APIAirQualityURL?.queryItems = [URLQueryItem(name: "country", value: country),
                                        URLQueryItem(name: "parameter", value: parameter)]
        guard let url = APIAirQualityURL?.url else { return nil }
        return url
    }

    /**
     Function which returns a callback with a air quality list for a given country.

     Calling this function calls the airQualityUrl function,
     checks if the url is valid, sends a request with the url,
     gets a JSON responses from the API, tries to decode the response in a AirQualityList objet
     and returns a callback with an air quality list.

     - Parameters:
        - country: The country we want the air quality values.
        - parameter: The air parameter for which we want to receive the values from the API.
        - callback: The callback returning the air quality list.
     */
    func getAirQualityValue(for country: String, parameter: String, callback: @escaping (Bool, AirQualityList?) -> Void) {
        guard let url = airQualityURL(country: country, parameter: parameter) else {
            callback(false, nil)
            return
        }

        task?.cancel()
        task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }

                guard let airQualityJSON = try? JSONDecoder().decode(AirQualityList.self, from: data) else {
                    callback(false, nil)
                    return
                }

                callback(true, airQualityJSON)
            }
        }
        task?.resume()
    }
}
