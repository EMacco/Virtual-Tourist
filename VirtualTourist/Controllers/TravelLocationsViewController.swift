//
//  TravelLocationsViewController.swift
//  VirtualTourist
//
//  Created by Emmanuel Okwara on 18/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import UIKit
import MapKit

class TravelLocationsViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var hintViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showHint()
        configureMapView()
    }
    
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
    
    func configureMapView() {
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        longPressRecogniser.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressRecogniser)
        
        if let region = Plist.shared.mapCameraState {
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state != .began { return }

        let touchPoint = sender.location(in: mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)

        let annotation = MKPointAnnotation()
        annotation.coordinate = touchMapCoordinate

        mapView.addAnnotation(annotation)
    }
    
    func updateCameraSavedZoom() {
        let region = mapView.region
        Plist.shared.mapCameraState = region
    }

}

extension TravelLocationsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        Plist.shared.mapCameraState = mapView.region
    }
}
