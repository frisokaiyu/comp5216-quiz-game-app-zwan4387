//
//  QuizAlertView.swift
//  Quiz Game
//
//  Created by Johannes Ruof on 15/11/2016.
//  Copyright © 2016 Rume Academy. All rights reserved.
//

import UIKit

class QuizAlertView: UIView {

    private let alertView = UIView()
    private let titleLabel = RoundedLabel()
    private let messageLabel = RoundedLabel()
    let closeButton = UIButton()
    
    init(withTitle title: String, andMessage message: String, colors: [UIColor]) {
        super.init(frame: CGRect.zero)
        titleLabel.text = title
        messageLabel.text = message
        alertView.backgroundColor = colors[0]
        closeButton.backgroundColor = colors[1]
        layoutView()
    }
    
    func layoutView() {
        self.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.85)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        alertView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(alertView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(titleLabel)
        alertView.addSubview(messageLabel)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        messageLabel.font = UIFont.boldSystemFont(ofSize: 20)
        messageLabel.numberOfLines = 2
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.textColor = UIColor.white
        messageLabel.textAlignment = .center
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(closeButton)
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        closeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        closeButton.titleLabel?.textColor = UIColor.white
        closeButton.setTitle("Continue", for: .normal)
        
        let constraints = [
            alertView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3),
            alertView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            alertView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 8.0),
            titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalTo: alertView.heightAnchor, multiplier: 0.2),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: closeButton.topAnchor),
            closeButton.heightAnchor.constraint(equalTo: alertView.heightAnchor, multiplier: 0.2),
            closeButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor),
            closeButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor),
            closeButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}
