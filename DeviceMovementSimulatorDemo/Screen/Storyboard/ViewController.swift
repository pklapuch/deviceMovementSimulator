//
//  ViewController.swift
//  DeviceMovementSimulatorDemo
//
//  Created by Pawel Klapuch on 31/01/2019.
//  Copyright © 2019 Pawel Klapuch. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var simulationToggleButton: UIButton!
    @IBOutlet weak var dataView: MovementDataView!
    @IBOutlet weak var mapView: MovementMapView!

    let presenter = ViewPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.delegate = self
        refresh()
        
        let coordinate = CLLocationCoordinate2D(latitude: 49, longitude: 12)
        mapView.show(position: coordinate, radius: 2000)
    }
    
    private func refresh() {
        updateButtonState()
        dataView.location = presenter.currentLocation
        dataView.deviceMotion = presenter.currentDeviceMotion
        
        if let coordinate = presenter.currentLocation?.coordinate {
            mapView.show(position: coordinate, radius: 1000)
        }
    }
    
    @IBAction func simulationToggleButtonAction(_ sender: Any) {
        presenter.toggleSimulation()
    }
}

extension ViewController: ViewPresenterProtocol {
    func viewPresenterRefresh(_ presenter: ViewPresenter) {
        refresh()
    }
}

extension ViewController {
    private func updateButtonState() {
        if (presenter.isSimulating) {
            simulationToggleButton.setTitle("Stop Simulation", for: .normal)
            simulationToggleButton.backgroundColor = UIColor.green
        } else {
            simulationToggleButton.setTitle("Start Simulation", for: .normal)
            simulationToggleButton.backgroundColor = UIColor.brown
        }
    }
}
