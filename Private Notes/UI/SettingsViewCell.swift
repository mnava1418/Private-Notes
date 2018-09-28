//
//  SettingsViewCell.swift
//  Private Notes
//
//  Created by Martin Nava Pe&a on 27/09/18.
//  Copyright © 2018 mnava. All rights reserved.
//

import UIKit

class SettingsViewCell: UITableViewCell {

    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIImageView!
    var isTouchId = false
    var tableView:SettingsTableViewController? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func didSwitchSelected(_ sender: UISwitch) {
        
        if !self.isTouchId {
            let storyboard = UIStoryboard(name: "Key", bundle: nil)
            let passCodePage = storyboard.instantiateViewController(withIdentifier: "passCodeView") as! PassCodeViewController
            
            if sender.isOn {
                passCodePage.action = KeyUtils.Actions.new
            } else {
                passCodePage.action = KeyUtils.Actions.delete
            }
            
            self.window?.rootViewController = passCodePage
        } else {
            UserDefaults.standard.set(sender.isOn, forKey: "touchIDActive")
            self.tableView!.tableView.reloadData()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
