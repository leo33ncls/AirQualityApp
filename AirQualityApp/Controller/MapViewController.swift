//
//  MapViewController.swift
//  AirQualityApp
//
//  Created by Léo NICOLAS on 09/12/2020.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.register(CustomAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier:
                         MKMapViewDefaultAnnotationViewReuseIdentifier)
        getAirQualityValues()
    }
    
    private func getAirQualityValues() {
        AirQualityService(session: URLSession(configuration: .default))
            .getAirQualityValue(for: "FR", parameter: "pm10") { (success, airQuality) in
                guard success, let airQuality = airQuality else {
                    return
                }
                self.setMarkers(airQualityList: airQuality)
            }
    }
    
    private func setMarkers(airQualityList: AirQualityList) {
        for location in airQualityList.results {
            let annotation = CustomAnnotation(locationResult: location)
            self.mapView.addAnnotation(annotation)
        }
    }
}
