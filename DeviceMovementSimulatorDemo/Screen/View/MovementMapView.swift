//
//  MovementMapView.swift
//  DeviceMovementSimulatorDemo
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import UIKit
import MapKit

class MovementMapView: MKMapView {
    private let markerSize = CGSize(width: 20, height: 20)
    private var marker: PointAnnotation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
    }
    
    func show(position: CLLocationCoordinate2D, radius: Double) {
        if (marker == nil) {
            marker = PointAnnotation(image: UIImage(named: "target")?.resizeImageToSize(markerSize))
            addAnnotation(marker!)
        }
        
        let coordinateRegion = MKCoordinateRegion.init(center: position, latitudinalMeters: radius, longitudinalMeters: radius)
        setRegion(coordinateRegion, animated: true)
        marker?.coordinate = position
    }
}

extension MovementMapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let markerAnnotation: PointAnnotation? = annotation as? PointAnnotation
        if (markerAnnotation != nil) {
            return markerAnnotation?.annotationViewWith(annotation: annotation, mapView: self)
        }
        
        return nil
    }
}

extension UIImage {
    func resizeImageToSize(_ size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
