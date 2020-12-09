//
//  FakeResponseData.swift
//  AirQualityAppTests
//
//  Created by Léo NICOLAS on 08/12/2020.
//

import Foundation

class FakeResponseData {
    static var airQualityCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "AirQuality", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }

    static let incorrectData = "erreur".data(using: .utf8)!

    static let responseOK = HTTPURLResponse(url: URL(string: "https://")!,
                                            statusCode: 200,
                                            httpVersion: nil,
                                            headerFields: nil)

    static let responseKO = HTTPURLResponse(url: URL(string: "https://")!,
                                            statusCode: 500,
                                            httpVersion: nil,
                                            headerFields: nil)

    class ResquestError: Error {}
    static let error = ResquestError()
}
