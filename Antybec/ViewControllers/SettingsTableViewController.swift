//
//  SettingsTableViewController.swift
//  Antybec
//
//  Created by Wiktor Biruk on 09/04/2019.
//  Copyright © 2019 Wiktor Biruk. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
