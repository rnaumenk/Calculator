//
//  ViewController.swift
//  MyCalculator
//
//  Created by Ruslan on 12/9/18.
//  Copyright © 2018 Ruslan Naumenko. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    private var numberOnScreen:Double = 0;
    private var numberInMemory:Double = 0;
    private var numIsGiven = 0;
    private var sign = ""
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func number(_ sender: UIButton) {
        
        print("\"" + String(sender.tag-1) + "\" " + "is pressed")
        
        numIsGiven = 1
        
        if label.text == "0" || label.text == "+" || label.text == "-" || label.text == "/" || label.text == "*" || sign == "="
        {
            if sign == "=" {
                sign = ""
            }
            label.text = String(sender.tag-1)
        }
        else
        {
            label.text = label.text! + String(sender.tag-1)
        }
        numberOnScreen = Double(label.text!)!
    }
    
    @IBAction func actions(_ sender: UIButton) {
        switch sender.tag {
        case 11:
            print("AC is pressed")
            numberOnScreen = 0
            numberInMemory = 0
            sign = ""
            label.text = "0"
            numIsGiven = 0
        case 12:
            print("NEG is pressed")
            if numberOnScreen != 0 {
                numberOnScreen = -numberOnScreen
            }
            label.text = String(numberOnScreen)
        case 13:
            print("\"+\" is pressed")
            do_action()
            numIsGiven = 0
            label.text = "+"
            sign = "+"
        case 14:
            print("\"*\" is pressed")
            do_action()
            numIsGiven = 0
            label.text = "*"
            sign = "*"
        case 15:
            print("\"-\" is pressed")
            do_action()
            numIsGiven = 0
            label.text = "-"
            sign = "-"
        case 16:
            print("\"/\" is pressed")
            do_action()
            numIsGiven = 0
            label.text = "/"
            sign = "/"
        case 17:
            print("\"=\" is pressed")
            do_action()
            if numberInMemory.isNaN == false && numberInMemory.isInfinite == false {
                label.text = String(numberInMemory)
            }
            else if numberInMemory.isInfinite == true {
                label.text = "Error"
            }
            else {
                label.text = "0.0"
            }
            numberInMemory = 0
            numberOnScreen = (label.text == "Error" ? 0 : Double(label.text!)!)
            sign = "="
        default:
            break
        }
    }
    
    private func do_action() {
        if sign == "-" {
            numberInMemory -= numberOnScreen
        }
        else if sign == "*" && numIsGiven == 1 {
            numberInMemory *= numberOnScreen
        }
        else if sign == "/" && numIsGiven == 1 {
            numberInMemory /= numberOnScreen
        }
        else {
            numberInMemory += numberOnScreen
        }
        numberOnScreen = 0
    }
    
}
