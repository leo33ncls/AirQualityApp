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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // ====================
    // MARK: - View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        countryPickerView.dataSource = self
        countryPickerView.delegate = self

        parametersView.isHidden = true
        activityIndicator.isHidden = false
        
        UserDefaults.standard.register(defaults: [ParametersService.Keys.countryIndex: 78])

        mapView.register(CustomAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier:
                         MKMapViewDefaultAnnotationViewReuseIdentifier)

        setUpParameters()
        getAirQualityValues(country: ParametersService.country,
                            parameter: ParametersService.airParameter)
    }

    // =====================
    // MARK: - View Functions

    // Function that sets up the good parameters saved in the UserDefaults.
    private func setUpParameters() {
        parametersSegmentedControl.selectedSegmentIndex = ParametersService.airParameterIndex
        countryPickerView.selectRow(ParametersService.countryIndex,
                                    inComponent: 0, animated: true)
    }

    // Function that gets the air quality values from the API.
    private func getAirQualityValues(country: String, parameter: String) {
        refreshButton.isEnabled = false
        parametersButton.isEnabled = false
        AirQualityService(session: URLSession(configuration: .default))
            .getAirQualityValue(for: country, parameter: parameter) { (success, airQuality) in
                self.activityIndicator.isHidden = true
                self.refreshButton.isEnabled = true
                self.parametersButton.isEnabled = true
                
                guard success, let airQuality = airQuality,
                      !airQuality.results.isEmpty else {
                    self.noValuesAlert()
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

    // Function that saves the parameters choiced by the user.
    private func saveParameters() {
        let isoCountryCodeIndex = countryPickerView.selectedRow(inComponent: 0)
        let isoCountryCode = NSLocale.isoCountryCodes[isoCountryCodeIndex]
        ParametersService.countryIndex = isoCountryCodeIndex
        ParametersService.country = isoCountryCode

        switch parametersSegmentedControl.selectedSegmentIndex {
        case 0:
            ParametersService.airParameter = "pm25"
            ParametersService.airParameterIndex = 0
        case 1:
            ParametersService.airParameter = "pm10"
            ParametersService.airParameterIndex = 1
        case 2:
            ParametersService.airParameter = "so2"
            ParametersService.airParameterIndex = 2
        case 3:
            ParametersService.airParameter = "no2"
            ParametersService.airParameterIndex = 3
        case 4:
            ParametersService.airParameter = "o3"
            ParametersService.airParameterIndex = 4
        case 5:
            ParametersService.airParameter = "co"
            ParametersService.airParameterIndex = 5
        default:
            break
        }
    }

    // =====================
    // MARK: - Alert
    private func noValuesAlert() {
        let alert = UIAlertController(title: "Sorry!",
                                        message: "No values for this country!",
                                        preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    // =====================
    // MARK: - Map View Actions

    // Action that refreshes the air quality values for a country.
    @IBAction func refreshValues(_ sender: UIButton) {
        activityIndicator.isHidden = false
        getAirQualityValues(country: ParametersService.country,
                            parameter: ParametersService.airParameter)
    }

    // Action that shows the parametersView.
    @IBAction func showParametersView(_ sender: UIButton) {
        setUpParameters()
        refreshButton.isEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            self.parametersView.isHidden = false
            self.parametersView.transform = .identity
        }, completion: nil)
    }

    // =====================
    // MARK: - Parameters View Actions

    // Action that hides the parametersView.
    @IBAction func hideParametersView(_ sender: UIButton) {
        refreshButton.isEnabled = true
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
        if parametersSegmentedControl.selectedSegmentIndex == ParametersService.airParameterIndex
            && countryPickerView.selectedRow(inComponent: 0) == ParametersService.countryIndex {
            parametersView.isHidden = true
        } else {
            activityIndicator.isHidden = false
            saveParameters()
            mapView.removeAnnotations(mapView.annotations)
            getAirQualityValues(country: ParametersService.country,
                                parameter: ParametersService.airParameter)
            parametersView.isHidden = true
        }
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
        let isoCountryCode = NSLocale.isoCountryCodes[row]
        guard let countryName = Locale.current.localizedString(forRegionCode: isoCountryCode) else {
            return isoCountryCode
        }
        return isoCountryCode + ", " + countryName
    }
}
