//
//  MapViewController.swift
//  AirQualityApp
//
//  Created by Léo NICOLAS on 09/12/2020.
//

import UIKit
import MapKit

// View Controller that displays the map.
class MapViewController: UIViewController {

    // MARK: - View Outlet
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var parametersButton: UIButton!
    @IBOutlet weak var parametersView: UIView!
    @IBOutlet weak var mapModeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var parametersSegmentedControl: UISegmentedControl!
    @IBOutlet weak var countryPickerView: UIPickerView!

    // ====================
    // MARK: - View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        countryPickerView.dataSource = self
        countryPickerView.delegate = self
        parametersView.isHidden = true
        mapView.register(CustomAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier:
                         MKMapViewDefaultAnnotationViewReuseIdentifier)

        setUpParameters()
        checkParametersAndGetValues()
    }
    
    // =====================
    // MARK: - View Functions

    // Function that sets up the good parameters saved in the UserDefaults.
    private func setUpParameters() {
        if let parameterIndex = UserDefaults.standard.object(forKey: "airParameterIndex") as? Int {
            parametersSegmentedControl.selectedSegmentIndex = parameterIndex
        } else {
            parametersSegmentedControl.selectedSegmentIndex = 0
        }
        
        if let countryIndex = UserDefaults.standard.object(forKey: "countryIndex") as? Int {
            countryPickerView.selectRow(countryIndex, inComponent: 0, animated: true)
        } else {
            countryPickerView.selectRow(78, inComponent: 0, animated: true)
        }
    }
    
    // Function that checkes if the parameters for the API are correct.
    private func checkParametersAndGetValues() {
        if let parameter = UserDefaults.standard.object(forKey: "airParameter") as? String,
           let country = UserDefaults.standard.object(forKey: "country") as? String {
            getAirQualityValues(country: country, parameter: parameter)
        } else if let parameter = UserDefaults.standard.object(forKey: "airParameter") as? String {
            getAirQualityValues(country: "FR", parameter: parameter)
        } else if let country = UserDefaults.standard.object(forKey: "country") as? String {
            getAirQualityValues(country: country, parameter: "pm25")
        } else {
            getAirQualityValues(country: "FR", parameter: "pm25")
        }
    }
    
    // Function that gets the air quality values from the API.
    private func getAirQualityValues(country: String, parameter: String) {
        AirQualityService(session: URLSession(configuration: .default))
            .getAirQualityValue(for: country, parameter: parameter) { (success, airQuality) in
                guard success, let airQuality = airQuality else {
                    return
                }
                self.setMarkers(airQualityList: airQuality)
            }
    }
    
    // Function that adds annotations with air quality values to the map.
    private func setMarkers(airQualityList: AirQualityList) {
        var annotations = [CustomAnnotation]()
        for location in airQualityList.results {
            let annotation = CustomAnnotation(locationResult: location)
            self.mapView.addAnnotation(annotation)
            annotations.append(annotation)
        }
        mapView.showAnnotations(annotations, animated: true)
    }

    // =====================
    // MARK: - Map View Actions

    // Action that refreshes the air quality values for a country.
    @IBAction func refreshValues(_ sender: UIButton) {
        checkParametersAndGetValues()
    }

    // Action that shows the parametersView.
    @IBAction func showParametersView(_ sender: UIButton) {
        setUpParameters()
        UIView.animate(withDuration: 0.3, animations: {
            self.parametersView.isHidden = false
            self.parametersView.transform = .identity
        }, completion: nil)
    }

    // =====================
    // MARK: - Parameters View Actions

    // Action that hides the parametersView.
    @IBAction func hideParametersView(_ sender: UIButton) {
        parametersView.isHidden = true
    }

    // Action that changes the map mod.
    @IBAction func mapModeAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: mapView.mapType = .standard
        case 1: mapView.mapType = .satellite
        case 2: mapView.mapType = .hybrid
        default: break
        }
    }

    // Action that saves the parameters choiced by the user and make a new call for the API.
    @IBAction func validateParameters(_ sender: UIButton) {
        let isoCountryCodeIndex = countryPickerView.selectedRow(inComponent: 0)
        let isoCountryCode = NSLocale.isoCountryCodes[isoCountryCodeIndex]
        UserDefaults.standard.set(isoCountryCode, forKey: "country")
        UserDefaults.standard.setValue(isoCountryCodeIndex, forKey: "countryIndex")

        switch parametersSegmentedControl.selectedSegmentIndex {
        case 0: UserDefaults.standard.set("pm25", forKey: "airParameter")
            UserDefaults.standard.set(0, forKey: "airParameterIndex")
        case 1: UserDefaults.standard.set("pm10", forKey: "airParameter")
            UserDefaults.standard.set(1, forKey: "airParameterIndex")
        case 2: UserDefaults.standard.set("so2", forKey: "airParameter")
            UserDefaults.standard.set(2, forKey: "airParameterIndex")
        case 3: UserDefaults.standard.set("no2", forKey: "airParameter")
            UserDefaults.standard.set(3, forKey: "airParameterIndex")
        case 4: UserDefaults.standard.set("o3", forKey: "airParameter")
            UserDefaults.standard.set(4, forKey: "airParameterIndex")
        case 5: UserDefaults.standard.set("co", forKey: "airParameter")
            UserDefaults.standard.set(5, forKey: "airParameterIndex")
        default:
            break
        }
        mapView.removeAnnotations(mapView.annotations)
        checkParametersAndGetValues()
        parametersView.isHidden = true
    }
}

// MARK: - CountryPickerView
extension MapViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return NSLocale.isoCountryCodes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return NSLocale.isoCountryCodes[row]
    }
}
