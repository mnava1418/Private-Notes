//
//  SettingsTableViewController.swift
//  Private Notes
//
//  Created by Martin Nava Pe&a on 27/09/18.
//  Copyright © 2018 mnava. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    let titles = ["Passcode Lock", "Touch ID"]
    let images = ["block60", "touch60"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titles.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Privacy"
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "In order to enable Touch ID, passcode lock must be active."
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsViewCell

        cell.title.text = titles[indexPath.row]
        cell.icon.image = UIImage(named: images[indexPath.row])
        cell.tableView = self
        
        var blockActive = false
        
        if let currBlockActive = UserDefaults.standard.value(forKey: "blockActive") as? Bool{
            blockActive = currBlockActive
        }
        
        if indexPath.row == 0 {
            cell.isTouchId = false
            cell.switch.isOn = blockActive
        } else {
            var touchIDActive = false
            
            if let currTouchIDActive = UserDefaults.standard.value(forKey: "touchIDActive") as? Bool{
                touchIDActive = currTouchIDActive
            }
            
            cell.isTouchId = true
            cell.switch.isOn = touchIDActive
            cell.title.isEnabled = blockActive
            cell.switch.isEnabled = blockActive
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
