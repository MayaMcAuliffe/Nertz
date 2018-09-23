//
//  CardController.swift
//  Nertz
//
//  Created by Maya McAuliffe on 8/16/18.
//  Copyright © 2018 Maya McAuliffe. All rights reserved.
//

import Foundation
import UIKit

class CardController {
    let id: Int
    let suit: Int
    let val: Int
    let cardView: UIImageView
    let front: UIImage
    let back: UIImage
    var origin: CGPoint?
    var clickRecognizer: UITapGestureRecognizer!
    var dragRecognizer: UIPanGestureRecognizer!
    var gestureDelegate: CardGestureDelegate
    
    init(num: Int, width: Int, height: Int, gestureDel: CardGestureDelegate) { // pass in numbers 0 - 51
        id = num + 1
        suit = (num % 13) + 1
        val = (num / 13) + 1
        gestureDelegate = gestureDel
        
        let temp = (num / 13) + 1
        var imageName = ""
        if temp > 1 && temp < 11  {
            imageName = String(temp) + "_of_"
        }
        else if val == 1 {
            imageName = "ace_of_"
        }
        else if val == 11 {
            imageName = "jack_of_"
        }
        else if val == 12 {
            imageName = "queen_of_"
        }
        else if val == 13 {
            imageName = "king_of_"
        }
        if suit == 0 {
            imageName += "clubs"
        }
        else if suit == 1 {
            imageName += "diamonds"
        }
        else if suit == 2 {
            imageName += "spades"
        }
        else {
            imageName += "hearts"
        }
        
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        cardView = UIImageView(frame: frame)
        front = UIImage(named: imageName)!
        back = (#imageLiteral(resourceName: "bicycle_back"))
        cardView.image = back
        cardView.isUserInteractionEnabled = true
    }
    
    func prepareForDeck(superview: UIView, location: CGPoint) {
        superview.addSubview(cardView)
        moveTo(location: location)
        clickRecognizer = UITapGestureRecognizer(target: self, action: #selector(cardClicked(_:)))
        dragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(cardDragged(_:)))
        cardView.addGestureRecognizer(clickRecognizer)
        cardView.addGestureRecognizer(dragRecognizer)
    }
    
    func moveTo(location: CGPoint) {
        cardView.frame.origin.x = location.x
        cardView.frame.origin.y = location.y
    }
    
    func turnFaceUp() {
        cardView.image = front
    }
    
    func turnFaceDown() {
        cardView.image = back
    }
    
    @objc func cardClicked(_ sender: UITapGestureRecognizer) {
        print("card click method")
        gestureDelegate.cardClicked(cardController: self, gestureRecognizer: sender)
    }
    
    @objc func cardDragged(_ sender: UIPanGestureRecognizer) {
        print("card drag method")
        gestureDelegate.cardDragged(cardController: self, gestureRecognizer: sender)
    }
}

protocol CardGestureDelegate {
    func cardClicked(cardController: CardController, gestureRecognizer: UITapGestureRecognizer)
    func cardDragged(cardController: CardController, gestureRecognizer: UIPanGestureRecognizer)
    
}

