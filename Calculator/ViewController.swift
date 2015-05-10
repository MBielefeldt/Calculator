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
    
    var operandStack = Array<Double>()
    
    @IBAction func enterButton()
    {
        userIsInTheMiddleOfTypingNumber = false
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
    }
    
    @IBAction func clearButton()
    {
        displayValue = 0;
        userIsInTheMiddleOfTypingNumber = false
        operandStack.removeAll()
        println("operandStack = \(operandStack)")
    }
    
    private func performOperation(operationFunc: (Double, Double) -> Double)
    {
        let operand2 = operandStack.removeLast()
        let operand1 = operandStack.removeLast()
        displayValue = operationFunc(operand1, operand2)
        enterButton()
    }
    
    private func performOperation(operationFunc: Double -> Double)
    {
        let operand = operandStack.removeLast()
        displayValue = operationFunc(operand)
        enterButton()
    }
    
//    func multiply(operand1: Double, operand2: Double) -> Double
//    {
//        return operand1 * operand2
//    }
    
    @IBAction func operatorButton(sender: UIButton)
    {
        if userIsInTheMiddleOfTypingNumber
        {
            enterButton()
        }
        
        let oper = sender.currentTitle!
        
        switch oper {
//            case "×" : performOperation(multiply)
//            case "×" : performOperation({ (operand1: Double, operand2: Double) -> Double in
//                                            return operand1 * operand2
//                                        })
//            case "×" : performOperation({ (operand1, operand2) in return operand1 * operand2 })
//            case "×" : performOperation({ (operand1, operand2) in operand1 * operand2 })
//            case "×" : performOperation({ $0 * $1 })
//            case "×" : performOperation() { $0 * $1 }
            case "×" : performOperation { $0 * $1 }
            case "÷" : performOperation { $0 / $1 }
            case "+" : performOperation { $0 + $1 }
            case "−" : performOperation { $0 - $1 }
            case "√" : performOperation { sqrt($0) }
            default  : break
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

