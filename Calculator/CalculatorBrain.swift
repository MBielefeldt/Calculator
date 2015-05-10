//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Mads Bielefeldt on 10/05/15.
//  Copyright (c) 2015 GN ReSound. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op : Printable
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String
        {
            get {
                switch self {
                    case .Operand(let operand):
                        return "\(operand)"
                    case .UnaryOperation(let symbol, _):
                        return symbol
                    case .BinaryOperation(let symbol, _):
                        return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    init()
    {
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        knownOps["√"] = Op.UnaryOperation ("√", sqrt)
    }
    
    func reset() -> Double?
    {
        opStack.removeAll()
        return evaluate()
    }
    
    func pushOperand(operand: Double) -> Double?
    {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double?
    {
        if let operation = knownOps[symbol]
        {
            opStack.append(operation)
        }
        
        return evaluate()
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty
        {
            var remainingOps = ops
            
            let op = remainingOps.removeLast()
            
            switch op {
                case .Operand(let operand):
                    return(operand, remainingOps)
                case .UnaryOperation(_, let operation):
                    let operandEvaluation = evaluate(remainingOps)
                    if let operand = operandEvaluation.result
                    {
                        return(operation(operand), operandEvaluation.remainingOps)
                    }
                case .BinaryOperation(_, let operation):
                    let operand1Evaluation = evaluate(remainingOps)
                    if let operand1 = operand1Evaluation.result
                    {
                        let operand2Evaluation = evaluate(operand1Evaluation.remainingOps)
                        if let operand2 = operand2Evaluation.result
                        {
                            return(operation(operand1, operand2), operand2Evaluation.remainingOps)
                        }
                    }
            }
        }
        
        return (nil, ops)
    }
    
    func evaluate() -> Double?
    {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
}
