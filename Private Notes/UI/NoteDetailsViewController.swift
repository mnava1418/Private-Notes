//
//  NoteDetailsViewController.swift
//  Private Notes
//
//  Created by Martin Nava Pe&a on 26/04/18.
//  Copyright © 2018 mnava. All rights reserved.
//

import UIKit

class NoteDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let mainViewController = appDelegate.window?.rootViewController as! UISplitViewController
        self.navigationItem.rightBarButtonItem = mainViewController.displayModeButtonItem
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
