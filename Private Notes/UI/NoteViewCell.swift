//
//  NoteViewCell.swift
//  Private Notes
//
//  Created by Martin Nava Pe&a on 01/09/18.
//  Copyright © 2018 mnava. All rights reserved.
//

import UIKit

class NoteViewCell: UITableViewCell {

    @IBOutlet weak var note: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
