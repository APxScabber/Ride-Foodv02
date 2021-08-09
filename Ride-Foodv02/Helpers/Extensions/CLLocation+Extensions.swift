import Foundation
import CoreLocation


extension CLLocation {
    
    func findAddress(_ completion:@escaping ((String) -> ()) ) {
        DispatchQueue.global(qos: .userInitiated).async {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(self) { placemarks, Error in
                if let foundPlacemark = placemarks?.first {
                    DispatchQueue.main.async {
                        completion(foundPlacemark.name ?? "")
                    }
                }
            }
        }
    }
    
}
