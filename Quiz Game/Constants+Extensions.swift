//
//  Constants+Extensions.swift
//  Quiz Game
//
//  Created by Johannes Ruof on 13/11/2016.
//  Copyright © 2016 Rume Academy. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    
    mutating func shuffle() {
        if count < 2 {return}
        for i in 0..<(count-1) {
            var j = 0
            while j == i {
                j = Int(arc4random_uniform(UInt32(count - i))) + i
            }
            swap(&self[i], &self[j])
        }
    }
    
}

let multipleChoiceHighscoreIdentifier = "MultipleChoiceHighscoreIdentifier"
let multipleChoiceRecentscoreIdentifier = "MultipleChoiceRecentscoreIdentifier"

let imageQuizHighscoreIdentifier = "ImageQuizHighscoreIdentifier"
let imageQuizRecentscoreIdentifier = "ImageQuizRecentscoreIdentifier"

let rightWrongHighscoreIdentifier = "RightWrongHighscoreIdentifier"
let rightWrongRecentscoreIdentifier = "RightWrongRecentscoreIdentifier"

//let emojiHighscoreIdentifier = "EmojiHighscoreIdentifier"
//let emojiRecentscoreIdentifier = "EmojiRecentscoreIdentifier"

let flatGreen = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
let flatOrange = UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1.0)
let flatRed = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
