//
//  ViewController.swift
//  Calculator
//
//  Created by Mehmet Ali Özdemir on 15.04.2025.
//

import UIKit

final class ViewController: UIViewController {
    
    //MARK: - Properties

    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func handleTappedCalculatorButton(_ sender: UIButton) {
        switch sender.tag {
        case 0...9: // Numbers
            print("")
        case 10: // Clear
            print("")
        case 11: // Plus/Minus
            print("")
        case 12: // Percent
            print("")
        case 13: // Division
            print("")
        case 14: // Multiplication
            print("")
        case 15: // Subtraction
            print("")
        case 16: // Addition
            print("")
        case 17: // Equals
            print("")
        case 18: // Comma
            print("")
        default:
            break
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: - Private Methods

private extension ViewController {
    
}

