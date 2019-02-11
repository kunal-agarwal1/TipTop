//
//  ViewController.swift
//  TipTop
//
//  Created by Kunal Agarwal on 07/02/19.
//  Copyright © 2019 Kunal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var customTipLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var total2Label: UILabel!
    @IBOutlet weak var total3Label: UILabel!
    @IBOutlet weak var total4Label: UILabel!
    @IBOutlet weak var customTipField: UITextField!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    var currencySymbol: String = "$"
    
    let formatter = NumberFormatter()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let locale = Locale.current
        currencySymbol = locale.currencySymbol!
        
        billField.becomeFirstResponder()
        
        formatter.locale = locale
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        customTipField.isHidden = true
        customTipLabel.isHidden = true
        
        tipLabel.text = String(format: "%@%.2f", currencySymbol, 0)
        totalLabel.text = String(format: "%@%.2f", currencySymbol, 0)
        total2Label.text = String(format: "%@%.2f", currencySymbol, 0)
        total3Label.text = String(format: "%@%.2f", currencySymbol, 0)
        total4Label.text = String(format: "%@%.2f", currencySymbol, 0)
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //check for default tip
        let defaults = UserDefaults.standard

        if(defaults.object(forKey: "lastBillDate") != nil){
            let lastBillDate = defaults.object(forKey: "lastBillDate") as! Date
            let memoryTime = lastBillDate.addingTimeInterval(60.0)
            if(Date() < memoryTime){
                billField.text = defaults.string(forKey: "lastBill")
                calculateTip((Any).self)
            }
        }
        
        let tipPercentages = [15.0:0,18.0:1,20.0:2]
        if(defaults.object(forKey: "defaultTip") != nil){
            var check = false
            for (tips,type) in tipPercentages
            {
               // print("\(tips) + \(type)\n")
                if(defaults.double(forKey: "defaultTip") == tips)
                {
                    tipControl.selectedSegmentIndex = type
                    check = true
                }
            }
            if check
            {
                customTipField.isHidden = true
                customTipLabel.isHidden = true
            }
            else{
                customTipField.isHidden = false
                customTipLabel.isHidden = false
                customTipField.text = "\((defaults.double(forKey: "defaultTip")))"
                tipControl.selectedSegmentIndex = 3
            }
        }
    }
    @IBAction func calculateTip(_ sender: Any) {
        //get bill amount
        let bill = (Double)(billField.text!) ?? 0
        
        //remember bill amount
        let defaults = UserDefaults.standard
        defaults.set(billField.text!, forKey: "lastBill")
        defaults.set(Date(), forKey: "lastBillDate")
        defaults.synchronize()

        //calculate tip and total
        let tipPercentages = [0.15,0.18,0.2]
        var tip = 0.0
        if(tipControl.selectedSegmentIndex == 3){
            customTipField.isHidden = false
            customTipLabel.isHidden = false
            let custom = (Double)(customTipField.text!) ?? 0
            tip = bill * (custom/100)
        }
        else{
            customTipField.isHidden = true
            customTipLabel.isHidden = true
            tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        }
        
        var total = bill+tip
        
        
    //   print(formatter.string(from:NSNumber(value: tip))!)
        var millions = false, thousands = false
        var tipmillions = false, tipthousands = false

        if(total > 1000000)
        {
           millions = true
            total /= 1000000
        }
        else if(total > 10000)
        {
        thousands = true
            total /= 1000
        }
        
        if(tip > 1000000)
        {
            tipmillions = true
            tip /= 1000000
        }
        else if(tip > 10000)
        {
            tipthousands = true
            tip /= 1000
        }
        
        //update tip and total
        
        tipLabel.text = String(format: "%@%@", currencySymbol, formatter.string(from:NSNumber(value: tip))!) + (tipmillions ? "M" : tipthousands ? "K" : "")
        totalLabel.text = String(format: "%@%@", currencySymbol, formatter.string(from:NSNumber(value: total))!) + (millions ? "M" : thousands ? "K" : "")
        total2Label.text = String(format: "%@%@", currencySymbol, formatter.string(from:NSNumber(value: total/2))!) + (millions ? "M" : thousands ? "K" : "")
        total3Label.text = String(format: "%@%@", currencySymbol, formatter.string(from:NSNumber(value: total/3))!) + (millions ? "M" : thousands ? "K" : "")
        total4Label.text = String(format: "%@%@", currencySymbol, formatter.string(from:NSNumber(value: total/4))!) + (millions ? "M" : thousands ? "K" : "")

    }
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    

}

