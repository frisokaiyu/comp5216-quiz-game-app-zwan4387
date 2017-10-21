//
//  RoundedLabel.swift
//  Quiz Game
//
//  Created by Johannes Ruof on 13/11/2016.
//  Copyright © 2016 Rume Academy. All rights reserved.
//

import UIKit

class RoundedLabel: UILabel {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
    }
    
    override func drawText(in rect: CGRect) {
        let newRect = rect.insetBy(dx: 8.0, dy: 8.0)
        super.drawText(in: newRect)
    }

}
