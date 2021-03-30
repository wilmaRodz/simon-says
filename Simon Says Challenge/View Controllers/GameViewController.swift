//
//  GameViewController.swift
//  Simon Says Challenge
//
//  Created by macbook on 3/28/21.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: - Properties
    
    var patternController = PatternController()
    var colorButtons: [Color: UIButton]?
    var timer: Timer?
    var nextColorIndex = 0
    
    // MARK: - Outlets
    
    // Labels
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var gameOverLabel: UILabel!
    // Game Buttons
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var tryAgainButton: UIButton!
    // Color Buttons
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        collectButtons()
    }
    
    // MARK: - Actions
    
    // Color Buttons
    @IBAction func redButtonTapped(_ sender: UIButton) {
        redButton.flash()
        checkIfCorrect(colorButton: sender)
    }
    @IBAction func blueButtonTapped(_ sender: UIButton) {
        blueButton.flash()
        checkIfCorrect(colorButton: sender)
    }
    @IBAction func purpleButtonTapped(_ sender: UIButton) {
        purpleButton.flash()
        checkIfCorrect(colorButton: sender)
    }
    @IBAction func yellowButtonTapped(_ sender: UIButton) {
        yellowButton.flash()
        checkIfCorrect(colorButton: sender)
    }
    
    // Game Buttons
    @IBAction func startButtonTapped(_ sender: UIButton) {
        startGame()
    }
    @IBAction func tryAgainButtonTapped(_ sender: UIButton) {
    }
    
    // MARK: - Game Methods
    
    private func startGame() {
        patternController.addNextColor()
        nextColorIndex = 0
        startButton.isHidden = true
        
        timer = Timer.scheduledTimer(timeInterval: 0.6,
                                     target: self,
                                     selector: #selector(tryToAnimate),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    // Animate the next color button if the colorIndex hasn't reached the end
    // of the pattern array
    @objc private func tryToAnimate() {
        guard let colorButtons = colorButtons else { return }
        
        if nextColorIndex <= patternController.pattern.count - 1 {
            let color = patternController.pattern[nextColorIndex]
            colorButtons[color]?.flash()
            nextColorIndex += 1
        } else {
            timer?.invalidate()
            nextColorIndex = 0
        }
    }
    
    // Check if the player continues playing, if they finished the pattern, or if they lost
    private func checkIfCorrect(colorButton: UIButton) {
        
        // Player's chosen color
        guard let colorElement = colorButtons?.filter({ $0.value == colorButton }),
              let color = colorElement.first?.key else { return }
        
        // Continue or stop game
        if patternController.isIncorrect(color: color) {
            // TODO: - Game Over
            print("DEBUG: \nGame Over\n")
            startButton.isHidden = false
        }
        if patternController.isLast(color: color) { startGame() }
    }
    
    // MARK: - Helper Methods
    
    // Save all color buttons inside dictionary
    private func collectButtons() {
        colorButtons = [.red : redButton,
                        .blue : blueButton,
                        .purple : purpleButton,
                        .yellow : yellowButton
        ]
    }
    
    private func updateViews() {
        gameOverLabel.alpha = 0
        tryAgainButton.isHidden = true
    }
}
