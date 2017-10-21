//
//  ImageQuizViewController.swift
//  Quiz Game
//
//  Created by Johannes Ruof on 13/11/2016.
//  Copyright © 2016 Rume Academy. All rights reserved.
//

import UIKit

class ImageQuizViewController: UIViewController {
    private let contentView = UIView()
    private var contentViewConstraints: [NSLayoutConstraint]!
    
    private let questionView = UIImageView()
    private var questionViewConstraints: [NSLayoutConstraint]!
    
    private var imageGridViews = [UIView]()
    
    private let answerView = UIView()
    private var answerViewConstraints: [NSLayoutConstraint]!
    
    private let countdownView = UIView()
    private var countdownViewConstraints: [NSLayoutConstraint]!
    
    private var answerButtons = [RoundedButton]()
    private var answerButtonsConstraints: [NSLayoutConstraint]!
    
    private let progressView = UIProgressView()
    private var progressViewConstraints: [NSLayoutConstraint]!
    
    private let backgroundColor = UIColor(red: 51/255, green: 110/255, blue: 123/255, alpha: 1.0)
    private let foregroundColor = UIColor(red: 197/255, green: 239/255, blue: 247/255, alpha: 1.0)
    
    private let quizLoader = QuizLoader()
    
    private var questionArray = [MultipleChoiceQuestion]()
    private var questionIndex = 0
    private var currentQuestion: MultipleChoiceQuestion!
    
    private var timer = Timer()
    private var revealTimer = Timer()
    private var revealIndex = 0
    private var score = 0
    private var highscore = UserDefaults.standard.integer(forKey: imageQuizHighscoreIdentifier)
    
    private var quizAlertView: QuizAlertView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        layoutView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    func layoutView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        
        questionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(questionView)
        for _ in 0...8 {
            let view = UIView()
            imageGridViews.append(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            questionView.addSubview(view)
            view.backgroundColor = foregroundColor
        }
        
        answerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(answerView)
        
        for _ in 0...3 {
            let button = RoundedButton()
            answerButtons.append(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            answerView.addSubview(button)
            button.addTarget(self, action: #selector(answerButtonHandler), for: .touchUpInside)
        }
        
        countdownView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(countdownView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        countdownView.addSubview(progressView)
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 10)
        
        contentViewConstraints = [
            contentView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        questionViewConstraints = [
            questionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.0),
            questionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            questionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            questionView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4)
        ]
        
        answerViewConstraints = [
            answerView.topAnchor.constraint(equalTo: questionView.bottomAnchor, constant: 20.0),
            answerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            answerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            answerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4)
        ]
        
        answerButtonsConstraints = [
            answerButtons[0].leadingAnchor.constraint(equalTo: answerView.leadingAnchor),
            answerButtons[0].trailingAnchor.constraint(equalTo: answerButtons[1].leadingAnchor, constant: -8.0),
            answerButtons[0].topAnchor.constraint(equalTo: answerView.topAnchor),
            answerButtons[0].bottomAnchor.constraint(equalTo: answerButtons[2].topAnchor, constant: -8.0),
            answerButtons[1].trailingAnchor.constraint(equalTo: answerView.trailingAnchor),
            answerButtons[1].topAnchor.constraint(equalTo: answerView.topAnchor),
            answerButtons[1].bottomAnchor.constraint(equalTo: answerButtons[3].topAnchor, constant: -8.0),
            answerButtons[2].leadingAnchor.constraint(equalTo: answerView.leadingAnchor),
            answerButtons[2].trailingAnchor.constraint(equalTo: answerButtons[3].leadingAnchor, constant: -8.0),
            answerButtons[2].bottomAnchor.constraint(equalTo: answerView.bottomAnchor),
            answerButtons[3].trailingAnchor.constraint(equalTo: answerView.trailingAnchor),
            answerButtons[3].bottomAnchor.constraint(equalTo: answerView.bottomAnchor)
        ]
        
        for index in 1..<answerButtons.count {
            answerButtonsConstraints.append(answerButtons[index].heightAnchor.constraint(equalTo: answerButtons[index-1].heightAnchor))
            answerButtonsConstraints.append(answerButtons[index].widthAnchor.constraint(equalTo: answerButtons[index-1].widthAnchor))
        }
        
        countdownViewConstraints = [
            countdownView.topAnchor.constraint(equalTo: answerView.bottomAnchor, constant: 20.0),
            countdownView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            countdownView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            countdownView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.0)
        ]
        
        progressViewConstraints = [
            progressView.leadingAnchor.constraint(equalTo: countdownView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: countdownView.trailingAnchor),
            progressView.centerYAnchor.constraint(equalTo: countdownView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(contentViewConstraints)
        NSLayoutConstraint.activate(questionViewConstraints)
        NSLayoutConstraint.activate(answerViewConstraints)
        NSLayoutConstraint.activate(answerButtonsConstraints)
        NSLayoutConstraint.activate(countdownViewConstraints)
        NSLayoutConstraint.activate(progressViewConstraints)
        
        for index in 0..<imageGridViews.count {
            if [0,1,2].contains(index) {
                imageGridViews[index].topAnchor.constraint(equalTo: questionView.topAnchor).isActive = true
            }
            if [3,4,5].contains(index) {
                imageGridViews[index].topAnchor.constraint(equalTo: imageGridViews[0].bottomAnchor).isActive = true
            }
            if [6,7,8].contains(index) {
                imageGridViews[index].topAnchor.constraint(equalTo: imageGridViews[3].bottomAnchor).isActive = true
                imageGridViews[index].bottomAnchor.constraint(equalTo: questionView.bottomAnchor).isActive = true
            }
            if [0,3,6].contains(index) {
                imageGridViews[index].leadingAnchor.constraint(equalTo: questionView.leadingAnchor).isActive = true
            }
            if [1,4,7].contains(index) {
                imageGridViews[index].leadingAnchor.constraint(equalTo: imageGridViews[0].trailingAnchor).isActive = true
            }
            if [2,5,8].contains(index) {
                imageGridViews[index].leadingAnchor.constraint(equalTo: imageGridViews[1].trailingAnchor).isActive = true
                imageGridViews[index].trailingAnchor.constraint(equalTo: questionView.trailingAnchor).isActive = true
            }
            if index > 0 {
                imageGridViews[index].heightAnchor.constraint(equalTo: imageGridViews[index-1].heightAnchor).isActive = true
                imageGridViews[index].widthAnchor.constraint(equalTo: imageGridViews[index-1].widthAnchor).isActive = true
            }
        }
        
        loadQuestions()
    }
    
    func loadQuestions() {
        do {
            questionArray = try quizLoader.loadMultipleChoiceQuiz(forQuiz: "ImageQuiz")
            loadNextQuestion()
        } catch {
            switch error {
            case LoaderError.dictionaryFailed:
                print("Could not load dictionary")
            case LoaderError.pathFailed:
                print("Could not find valid file at path")
            default:
                print("Unknown error")
            }
        }
    }
    
    func loadNextQuestion() {
        if quizAlertView != nil {
            quizAlertView?.removeFromSuperview()
        }
        currentQuestion = questionArray[questionIndex]
        setTitlesForButtons()
    }
    
    func setTitlesForButtons() {
        for (index,button) in answerButtons.enumerated() {
            button.titleLabel?.lineBreakMode = .byWordWrapping
            button.setTitle(currentQuestion.answers[index], for: .normal)
            button.isEnabled = true
            button.backgroundColor = foregroundColor
            button.setTitleColor(UIColor.darkGray, for: .normal)
        }
        for view in imageGridViews {
            view.alpha = 1.0
        }
        imageGridViews.shuffle()
        questionView.image = UIImage(named: currentQuestion.question)
        revealIndex = 0
        revealTile()
        startTimer()
    }
    
    func startTimer() {
        progressView.progressTintColor = flatGreen
        progressView.trackTintColor = UIColor.clear
        progressView.progress = 1.0
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
        revealTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(revealTile), userInfo: nil, repeats: true)
    }
    
    func revealTile() {
        if revealIndex < imageGridViews.count {
            UIView.animate(withDuration: 0.25, animations: { 
                self.imageGridViews[self.revealIndex].alpha = 0.0
            })
            revealIndex += 1
        }
    }
    
    func updateProgressView() {
        progressView.progress -= 0.01/30
        if progressView.progress <= 0 {
            outOfTime()
        } else if progressView.progress <= 0.2 {
            progressView.progressTintColor = flatRed
        } else if progressView.progress <= 0.5 {
            progressView.progressTintColor = flatOrange
        }
    }
    
    func outOfTime() {
        timer.invalidate()
        showAlert(forReason: 0)
        for button in answerButtons {
            button.isEnabled = false
        }
    }
    
    func answerButtonHandler(_ sender: RoundedButton) {
        for view in imageGridViews {
            view.alpha = 0.0
        }
        revealTimer.invalidate()
        timer.invalidate()
        if sender.titleLabel?.text == currentQuestion.correctAnswer {
            score += 1 + (imageGridViews.count - revealIndex)
            questionIndex += 1
            questionIndex < questionArray.count ? showAlert(forReason: 3) : showAlert(forReason: 2)
        } else {
            sender.backgroundColor = flatRed
            showAlert(forReason: 1)
        }
        for button in answerButtons {
            button.isEnabled = false
            if button.titleLabel?.text == currentQuestion.correctAnswer {
                button.backgroundColor = flatGreen
            }
        }
    }
    
    func showAlert(forReason reason: Int) {
        switch reason {
        case 0:
            quizAlertView = QuizAlertView(withTitle: "You lost", andMessage: "You ran out of time", colors: [backgroundColor,foregroundColor])
            quizAlertView?.closeButton.addTarget(self, action: #selector(closeAlert), for: .touchUpInside)
        case 1:
            quizAlertView = QuizAlertView(withTitle: "You lost", andMessage: "You picked the wrong answer", colors: [backgroundColor,foregroundColor])
            quizAlertView?.closeButton.addTarget(self, action: #selector(closeAlert), for: .touchUpInside)
        case 2:
            quizAlertView = QuizAlertView(withTitle: "You won", andMessage: "You have answered all questions", colors: [backgroundColor,foregroundColor])
            quizAlertView?.closeButton.addTarget(self, action: #selector(closeAlert), for: .touchUpInside)
        case 3:
            quizAlertView = QuizAlertView(withTitle: "Correct!", andMessage: "Tap continue to get to the next question", colors: [backgroundColor,foregroundColor])
            quizAlertView?.closeButton.addTarget(self, action: #selector(loadNextQuestion), for: .touchUpInside)
        default:
            break
        }
        
        if let qav = quizAlertView {
            quizAlertView?.closeButton.setTitleColor(UIColor.darkGray, for: .normal)
            createQuizAlertView(withAlert: qav)
        }
    }
    
    func createQuizAlertView(withAlert alert: QuizAlertView) {
        alert.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(alert)
        
        alert.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        alert.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        alert.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        alert.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func closeAlert() {
        if score > highscore {
            highscore = score
            UserDefaults.standard.set(highscore, forKey: imageQuizHighscoreIdentifier)
        }
        UserDefaults.standard.set(score, forKey: imageQuizRecentscoreIdentifier)
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        if parent == nil {
            revealTimer.invalidate()
            timer.invalidate()
        }
    }
    
}
