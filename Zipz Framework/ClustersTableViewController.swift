//
//  ClustersTableViewController.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 05/04/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import UIKit

class ClustersTableViewController: UITableViewController
{
    var clusters: [Cluster]? = Cluster.all()
    
    // MARK: - View Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getClusters()
    }

    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return clusters?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        if let cluster = clusters?[indexPath.row] {
            cell.textLabel?.text = "\(cluster.name) - \(cluster.city?.name ?? "NO CITY NAME")"
            
            if let imageView = cell.viewWithTag(1) as? UIImageView, let data = cluster.image {
                
                imageView.image = UIImage(data:data)
            }
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let cluster = clusters?[indexPath.row] {
            self.performSegue(withIdentifier: "ShowClusterDetails", sender: cluster)
        }
    }
    
    // MARK: - Prepare For Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "ClusterDetailsViewController") as? ClusterDetailsViewController,
           let cluster = sender as? Cluster {
            detailsViewController.uuid = cluster.uuid
        }
    }
    
    // MARK: - Private
    private func getClusters()
    {
        ZipzClusters().all { clusters, error in
            
            guard let clusters = clusters, clusters.count > 0 else {
                
                debugLog("NO NEW CLUSTERS: \(String(describing: error))")
                self.clusters = Cluster.all()
                self.tableView.reloadData()
                return
            }
            
            self.clusters = clusters
            self.tableView.reloadData()
        }
    }
}
