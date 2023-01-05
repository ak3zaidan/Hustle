import CoreLocation
import Foundation

class UploadJobViewModel: ObservableObject{
    @Published var didUploadJob = false
    let service = JobService()
    
    func uploadJob(withCaption caption: String, withZipCode zipCode: String, withJobImageUrl jobImageUrl: String, withPrice price: String, withState state: String, withRemote remote: Bool){
        
        if remote == true{
            let city = ""
            self.service.uploadJob(caption: caption, city: city, jobImageUrl: jobImageUrl, price: price, state: state, remote: remote) { success in
                if success{
                    self.didUploadJob = true
                }
            }
        } else {
            CLGeocoder().geocodeAddressString(zipCode) { (placemarks, error) in
                guard let placemarks = placemarks, let placemark = placemarks.first, error == nil else {
                    print("Error getting placemarks: \(error?.localizedDescription ?? "unknown error")")
                    return
                }
                
                guard let city = placemark.locality else {
                    print("Error getting city: city not found in placemark")
                    return
                }
                self.service.uploadJob(caption: caption, city: city, jobImageUrl: jobImageUrl, price: price, state: state, remote: remote) { success in
                    if success{
                        self.didUploadJob = true
                    }
                }
            }
        }
    }
}
