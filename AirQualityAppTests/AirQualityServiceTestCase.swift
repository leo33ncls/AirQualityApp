//
//  AirQualityServiceTestCase.swift
//  AirQualityAppTests
//
//  Created by Léo NICOLAS on 08/12/2020.
//

@testable import AirQualityApp
import XCTest

// Tests of the airQualityService Class
class AirQualityServiceTestCase: XCTestCase {
    let country = "FR"
    let parameter = "pm25"
    
    //=====================
    // Test function getAirQualityValue

    func testGetAirQualityValueShouldPostFailedCallbackIfError() {
        // Given
        let airQualityService = AirQualityService(session: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        airQualityService.getAirQualityValue(for: country, parameter: parameter) { (success, airQualityList) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(airQualityList)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetAirQualityValueShouldPostFailedCallbackIfNoData() {
        // Given
        let airQualityService = AirQualityService(session: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        airQualityService.getAirQualityValue(for: country, parameter: parameter) { (success, airQualityList) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(airQualityList)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetAirQualityValueShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let airQualityService = AirQualityService(session: URLSessionFake(data: FakeResponseData.airQualityCorrectData, response: FakeResponseData.responseKO, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        airQualityService.getAirQualityValue(for: country, parameter: parameter) { (success, airQualityList) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(airQualityList)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetAirQualityValueShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let airQualityService = AirQualityService(session: URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        airQualityService.getAirQualityValue(for: country, parameter: parameter) { (success, airQualityList) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(airQualityList)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetAirQualityValueShouldPostSuccesCallbackIfNoErrorAndCorrectData() {
        // Given
        let airQualityService = AirQualityService(session: URLSessionFake(data: FakeResponseData.airQualityCorrectData, response: FakeResponseData.responseOK, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        airQualityService.getAirQualityValue(for: country, parameter: parameter) { (success, airQualityList) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(airQualityList)

            XCTAssertEqual(airQualityList?.meta.name, "openaq-api")
            XCTAssertEqual(airQualityList?.results[0].city, "Moselle")

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.1)
    }
}
