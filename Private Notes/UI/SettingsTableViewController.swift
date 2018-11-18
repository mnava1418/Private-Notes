//
//  SettingsTableViewController.swift
//  Private Notes
//
//  Created by Martin Nava Pe&a on 27/09/18.
//  Copyright © 2018 mnava. All rights reserved.
//

import UIKit
import LocalAuthentication

class SettingsTableViewController: UITableViewController {

    var biometryEnable = false
    var biometryType:LABiometryType = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context = LAContext()
        var error:NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            self.biometryEnable = true
            self.biometryType = context.biometryType
        } else {
            self.biometryEnable = false
            self.biometryType = LABiometryType.none
        }
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
        
        if self.biometryEnable {
            return 2
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Privacy"
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        var blockActive = false
        
        if let currBlockActive = UserDefaults.standard.value(forKey: "blockActive") as? Bool{
            blockActive = currBlockActive
        }
        
        if !blockActive && self.biometryEnable {
            if self.biometryType == LABiometryType.touchID {
                return "In order to enable Touch ID, passcode lock must be active."
            } else {
                return "In order to enable Face ID, passcode lock must be active."
            }
        } else {
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsViewCell

        cell.tableView = self
        var blockActive = false
        
        if let currBlockActive = UserDefaults.standard.value(forKey: "blockActive") as? Bool{
            blockActive = currBlockActive
        }
        
        if indexPath.row == 0 {
            cell.title.text = "Passcode Lock"
            cell.icon.image = UIImage(named: "block60")
            cell.isTouchId = false
            cell.switch.isOn = blockActive
        } else {
            var touchIDActive = false
            
            if let currTouchIDActive = UserDefaults.standard.value(forKey: "touchIDActive") as? Bool{
                touchIDActive = currTouchIDActive
            }
            
            if( self.biometryType == LABiometryType.faceID){
                cell.title.text = "Face ID"
                cell.icon.image = UIImage(named: "face60")
            } else {
                cell.title.text = "Touch ID"
                cell.icon.image = UIImage(named: "touch60")
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
