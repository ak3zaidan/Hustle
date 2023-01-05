import Foundation
import CoreLocation

class JobViewModel: ObservableObject{
    @Published var jobs = [Job]()
    @Published var zip = ""
    @Published var inDataBase: Bool = false
    @Published var showAlertAddZip: Bool = false
    @Published var noJobsNearYou: Bool = false
    @Published var menuGetLocationButton: String = ""
    let service = JobService()
    let userService = UserService()
    let manager = LocationManager()
    let geocoder = CLGeocoder()
    
    func getZipCode(completion: @escaping(String) -> Void){
        manager.requestLocation() { zipCode in
            if let zipCode {
                self.zip = zipCode
                completion(zipCode)
            } 
        }
    }
    
    func getJobs(withOption option: String){
        var jobsTotal: [Job] = []
        var jobsFinal: [Job] = []
        let valid = isValidZipCode(zip)
        if valid{
            geocoder.geocodeAddressString(zip) { (placemarks, error) in
                if let error = error {
                    print("Error finding location: \(error.localizedDescription)")
                }
                if let placemarks = placemarks, let placemark = placemarks.first {
                    let state = placemark.administrativeArea ?? "N/A"
                    let city = placemark.locality ?? "N/A"
                    
                    self.service.fetchJobs(withState: state) { jobs in
                        jobsTotal = jobs
                        
                        if option == "25 mile"{
                            for i in 0 ..< jobsTotal.count{
                                if jobsTotal[i].city == city{
                                    jobsFinal.append(jobsTotal[i])
                                }
                            }
                            for i in 0 ..< jobsTotal.count{
                                if jobsTotal[i].city != city{
                                    jobsFinal.append(jobsTotal[i])
                                }
                            }
                        } else if option == "100 mile" {
                            jobsFinal = jobsTotal
                        }

                        self.jobs = jobsFinal
                        for i in 0 ..< self.jobs.count {
                            
                            let uid = jobs[i].uid
                            self.userService.fetchUser(withUid: uid) { user in
                                self.jobs[i].user = user
                            }
                        }
                    }
                }
            }
        }
    }
    func getRemoteJobs(){
        service.fetchRemoteJobs { jobs in
            self.jobs = jobs
            
            for i in 0 ..< jobs.count {

                let uid = jobs[i].uid
                self.userService.fetchUser(withUid: uid) { user in
                    self.jobs[i].user = user
                }
            }
        }
    }
    func getZipFromDataBase(){
        service.getZipFromDataBase { zipCode in
            self.zip = zipCode
        }
    }
    func uploadZipToDatabase(withZip zipCode: String){
        service.uploadZipToDatabase(forZip: zipCode)
    }
    func checkIfZipInDatabase(){
        service.checkIfZipInDatabase { value in
            self.inDataBase = value
        }
    }
    func isValidZipCode(_ zipCode: String) -> Bool {
        let zipCodePattern = "^\\d{5}(-\\d{4})?$"
        let zipCodeRegex = try! NSRegularExpression(pattern: zipCodePattern)
        let range = NSRange(location: 0, length: zipCode.utf16.count)
        return zipCodeRegex.firstMatch(in: zipCode, options: [], range: range) != nil
    }
}

