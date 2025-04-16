//
//  ViewController.swift
//  Calculator
//
//  Created by Mehmet Ali Özdemir on 15.04.2025.
//

import UIKit

//MARK: - Numbers
enum Numbers: Int {
    case zero = 0, one, two, three, four, five, six, seven, eight, nine
    
    var stringValue: String {
        return "\(self.rawValue)"
    }
}

//MARK: - Operators
enum Operators: Int {
    case clear = 10, plusMinus, percent, divide, multiply, minus, plus, equals, comma
        
    func calculate(_ left: Double, _ right: Double) -> Double {
        switch self {
        case .plus: return left + right
        case .minus: return left - right
        case .multiply: return left * right
        case .divide: return right != 0 ? left / right : Double.nan
        case .percent: return left * (right / 100)
        case .plusMinus: return -right
        default: return right
        }
    }
}

//MARK: - Input State
enum InputState {
    case number(Numbers)
    case operation(Operators)
    
    init?(tag: Int) {
        if let numberValue = Numbers(rawValue: tag) {
            self = .number(numberValue)
        } else if let operationValue = Operators(rawValue: tag) {
            self = .operation(operationValue)
        } else {
            return nil
        }
    }
}

final class ViewController: UIViewController {
    
    //MARK: - Properties
    
    private var currentInput: String = ""
    private var firstOperand: Double?
    private var pendingOperation: Operators?
    private var shouldResetInput = false
    private var isCalculationPerformed = false
    

    //MARK: - IBOutlets
    @IBOutlet private weak var resultLabel: UILabel!
    
    @IBAction private func handleTappedCalculatorButton(_ sender: UIButton) {
        detectButtonAction(sender.tag)
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: - Private Methods

private extension ViewController {
    func detectButtonAction(_ tag: Int) {
        guard let inputState = InputState(tag: tag) else { return }
        
        switch inputState {
        case .number(let number):
            appendDigit(number.stringValue)
            
        case .operation(let operation):
            switch operation {
            case .comma:
                appendDigit(",")
            case .clear:
                reset()
            case .plusMinus:
                toggleSign()
            case .percent:
                calculatePercent()
            case .divide, .multiply, .minus, .plus:
                performOperation(operation)
            case .equals:
                calculateResult()
            }
        }
    }
    
    func appendDigit(_ digit: String) {
        if shouldResetInput {
            currentInput = ""
            shouldResetInput = false
        }
        
        if digit == "," && currentInput.contains(",") {
            return
        }
        
        if digit == "," && currentInput.isEmpty {
            currentInput = "0,"
        } else {
            currentInput += digit
        }
        
        updateResultLabel()
    }
    
    func performOperation(_ operation: Operators) {
        if !currentInput.isEmpty || firstOperand != nil {
            if pendingOperation != nil && !shouldResetInput && !isCalculationPerformed {
                calculateResult()
            }
            
            if let inputNumber = Double(currentInput) {
                firstOperand = inputNumber
            }
            
            pendingOperation = operation
            shouldResetInput = true
            isCalculationPerformed = false
        }
        
        updateResultLabel()
    }
    
    func calculatePercent() {
        guard !currentInput.isEmpty else { return }
        
        if let value = Double(currentInput) {
            let percentValue = value / 100.0
            currentInput = formatResult(percentValue)
            updateResultLabel()
        }
    }
    
    func toggleSign() {
        guard !currentInput.isEmpty else { return }
        
        if let value = Double(currentInput) {
            let newValue = -value
            currentInput = formatResult(newValue)
            updateResultLabel()
        }
    }
    
    func calculateResult() {
        guard let operation = pendingOperation, !currentInput.isEmpty || firstOperand != nil else { return }
        
        let secondOperand = Double(currentInput) ?? 0
        
        let result = operation.calculate(firstOperand ?? 0, secondOperand)
        
        if result.isNaN {
            reset()
            resultLabel.text = "Error"
            return
        }
        
        firstOperand = result
        currentInput = formatResult(result)
        shouldResetInput = true
        isCalculationPerformed = true
        
        updateResultLabel()
    }
    
    func formatResult(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", value)
        } else {
            return String(value)
        }
    }
    
    func reset() {
        currentInput = ""
        firstOperand = nil
        pendingOperation = nil
        shouldResetInput = false
        isCalculationPerformed = false
        resultLabel.text = "0"
    }
    
    func updateResultLabel() {
        resultLabel.text = currentInput.isEmpty ? "0" : currentInput
    }
}

