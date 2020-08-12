//
//  PermissionViewController.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 05/04/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class PermissionViewController: UIViewController
{
    // MARK: - View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        debugLog("Authorized User: \(String(describing: User.authorized()))")
    }

    // MARK: - IBAction
    @IBAction func alowCameraAction(_ sender: Any)
    {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                // do something
                return
            
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        // do something
                    }
                }
            
            case .denied: // The user has previously denied access.
                return

            case .restricted: // The user can't grant access due to restrictions.
                return
        @unknown default:
            fatalError("unknown error for camera permission")
        }
    }
    
    @IBAction func allowLocationAction(_ sender: Any)
    {
        let locationManager = CLLocationManager()
        let status = CLLocationManager.authorizationStatus()

            switch status {

            case .notDetermined:
                    locationManager.requestAlwaysAuthorization()
                    return

            case .denied, .restricted:
                let alert = UIAlertController(title: "Location Services disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)

                present(alert, animated: true, completion: nil)
                return
            case .authorizedAlways, .authorizedWhenInUse:
                break

            @unknown default:
                fatalError("Unknown error for camera permission")
        }
    }
}
