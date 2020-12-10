//
//  CustomAnnotationView.swift
//  AirQualityApp
//
//  Created by Léo NICOLAS on 09/12/2020.
//

import UIKit
import MapKit

// The CustomAnnotationView for the map.
class CustomAnnotationView: MKMarkerAnnotationView {

    override var annotation: MKAnnotation? {
        willSet {
            guard let customAnnotation = newValue as? CustomAnnotation else {
                return
            }
            // Some changes of the annotation appearance
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(14)
            detailLabel.text = customAnnotation.subtitle
            detailCalloutAccessoryView = detailLabel
            displayMarkersColor(detailLabel: detailLabel, customAnnotation: customAnnotation)
        }
    }
    
    // Function that diplays a color for the annotation depending on a parameter.
    private func displayMarkersColor(detailLabel: UILabel, customAnnotation: CustomAnnotation) {
        switch customAnnotation.airParameter {
        case "pm25":
            setpm25andpm10ColorAnnotation(detailLabel: detailLabel,
                                          customAnnotation: customAnnotation)
        case "pm10":
            setpm25andpm10ColorAnnotation(detailLabel: detailLabel,
                                          customAnnotation: customAnnotation)
        case "so2":
            setSo2ColorAnnotaion(detailLabel: detailLabel,
                                 customAnnotation: customAnnotation)
        case "no2":
            setNo2ColorAnnotation(detailLabel: detailLabel,
                                  customAnnotation: customAnnotation)
        case "o3":
            setO3ColorAnnotation(detailLabel: detailLabel,
                                      customAnnotation: customAnnotation)
        default:
            markerTintColor = UIColor.blue
        }
    }
    
    // Function that sets a color for the pm25 and p10 parameter depending on a value.
    private func setpm25andpm10ColorAnnotation(detailLabel: UILabel, customAnnotation: CustomAnnotation) {
        switch customAnnotation.airValue {
        case ..<30:
            markerTintColor = UIColor().customGreen
            detailLabel.textColor = UIColor().customGreen
        case 30..<50:
            markerTintColor = UIColor().customYellow
            detailLabel.textColor = UIColor().customWrittingYellow
        case 50..<80:
            markerTintColor = UIColor.orange
            detailLabel.textColor = UIColor.orange
        case 80...:
            markerTintColor = UIColor.red
            detailLabel.textColor = UIColor.red
        default:
            markerTintColor = UIColor.blue
        }
    }

    // Function that sets a color for the so2 parameter depending on a value.
    private func setSo2ColorAnnotaion(detailLabel: UILabel, customAnnotation: CustomAnnotation) {
        switch customAnnotation.airValue {
        case ..<50:
            markerTintColor = UIColor().customGreen
            detailLabel.textColor = UIColor().customGreen
        case 50..<125:
            markerTintColor = UIColor().customYellow
            detailLabel.textColor = UIColor().customWrittingYellow
        case 125..<250:
            markerTintColor = UIColor.orange
            detailLabel.textColor = UIColor.orange
        case 250...:
            markerTintColor = UIColor.red
            detailLabel.textColor = UIColor.red
        default:
            markerTintColor = UIColor.blue
        }
    }

    // Function that sets a color for the no2 parameter depending on a value.
    private func setNo2ColorAnnotation(detailLabel: UILabel, customAnnotation: CustomAnnotation) {
        switch customAnnotation.airValue {
        case ..<80:
            markerTintColor = UIColor().customGreen
            detailLabel.textColor = UIColor().customGreen
        case 80..<200:
            markerTintColor = UIColor().customYellow
            detailLabel.textColor = UIColor().customWrittingYellow
        case 200..<360:
            markerTintColor = UIColor.orange
            detailLabel.textColor = UIColor.orange
        case 360...:
            markerTintColor = UIColor.red
            detailLabel.textColor = UIColor.red
        default:
            markerTintColor = UIColor.blue
        }
    }

    // Function that set a color for the o3 parameter depending on a value.
    private func setO3ColorAnnotation(detailLabel: UILabel, customAnnotation: CustomAnnotation) {
        switch customAnnotation.airValue {
        case ..<100:
            markerTintColor = UIColor().customGreen
            detailLabel.textColor = UIColor().customGreen
        case 100..<160:
            markerTintColor = UIColor().customYellow
            detailLabel.textColor = UIColor().customWrittingYellow
        case 160..<220:
            markerTintColor = UIColor.orange
            detailLabel.textColor = UIColor.orange
        case 220...:
            markerTintColor = UIColor.red
            detailLabel.textColor = UIColor.red
        default:
            markerTintColor = UIColor.blue
        }
    }
}
