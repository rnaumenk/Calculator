//
//  ViewController.swift
//  MyCalculator
//
//  Created by Ruslan on 12/9/18.
//  Copyright © 2018 Ruslan Naumenko. All rights reserved.
//

import UIKit

class CalculatorVC: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet var zeroBtn: [UIButton]!
    
    private var numberInMemory:Double = 0
    private var numIsGiven: Bool = false
    private var isManuallyEditing = true
    private var signInMemory = ""
    private var lastOperation: (String, Double) = ("", 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        zeroBtn[1].addTarget(self, action: #selector(pressZero), for: .touchDown)
        zeroBtn[1].addTarget(self, action: #selector(releaseZero), for: .touchUpInside)
        
        cancelBtn.titleLabel?.textAlignment = .center
        label.addObserver(self, forKeyPath: "text", options: [.new], context: nil)
    }
    
    @objc func pressZero() {
        zeroBtn[0].isHighlighted = true
    }
    
    @objc func releaseZero() {
        zeroBtn[0].isHighlighted = false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "text" {
            if !isManuallyEditing {
                var newText = String(describing: change?[.newKey]).components(separatedBy: "(")[1]
                
                if newText.components(separatedBy: ".").count > 1 && Double(newText.components(separatedBy: ".")[1].components(separatedBy: ")")[0]) == 0 {
                    newText = newText.components(separatedBy: ".")[0]
                    
                    label.text = newText
                }
            }
            
            if label.text == "-0" {
                label.text = "0"
            }
            cancelBtn.setTitle(label.text == "0" ? "AC" : "C", for: .normal)
        }
    }
    
    @IBAction func numberBtn(_ sender: UIButton) {
        let numberChar = sender.tag == 10 ? "." : String(sender.tag)
        
        print(numberChar)
        
        if numberChar == "." {
            guard !(label.text?.contains("."))! else {return}
            if !numIsGiven {
                label.text = "0."
            } else {
                label.text = label.text! + numberChar
            }
            numIsGiven = true
        } else if !numIsGiven {
            label.text = numberChar
            numIsGiven = numberChar == "0" ? false : true
        } else {
            label.text = label.text! + numberChar
        }
        
    }
    
    private func doAction (_ secondOperand: Double) {
        let rememberNumberInMemory = numberInMemory
        
        isManuallyEditing = false
        if signInMemory != "" {
            switch signInMemory {
            case "+":
                numberInMemory += secondOperand
            case "-":
                numberInMemory -= secondOperand
            case "×":
                numberInMemory *= secondOperand
            case "÷":
                numberInMemory /= secondOperand
            default:
                break
            }
            guard !numberInMemory.isNaN && !numberInMemory.isInfinite else {
                label.text = "Not a number"
                numberInMemory = rememberNumberInMemory
                return
            }
            label.text = String(numberInMemory)
        } else if numIsGiven {
            numberInMemory = secondOperand
        }
        lastOperation = (signInMemory, secondOperand)
        isManuallyEditing = true
    }
    
    @IBAction func cmdBtn(_ sender: UIButton) {
        if let cmdChar = sender.titleLabel?.text {
            print(cmdChar)
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.label.alpha = 0.2
        }, completion: { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                self.label.alpha = 1.0
            })
        })
        
        if label.text == "Not a number" {
            label.text = "0"
        }
        
        switch sender.tag {
        case 11:
            if sender.titleLabel?.text == "C" {
                label.text = "0"
                numIsGiven = false
            } else {
                numberInMemory = 0
                signInMemory = ""
            }
        case 12:
            isManuallyEditing = false
            label.text = String(Double(label.text!)! * -1)
            numberInMemory *= numIsGiven ? 1 : -1
            isManuallyEditing = true
        case 13:
            isManuallyEditing = false
            if signInMemory == "" {
                label.text = String(Double(label.text!)! * 0.01)
            } else {
                label.text = String(numberInMemory * Double(label.text!)! * 0.01)
            }
            isManuallyEditing = true
        case 14, 15, 16, 17:
            if numIsGiven {
                doAction(Double(label.text!)!)
            }
            signInMemory = (sender.titleLabel?.text)!
            numIsGiven = false
        default:
            guard let input = Double(label.text!) else {break}
            if signInMemory == "" {
                numberInMemory = input
                signInMemory = lastOperation.0
                doAction(lastOperation.1)
            }
            else {
                doAction(input)
            }
            signInMemory = ""
            numIsGiven = false
        }
    }
    
}
