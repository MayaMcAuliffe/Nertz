//
//  TabletopController.swift
//  Nertz
//
//  Created by Maya McAuliffe on 8/16/18.
//  Copyright © 2018 Maya McAuliffe. All rights reserved.
//

import Foundation
import UIKit

class TabletopController: CardGestureDelegate { // conforms to drag delegate
    let tabletopView: UIImageView
    let cardWidth: Int = 54
    let cardHeight: Int = 72
    let snapMargin: CGFloat = 30
    let numCards = 52
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
            /* card.isUserInteractionEnabled = true
            card.addClickDeckRecognizer(vc: self)
            card.turnFaceDown()
            tabletop.addSubview(card)
            deck.append(card) */
        }
    }
    
    func createTurnPile() {
        
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
        print("in tabletop click func")
        cardController.turnFaceUp()
        cardController.moveTo(location: turnPileOrigin)
        deckArray.removeLast()
        pileArray.append(cardController)
    }
    
    func cardDragged(cardController: CardController, gestureRecognizer: UIPanGestureRecognizer) {
        
    }
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
