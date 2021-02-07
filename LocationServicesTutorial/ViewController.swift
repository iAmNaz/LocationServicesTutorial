//
//  ViewController.swift
//  LocationServicesTutorial
//
//  Created naz on 2/2/21.
//


import UIKit

class ViewController: UIViewController {
    let locationService = LocationService()
    private var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStatusLabel()
        initializeLocationServices()
    }
    
    private func setupStatusLabel() {
        statusLabel = UILabel(frame: .zero)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.font = .systemFont(ofSize: 24)
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .center
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func initializeLocationServices() {
        locationService.delegate = self
        
        let isEnabled = locationService.enabled
        
        guard isEnabled else {
            locationServicesNeededState()
            return
        }
        
        // start
        locationService.requestAuthorization()
    }
}

extension ViewController: LocationServiceDelegate {
    func authorizationUknown() {
        locationServicesNeededState()
    }
    
    func authorizationRestricted() {
        locationServicesRestrictedState()
    }
    
    func promptAuthorizationAction() {
        promptForAuthorization()
    }
    
    func didAuthorize() {
        locationService.start()
    }
}

extension ViewController {
    func promptForAuthorization() {
        let alert = UIAlertController(title: "Location access is needed to get your current location", message: "Please allow location access", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { [weak self] _ in
            self?.locationServicesNeededState()
        })

        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
              
        alert.preferredAction = settingsAction

        present(alert, animated: true, completion: nil)
    }
    
    func locationServicesNeededState() {
        self.statusLabel.text = "Access to location services is needed."
    }
    
    func locationServicesRestrictedState() {
        statusLabel.text = "The app is restricted from using the location services."
    }
}
