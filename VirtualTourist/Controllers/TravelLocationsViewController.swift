//
//  TravelLocationsViewController.swift
//  VirtualTourist
//
//  Created by Emmanuel Okwara on 18/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TravelLocationsViewController: UIViewController, TravelMapViewDelegate {
    
    var pins =  [Pin]()
    var dataController: DataController! = DataController.shared
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var hintViewHeightConstraint: NSLayoutConstraint!
    var currentAnnotation: PinAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        fetchPins()
        configureMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mapView.deselectAnnotation(currentAnnotation, animated: true)
    }
    
    func fetchPins() {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            pins = result
        }
        
        if pins.count == 0 {
            showHint()
        }
    }
    
    // MARK:- Show/Hide Usage Hint methods
    func showHint() {
        UIView.animate(withDuration: 0.6, animations: {
            self.hintViewHeightConstraint.constant = 100
            self.view.layoutIfNeeded()
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.hideHint()
        }
    }
    
    func hideHint() {
        UIView.animate(withDuration: 0.6) {
            self.hintViewHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK:- Map Pin Configuration Methods
    func configureMapView() {
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        longPressRecogniser.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressRecogniser)
        
        if let region = Plist.shared.mapCameraState {
            mapView.setRegion(region, animated: true)
        }
        
        for pin in pins {
            addAnnotation(to: pin)
        }
        
    }
    
    func deletePin(_ pin: Pin) {
        let pinAnnotations = mapView.annotations.filter { $0.coordinate.latitude == pin.latitude && $0.coordinate.longitude == pin.longitude }
        mapView.removeAnnotations(pinAnnotations)
    }
    
    func addAnnotation(to pin: Pin) {
        let annotation = PinAnnotation(to: pin)
        self.mapView.addAnnotation(annotation)
    }
    
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state != .began { return }
        
        let touchPoint = sender.location(in: mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        fetchAddressNameFrom(location: touchMapCoordinate) { [weak self] address in
            if let pin = CoreDataHelper.addPin(to: touchMapCoordinate, title: address) {
                self?.addAnnotation(to: pin)
            }
        }
    }
    
    func updateCameraSavedZoom() {
        let region = mapView.region
        Plist.shared.mapCameraState = region
    }
    
}

// MARK:- MapKit Extension
extension TravelLocationsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        Plist.shared.mapCameraState = mapView.region
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let currentAnnotation = view.annotation as? PinAnnotation else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let controller = self.storyboard?.instantiateViewController(identifier: "photoAlbumVC") as! PhotoAlbumViewController
            controller.region = mapView.region
            controller.pin = currentAnnotation.pin
            controller.travelMapDelegate = self
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView
        
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            pinView!.canShowCallout = false
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func fetchAddressNameFrom(location: CLLocationCoordinate2D, completionHandler: @escaping(String?) -> Void) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            completionHandler(placemarks?.first?.name)
        }
    }
    
}
