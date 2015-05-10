//
//  ViewController.swift
//  Calculator
//
//  Created by Mads Bielefeldt on 22/04/15.
//  Copyright (c) 2015 GN ReSound. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var displayLabel: UILabel!
    
    var userIsInTheMiddleOfTypingNumber = false
    
    var calculatorBrain = CalculatorBrain()
    
    @IBAction func digitButton(sender: UIButton)
    {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingNumber
        {
            displayLabel.text = displayLabel.text! + digit
        }
        else
        {
            displayLabel.text = digit
            userIsInTheMiddleOfTypingNumber = true
        }
    }
    
    @IBAction func enterButton()
    {
        userIsInTheMiddleOfTypingNumber = false
        if let result = calculatorBrain.pushOperand(displayValue)
        {
            displayValue = result
        }
        else
        {
            displayValue = 0
        }
    }
    
    @IBAction func clearButton()
    {
        userIsInTheMiddleOfTypingNumber = false
        if let result = calculatorBrain.reset()
        {
            displayValue = result
        }
        else
        {
            displayValue = 0;
        }
    }
    
    @IBAction func operatorButton(sender: UIButton)
    {
        if userIsInTheMiddleOfTypingNumber
        {
            enterButton()
        }
        
        if let operation = sender.currentTitle
        {
            if let result = calculatorBrain.performOperation(operation)
            {
                displayValue = result
            }
            else
            {
                displayValue = 0
            }
        }
    }
    
    var displayValue: Double
    {
        get {
            return NSNumberFormatter().numberFromString(displayLabel.text!)!.doubleValue
        }
        set {
            displayLabel.text = "\(newValue)"
            userIsInTheMiddleOfTypingNumber = false
        }
    }
}

