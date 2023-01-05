import CoreLocation

class LocationManager: NSObject {
    private var manager: CLLocationManager?
    private var completion: ((String?) -> Void)?

    override init() {
        super.init()
    }

    func requestLocation(completion: @escaping (String?) -> Void) {
        self.completion = completion

        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
}

extension LocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Only handle location that is within the desired 10 meters
        if let location = locations.first(where: { $0.horizontalAccuracy <= manager.desiredAccuracy }) {
            manager.stopUpdatingLocation()
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                var postalCode: String?
                if error == nil {
                    if let placemark = placemarks?.first {
                        postalCode = placemark.postalCode
                    }
                }

                self.completion?(postalCode)
                self.completion = nil
                self.manager = nil
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager){
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied:
            print("Denied")
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("Restriced")
        @unknown default:
            print("Unexpected")
        }
    }
}
