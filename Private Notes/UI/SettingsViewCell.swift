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
        var key = "blockActive"
        
        if self.isTouchId {
                key = "touchIDActive"
        }
        
        UserDefaults.standard.set(sender.isOn, forKey: key)
        self.tableView!.tableView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
