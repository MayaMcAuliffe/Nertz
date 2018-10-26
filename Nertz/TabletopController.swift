//
//  TabletopController.swift
//  Nertz
//
//  Created by Maya McAuliffe on 8/16/18.
//  Copyright © 2018 Maya McAuliffe. All rights reserved.
//

import Foundation
import UIKit

class TabletopController: CardGestureDelegate, emptyDeckDelegate { // conforms to drag delegate
    let tabletopView: UIImageView
    let cardWidth: Int = 54
    let cardHeight: Int = 72
    let snapMargin: CGFloat = 30
    let numCards = 0
    var numTurnUps = 4
    var numAces = 4
    let deckOrigin: CGPoint
    let turnPileOrigin: CGPoint
    var deckArray = [CardController]()
    var pileArray = [CardController]()
    
    init (view: UIView) {
        tabletopView = UIImageView(frame: view.frame)
        tabletopView.image = #imageLiteral(resourceName: "wood")
        deckOrigin = CGPoint(x: (tabletopView.frame.width - CGFloat(cardWidth * (numTurnUps + 1))) / CGFloat(2 + numTurnUps), y: tabletopView.frame.maxY - CGFloat(cardHeight) - 20)
        turnPileOrigin = CGPoint(x: (tabletopView.frame.width - CGFloat(cardWidth * (numTurnUps + 1))) / CGFloat(2 + numTurnUps), y: tabletopView.frame.maxY - 2 * CGFloat(cardHeight) - 40)
        tabletopView.isUserInteractionEnabled = true
        setupBoard()
    }
    
    func setupBoard() {
        let turnUpSpaces = (tabletopView.frame.width - CGFloat(cardWidth * (numTurnUps + 1))) / CGFloat(1 + numTurnUps + 1)
        for i in 0..<(numTurnUps + 1) { // add 1 for nertz pile
            let xVal = CGFloat(i + 1) * turnUpSpaces + CGFloat((i) * cardWidth)
            if i == 0 {
                createNertzPile(point: CGPoint(x: xVal, y: 200))
            }
            else {
                createPile(point: CGPoint(x: xVal, y: 200))
            }
        }
        let aceSpaces = (tabletopView.frame.width - CGFloat(cardWidth * numAces)) / CGFloat(1 + numAces)
        for i in 0..<(numAces) {
            let xVal = CGFloat(i + 1) * aceSpaces + CGFloat(i * cardWidth)
            createAce(point: CGPoint(x: xVal, y: 100))
        }
        createEmptyDeckSpot()
        createDeck()
        createUndoButton()
    }
    
    func createEmptyDeckSpot() {
        let frame = CGRect(x: deckOrigin.x, y: deckOrigin.y, width: CGFloat (cardWidth), height: CGFloat (cardHeight))
        _ = EmptyDeckSpotController(frame: frame, superview: tabletopView, gestureDel: self)
    }
    
    func createDeck() {
        var shuffleOrder = [Int]()
        for i in 0..<numCards {
            shuffleOrder.append(i)
        }
        shuffleOrder.shuffle()
        for i in 0..<numCards {
            let card = CardController(num: shuffleOrder[i], width: cardWidth, height: cardHeight, gestureDel: self)
            card.prepareForDeck(superview: self.tabletopView, location: deckOrigin)
            deckArray.append(card)
        }
    }
    
    func createUndoButton() {
        
    }
    
    func createPile(point: CGPoint) {
       
    }
    
    func createAce(point: CGPoint) {
        
    }
    
    func createNertzPile(point: CGPoint) {
    
    }
    
    func cardClicked(cardController: CardController, gestureRecognizer: UITapGestureRecognizer) {
        cardController.bringToFront(superview: tabletopView)
        cardController.moveTo(location: turnPileOrigin)
        cardController.turnFaceUp()
        deckArray.removeLast()
        pileArray.append(cardController)
        cardController.removeClickGesture() // NOTE- IF I EVER WANT CARDS TO BE CLICKED ANYWHERE BESIDES DECK THIS WILL HAVE TO CHANGE
    }
    
    func cardDragged(cardController: CardController, gestureRecognizer: UIPanGestureRecognizer) {
        
    }
    
    func spotClicked(spotController: EmptyDeckSpotController, gestureRecognizer: UITapGestureRecognizer) {
        print("spot clicked 2")
        for i in (0..<pileArray.count).reversed() {
            let cardController = pileArray[i]
            
            // model-wise put pile cards back into deck "flipped over"
            deckArray.append(cardController)
            pileArray.remove(at: i)
            cardController.addClickGesture()
            cardController.removeDragGesture()
            
            // view-wise, move cards back to deck
            cardController.bringToFront(superview: tabletopView)
            cardController.turnFaceDown()
            cardController.animatedMoveTo(location: deckOrigin)
        }
    }
}

class EmptyDeckSpotController {
    var gestureDelegate: emptyDeckDelegate
    let deckSpotView: UIView
    
    init(frame: CGRect, superview: UIView, gestureDel: emptyDeckDelegate) {
        print("spot created")
        gestureDelegate = gestureDel
        deckSpotView = UIView(frame: frame)
        superview.addSubview(deckSpotView)
        deckSpotView.backgroundColor = UIColor.black
        deckSpotView.isUserInteractionEnabled = true
        
        let spotRecognizer = UITapGestureRecognizer(target: self, action: #selector(spotClicked(_:)))
        deckSpotView.addGestureRecognizer(spotRecognizer)
    }
    
    @objc func spotClicked(_ sender: UITapGestureRecognizer) {
        print("spot clicked 1")
        gestureDelegate.spotClicked(spotController: self, gestureRecognizer: sender)
    }
}

protocol emptyDeckDelegate {
    func spotClicked(spotController: EmptyDeckSpotController, gestureRecognizer: UITapGestureRecognizer)
}

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
