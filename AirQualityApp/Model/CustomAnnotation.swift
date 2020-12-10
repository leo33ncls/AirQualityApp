//
//  CustomAnnotation.swift
//  AirQualityApp
//
//  Created by Léo NICOLAS on 09/12/2020.
//

import MapKit

// The customAnnotation for the map.
class CustomAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var airParameter: String
    var airValue: Double
    var coordinate: CLLocationCoordinate2D
    
    init(locationResult: LocationResult) {
        self.title = locationResult.city
        self.subtitle = "\(locationResult.parameter): \(locationResult.value) \(locationResult.unit)"
        self.coordinate = CLLocationCoordinate2D(latitude: locationResult.coordinates.latitude, longitude: locationResult.coordinates.longitude)
        self.airParameter = locationResult.parameter
        self.airValue = locationResult.value
        super.init()
    }
}
