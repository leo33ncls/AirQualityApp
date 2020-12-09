//
//  CustomAnnotationView.swift
//  AirQualityApp
//
//  Created by Léo NICOLAS on 09/12/2020.
//

import UIKit
import MapKit

class CustomAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let customAnnotation = newValue as? CustomAnnotation else {
                return
            }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(14)
            detailLabel.text = customAnnotation.subtitle
            detailCalloutAccessoryView = detailLabel
        }
    }
}
