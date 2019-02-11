//
//  SettingsViewController.swift
//  TipTop
//
//  Created by Kunal Agarwal on 07/02/19.
//  Copyright © 2019 Kunal. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var defaultTipField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        defaultTipField.becomeFirstResponder()
        
        let defaults = UserDefaults.standard
        if(defaults.object(forKey: "defaultTip") != nil){
            defaultTipField.text = "\((defaults.double(forKey: "defaultTip")))"
        }
    }
    
    @IBAction func defaultTipChange(_ sender: Any) {
        let defaults = UserDefaults.standard
        let defaultTipPer = (Double)(defaultTipField.text!) ?? 0
        defaults.set(defaultTipPer, forKey: "defaultTip")
        defaults.synchronize()

    }
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
}
