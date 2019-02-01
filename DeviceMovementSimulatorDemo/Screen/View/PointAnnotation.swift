//
//  PointAnnotation.swift
//  DeviceMovementSimulatorDemo
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import UIKit
import MapKit

class PointAnnotation: MKPointAnnotation {
    var image: UIImage?
    
    init(image: UIImage?) {
        self.image = image
    }
    
    func annotationViewWith(annotation: MKAnnotation, mapView: MKMapView) -> MKAnnotationView {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if (annotationView == nil) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView!.annotation = annotation
        }
        
        annotationView!.image = image
        return annotationView!
    }
    
    var identifier: String {
        get {
            return String(describing: self)
        }
    }
}
