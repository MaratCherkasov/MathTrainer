//
//  TrainViewController.swift
//  MathTrainer
//
//  Created by Marat Cherkasov on 26.03.2023.
//

import UIKit

final class TrainViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    // MARK: - Properties
    var type: MathTypes = .add {
        didSet {
            switch type {
            case .add:
                sign = "+"
            case .subtract:
                sign = "-"
            case .multiply:
                sign = "*"
            case .divide:
                sign = "/"
            }
        }
    }
    
    private var firstNumber = 0
    private var secondNumber = 0 {
        didSet {
            if sign == "*" || sign == "/" {
                secondNumber = Int.random(in: 1...9)
            }
        }
    }
    
    private var sign: String = ""
    private var count: Int = 0 {
        didSet {
            countLabel.text = String(count)
            print("Count: \(count)")
        }
    }
    
    private var answer: Int {
        switch type {
        case .add:
            return firstNumber + secondNumber
        case .subtract:
            return firstNumber - secondNumber
        case .multiply:
            return firstNumber * secondNumber
        case .divide:
            return firstNumber / secondNumber
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        countLabel.text = "0"
        countLabel.layer.cornerRadius = 10
        configureQuestion()
        configureButtonsTwoScreen()
    }
    
    // MARK: - IBActions
    @IBAction func leftAction(_ sender: UIButton) {
        check(answer: sender.titleLabel?.text ?? "",
              for: sender)
    }
    
    @IBAction func rightAction(_ sender: UIButton) {
        check(answer: sender.titleLabel?.text ?? "",
              for: sender)
    }
    
    // MARK: - Methods
    private func configureButtonsTwoScreen() {
        let buttonsArray = [leftButton, rightButton]
        
        buttonsArray.forEach { button in
            button?.backgroundColor = .systemYellow
        }
        // Add shadow
        buttonsArray.forEach { button in
            button?.layer.shadowColor = UIColor.darkGray.cgColor
            button?.layer.shadowOffset = CGSize(width: 0, height: 2)
            button?.layer.shadowOpacity = 0.4
            button?.layer.shadowRadius = 3
        }
        
        buttonBack.layer.shadowColor = UIColor.darkGray.cgColor
        buttonBack.layer.shadowOffset = CGSize(width: 0, height: 2)
        buttonBack.layer.shadowOpacity = 0.3
        buttonBack.layer.cornerRadius = 10
        buttonBack.layer.shadowRadius = 2
        
        let isRightButton = Bool.random()
        var randomAnswer: Int
        repeat {
            randomAnswer = Int.random(in: (answer - 10)...(answer + 10))
        } while randomAnswer == answer
        
        rightButton.setTitle(isRightButton ? String(answer) : String(randomAnswer),
                             for: .normal)
        leftButton.setTitle(isRightButton ? String(randomAnswer) : String(answer),
                            for: .normal)
    }
    
    private func configureQuestion() {
        var isDivisionWithoutRemainder = false
            while !isDivisionWithoutRemainder {
                firstNumber = Int.random(in: 1...99)
                secondNumber = Int.random(in: 1...99)
                if firstNumber % secondNumber == 0 {
                    isDivisionWithoutRemainder = true
                }
            }
        
        let question: String = "\(firstNumber) \(sign) \(secondNumber) ="
        questionLabel.text = question
    }
    
    private func check(answer: String, for button: UIButton) {
        let isRightAnswer = Int(answer) == self.answer
        
        button.backgroundColor = isRightAnswer ? .systemGreen : .systemRed
        
        if isRightAnswer {
            let isSecondAttempt = rightButton.backgroundColor == .systemRed ||
            leftButton.backgroundColor == .systemRed
            count += isSecondAttempt ? 0 : 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.configureQuestion()
                self?.configureButtonsTwoScreen()
            }
        }
    }
}