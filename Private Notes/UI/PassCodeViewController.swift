//
//  PassCodeViewController.swift
//  Private Notes
//
//  Created by Martin Nava Pe&a on 21/09/18.
//  Copyright © 2018 mnava. All rights reserved.
//

import UIKit
import AudioToolbox

extension UIImageView {
    func shake(){
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.5
        animation.values = [-15.0, 15.0, -10.0, 10.0, -8.0, 8.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

class PassCodeViewController: UIViewController {

    var passCode = ""
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    @IBOutlet weak var btn0: UIButton!
    
    @IBOutlet weak var passCode1: UIImageView!
    @IBOutlet weak var passCode2: UIImageView!
    @IBOutlet weak var passCode3: UIImageView!
    @IBOutlet weak var passCode4: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // AppUtility.lockOrientation(.all)
        AppUtility.lockOrientation(.portrait)
        self.btn1.setBackgroundImage(UIImage(named: "bordeRelleno60")!, for: .highlighted)
        self.btn1.setTitleColor(UIColor(named: "White"), for: .highlighted)
        self.btn2.setBackgroundImage(UIImage(named: "bordeRelleno60")!, for: .highlighted)
        self.btn2.setTitleColor(UIColor(named: "White"), for: .highlighted)
        self.btn3.setBackgroundImage(UIImage(named: "bordeRelleno60")!, for: .highlighted)
        self.btn3.setTitleColor(UIColor(named: "White"), for: .highlighted)
        self.btn4.setBackgroundImage(UIImage(named: "bordeRelleno60")!, for: .highlighted)
        self.btn4.setTitleColor(UIColor(named: "White"), for: .highlighted)
        self.btn5.setBackgroundImage(UIImage(named: "bordeRelleno60")!, for: .highlighted)
        self.btn5.setTitleColor(UIColor(named: "White"), for: .highlighted)
        self.btn6.setBackgroundImage(UIImage(named: "bordeRelleno60")!, for: .highlighted)
        self.btn6.setTitleColor(UIColor(named: "White"), for: .highlighted)
        self.btn7.setBackgroundImage(UIImage(named: "bordeRelleno60")!, for: .highlighted)
        self.btn7.setTitleColor(UIColor(named: "White"), for: .highlighted)
        self.btn8.setBackgroundImage(UIImage(named: "bordeRelleno60")!, for: .highlighted)
        self.btn8.setTitleColor(UIColor(named: "White"), for: .highlighted)
        self.btn9.setBackgroundImage(UIImage(named: "bordeRelleno60")!, for: .highlighted)
        self.btn9.setTitleColor(UIColor(named: "White"), for: .highlighted)
        self.btn0.setBackgroundImage(UIImage(named: "bordeRelleno60")!, for: .highlighted)
        self.btn0.setTitleColor(UIColor(named: "White"), for: .highlighted)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppUtility.lockOrientation(.all)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressBtn(_ sender: UIButton) {
        self.checkCode()
    }
    
    @IBAction func touchBtn(_ sender: UIButton) {
        self.passCode = self.passCode + sender.titleLabel!.text!
        
        switch self.passCode.count {
        case 1:
            self.passCode1.image = UIImage(named: "bordeRelleno60")
        case 2:
            self.passCode2.image = UIImage(named: "bordeRelleno60")
        case 3:
            self.passCode3.image = UIImage(named: "bordeRelleno60")
        case 4:
            self.passCode4.image = UIImage(named: "bordeRelleno60")
        default:
            return
        }
    }
    
    @IBAction func pressCancelBtn(_ sender: UIButton) {
        
        if self.passCode.count == 0 {
            return
        }
        
        self.passCode = String(self.passCode.dropLast(1))
        
        switch self.passCode.count {
        case 0:
            self.passCode1.image = UIImage(named: "borde60")
        case 1:
            self.passCode2.image = UIImage(named: "borde60")
        case 2:
            self.passCode3.image = UIImage(named: "borde60")
        case 3:
            self.passCode4.image = UIImage(named: "borde60")
        default:
            return
        }
    }
    
    func checkCode() {
        if self.passCode.count < 4 {
            return
        }
        
        if( self.passCode == "1418") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let foldersNavigationController = storyboard.instantiateViewController(withIdentifier: "MasterNavigationController") as! UINavigationController
            
            let controller = foldersNavigationController.topViewController as! FoldersTableViewController
            controller.managedObjectContext = appDelegate.persistentContainer.viewContext
            
            appDelegate.window?.rootViewController = foldersNavigationController
        } else {
            self.passCode = ""
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            self.passCode1.shake()
            self.passCode2.shake()
            self.passCode3.shake()
            self.passCode4.shake()
            
            self.passCode1.image = UIImage(named: "borde60")
            self.passCode2.image = UIImage(named: "borde60")
            self.passCode3.image = UIImage(named: "borde60")
            self.passCode4.image = UIImage(named: "borde60")
        }
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
