//
//  ClusterDetailsViewController.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 15/07/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import UIKit

class ClusterDetailsViewController: UIViewController
{
    // MARK: - IBOutlet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    // MARK: - Properties
    var uuid: String? {
        didSet {
            if let uuid = uuid {
                self.getDetails(uuid)
            }
        }
    }
    
    // MARK: - ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Private
    private func getDetails(_ uuid: String)
    {
        ZipzClusters().get(for: uuid) { cluster, error in
            DispatchQueue.main.async {
                self.nameLabel?.text = cluster?.name
                self.infoLabel?.text = cluster?.info
            }
            debugLog("CLUSTER: \(String(describing: cluster))")
        }
    }
}
