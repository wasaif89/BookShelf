//
//  Location.swift
//  BookShelf
//
//  Created by Abu FaisaL on 14/06/1443 AH.
//
//
//import Foundation
//
//@IBAction func findMyLocation(sender: AnyObject) {
//
//}
//class ViewController: UIViewController, CLLocationManagerDelegate {
//Define a constant for CLLocationManager after the class declaration.
//
//let locationManager = CLLocationManager()
//Navigate to IBAction function findMyLocation and add the following code
//
//locationManager.delegate = self
//locationManager.desiredAccuracy = kCLLocationAccuracyBest
//locationManager.requestWhenInUseAuthorization()
//locationManager.startUpdatingLocation()
//The above lines sets the class as delegate for locationManager, specifies the location accuracy and starts receiving location updates from CoreLocation. In order to get the location updates we need to implement the delegate functions of CLLocationManager, didUpdateLocations and didFailWithError
//
//func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//}
//
//    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
//    }
//    didUpdateLocations function is triggered when new location updates are available. Similarly didFailWithError is called when there is a problem receiving the location updates. Let us first start implementing the simpler one i.e didFailWithError function. When there is an error, we are going to log the message to the console.
//
//    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
//        println("Error while updating location " + error.localizedDescription)
//    }
//    Then update didUpdateLocations function with the following code, also add a new function for printing the location details.
//
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//    CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
//            if error {
//                println("Reverse geocoder failed with error" + error.localizedDescription)
//                return
//            }
//
//            if placemarks.count > 0 {
//                let pm = placemarks[0] as CLPlacemark
//                self.displayLocationInfo(pm)
//            } else {
//                println("Problem with the data received from geocoder")
//            }
//        })
//    }
//        func displayLocationInfo(placemark: CLPlacemark) {
//            if placemark != nil {
//                //stop updating location to save battery life
//                locationManager.stopUpdatingLocation()
//                println(placemark.locality ? placemark.locality : "")
//                println(placemark.postalCode ? placemark.postalCode : "")
//                println(placemark.administrativeArea ? placemark.administrativeArea : "")
//                println(placemark.country ? placemark.country : "")
//            }
//        }
//        }
