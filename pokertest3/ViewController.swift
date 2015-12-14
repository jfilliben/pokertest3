//
//  ViewController.swift
//  pokertest3
//
//  Created by Jeremy Filliben on 12/17/14.
//  Copyright (c) 2014 Jeremy Filliben. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userCard1View: UIImageView!
    @IBOutlet weak var userCard2View: UIImageView!
    @IBOutlet weak var player1Card1View: UIImageView!
    @IBOutlet weak var player1Card2View: UIImageView!
    @IBOutlet weak var player2Card1View: UIImageView!
    @IBOutlet weak var player2Card2View: UIImageView!
    @IBOutlet weak var player3Card1View: UIImageView!
    @IBOutlet weak var player3Card2View: UIImageView!
    @IBOutlet weak var player4Card1View: UIImageView!
    @IBOutlet weak var player4Card2View: UIImageView!
    @IBOutlet weak var player5Card1View: UIImageView!
    @IBOutlet weak var player5Card2View: UIImageView!
    @IBOutlet weak var boardCard1View: UIImageView!
    @IBOutlet weak var boardCard2View: UIImageView!
    @IBOutlet weak var boardCard3View: UIImageView!
    @IBOutlet weak var boardCard4View: UIImageView!
    @IBOutlet weak var boardCard5View: UIImageView!
    
    @IBOutlet weak var dealButtonView: UIButton!
    @IBOutlet weak var betButtonView: UIButton!
    @IBOutlet weak var checkButtonView: UIButton!
    @IBOutlet weak var raiseButtonView: UIButton!
    @IBOutlet weak var foldButtonView: UIButton!
    @IBOutlet weak var callButtonView: UIButton!


    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var potView: UILabel!
    
    @IBOutlet weak var player1CardView: UIView!
    @IBOutlet weak var player1BetAmountView: UILabel!
    @IBOutlet weak var player1StackView: UILabel!
    @IBOutlet weak var player1NameView: UILabel!
    @IBOutlet weak var player1ImageView: UIImageView!
    
    @IBOutlet weak var player2CardView: UIView!
    @IBOutlet weak var player2BetAmountView: UILabel!
    @IBOutlet weak var player2StackView: UILabel!
    @IBOutlet weak var player2NameView: UILabel!
    @IBOutlet weak var player2ImageView: UIImageView!
    
    @IBOutlet weak var player3CardView: UIView!
    @IBOutlet weak var player3BetAmountView: UILabel!
    @IBOutlet weak var player3StackView: UILabel!
    @IBOutlet weak var player3NameView: UILabel!
    @IBOutlet weak var player3ImageView: UIImageView!
    
    @IBOutlet weak var player4CardView: UIView!
    @IBOutlet weak var player4BetAmountView: UILabel!
    @IBOutlet weak var player4StackView: UILabel!
    @IBOutlet weak var player4NameView: UILabel!
    @IBOutlet weak var player4ImageView: UIImageView!
    
    @IBOutlet weak var player5CardView: UIView!
    @IBOutlet weak var player5BetAmountView: UILabel!
    @IBOutlet weak var player5StackView: UILabel!
    @IBOutlet weak var player5NameView: UILabel!
    @IBOutlet weak var player5ImageView: UIImageView!
    
    @IBOutlet weak var userCardView: UIView!
    @IBOutlet weak var userBetAmountView: UILabel!
    @IBOutlet weak var userStackView: UILabel!
    @IBOutlet weak var userNameView: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var gameLogoView: UIImageView!
    @IBOutlet weak var startGameButtonView: UIButton!
    
    @IBOutlet weak var tableLogTextView: UITextView!
    
    var game = GameState()
    var maxBuyIn = 200
    let debugShowCards = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.resetGameView()
        
        // fake "Start Game button Pressed"
        self.startGameButtonPressed("fake")
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func resetGameView() {
        
        player1CardView.hidden = true
        player1BetAmountView.hidden = true
        player2CardView.hidden = true
        player2BetAmountView.hidden = true
        player3CardView.hidden = true
        player3BetAmountView.hidden = true
        player4CardView.hidden = true
        player4BetAmountView.hidden = true
        player5CardView.hidden = true
        player5BetAmountView.hidden = true
        userCard1View.hidden = true
        userCard2View.hidden = true
        userBetAmountView.hidden = true
        potView.hidden = true
        boardCard1View.hidden = true
        boardCard2View.hidden = true
        boardCard3View.hidden = true
        boardCard4View.hidden = true
        boardCard5View.hidden = true
        
        dealButtonView.hidden = true
        betButtonView.hidden = true
        checkButtonView.hidden = true
        raiseButtonView.hidden = true
        foldButtonView.hidden = true
        callButtonView.hidden = true
        
        userNameView.text = game.returnPlayerName((0))
        player1NameView.text = game.returnPlayerName((1))
        player2NameView.text = game.returnPlayerName((2))
        player3NameView.text = game.returnPlayerName((3))
        player4NameView.text = game.returnPlayerName((4))
        player5NameView.text = game.returnPlayerName((5))
        
        userImageView.image = UIImage(named: game.returnPlayerImage(0))
        player1ImageView.image = UIImage(named: game.returnPlayerImage(1))
        player2ImageView.image = UIImage(named: game.returnPlayerImage(2))
        player3ImageView.image = UIImage(named: game.returnPlayerImage(3))
        player4ImageView.image = UIImage(named: game.returnPlayerImage(4))
        player5ImageView.image = UIImage(named: game.returnPlayerImage(5))
        
        userStackView.text = "$\(game.returnPlayerStack(0))"
        player1StackView.text = "$\(game.returnPlayerStack(1))"
        player2StackView.text = "$\(game.returnPlayerStack(2))"
        player3StackView.text = "$\(game.returnPlayerStack(3))"
        player4StackView.text = "$\(game.returnPlayerStack(4))"
        player5StackView.text = "$\(game.returnPlayerStack(5))"
        
        tableLogTextView.editable = false
        tableLogTextView.text = game.returnTableLog()
        tableLogTextView.scrollRangeToVisible(NSRange(location: tableLogTextView.text!.characters.count, length: 0))
    }
    
    func updateGameView() {
        
        if debugShowCards {
            player1Card1View.image = UIImage(named: game.returnPlayerCardImage(1, cardNum: 0))
            player1Card2View.image = UIImage(named: game.returnPlayerCardImage(1, cardNum: 1))
            player2Card1View.image = UIImage(named: game.returnPlayerCardImage(2, cardNum: 0))
            player2Card2View.image = UIImage(named: game.returnPlayerCardImage(2, cardNum: 1))
            player3Card1View.image = UIImage(named: game.returnPlayerCardImage(3, cardNum: 0))
            player3Card2View.image = UIImage(named: game.returnPlayerCardImage(3, cardNum: 1))
            player4Card1View.image = UIImage(named: game.returnPlayerCardImage(4, cardNum: 0))
            player4Card2View.image = UIImage(named: game.returnPlayerCardImage(4, cardNum: 1))
            player5Card1View.image = UIImage(named: game.returnPlayerCardImage(5, cardNum: 0))
            player5Card2View.image = UIImage(named: game.returnPlayerCardImage(5, cardNum: 1))
        } else {
            player1Card1View.image = UIImage(named: "back")
            player1Card2View.image = UIImage(named: "back")
            player2Card1View.image = UIImage(named: "back")
            player2Card2View.image = UIImage(named: "back")
            player3Card1View.image = UIImage(named: "back")
            player3Card2View.image = UIImage(named: "back")
            player4Card1View.image = UIImage(named: "back")
            player4Card2View.image = UIImage(named: "back")
            player5Card1View.image = UIImage(named: "back")
            player5Card2View.image = UIImage(named: "back")
        }
        
        switch game.returnHandRound() {
        case .Preflop: break
        case .Flop:
            boardCard1View.image = UIImage(named: game.returnBoardCardImage(1))
            boardCard1View.hidden = false
            boardCard2View.image = UIImage(named: game.returnBoardCardImage(2))
            boardCard2View.hidden = false
            boardCard3View.image = UIImage(named: game.returnBoardCardImage(3))
            boardCard3View.hidden = false
        case .Turn:
            boardCard4View.image = UIImage(named: game.returnBoardCardImage(4))
            boardCard4View.hidden = false
        case .River:
            boardCard5View.image = UIImage(named: game.returnBoardCardImage(5))
            boardCard5View.hidden = false
        }
        
        userCard1View.image = UIImage(named: game.returnPlayerCardImage(0, cardNum: 0))
        userCard2View.image = UIImage(named: game.returnPlayerCardImage(0, cardNum: 1))
        userCard1View.hidden = false
        userCard2View.hidden = false
        potView.hidden = false
        player1CardView.hidden = !game.returnPlayerInHand(1)
        player2CardView.hidden = !game.returnPlayerInHand(2)
        player3CardView.hidden = !game.returnPlayerInHand(3)
        player4CardView.hidden = !game.returnPlayerInHand(4)
        player5CardView.hidden = !game.returnPlayerInHand(5)
        userStackView.text = "$\(game.returnPlayerStack(0))"
        player1StackView.text = "$\(game.returnPlayerStack(1))"
        player2StackView.text = "$\(game.returnPlayerStack(2))"
        player3StackView.text = "$\(game.returnPlayerStack(3))"
        player4StackView.text = "$\(game.returnPlayerStack(4))"
        player5StackView.text = "$\(game.returnPlayerStack(5))"
        userBetAmountView.text = "$\(game.returnPlayerBetAmount(0))"
        player1BetAmountView.text = "$\(game.returnPlayerBetAmount(1))"
        player2BetAmountView.text = "$\(game.returnPlayerBetAmount(2))"
        player3BetAmountView.text = "$\(game.returnPlayerBetAmount(3))"
        player4BetAmountView.text = "$\(game.returnPlayerBetAmount(4))"
        player5BetAmountView.text = "$\(game.returnPlayerBetAmount(5))"
        potView.text = "$\(game.returnPotSize())"

        tableLogTextView.text = game.returnTableLog()
        tableLogTextView.scrollRangeToVisible(NSRange(location: tableLogTextView.text!.characters.count, length: 0))
        
        // check status of game to determine buttons to display
        switch game.returnHandStatus() {
        case .NoBet:
            dealButtonView.hidden = true
            betButtonView.hidden = false
            checkButtonView.hidden = false
            raiseButtonView.hidden = true
            foldButtonView.hidden = true
            callButtonView.hidden = true
        case .BetPlaced:
            dealButtonView.hidden = true
            betButtonView.hidden = true
            checkButtonView.hidden = true
            raiseButtonView.hidden = false
            foldButtonView.hidden = false
            callButtonView.hidden = false
        case .BetMoreThanStack:
            dealButtonView.hidden = true
            betButtonView.hidden = true
            checkButtonView.hidden = true
            raiseButtonView.hidden = true
            foldButtonView.hidden = false
            callButtonView.hidden = false
        case .PlayerFolded:
            dealButtonView.hidden = true
            betButtonView.hidden = true
            checkButtonView.hidden = true
            raiseButtonView.hidden = true
            foldButtonView.hidden = true
            callButtonView.hidden = true
        case .HandComplete:
            dealButtonView.hidden = false
            betButtonView.hidden = true
            checkButtonView.hidden = true
            raiseButtonView.hidden = true
            foldButtonView.hidden = true
            callButtonView.hidden = true
        }
    }
    
    @IBAction func startGameButtonPressed(sender: AnyObject) {
        gameLogoView.hidden = true
        startGameButtonView.hidden = true
        dealButtonView.hidden = false
        game.startGame()
    }
    
    @IBAction func dealButtonPress(sender: AnyObject) {
        dealButtonView.hidden = true
        self.resetGameView()
        
        game.buttonPressed(ButtonPressed.Deal)

        self.updateGameView()
        
        while (!game.isUserTurn()) && (game.returnHandStatus() != .HandComplete) {
            //            sleep(2)
            game.continueGame()
            self.updateGameView()
        }
    }
    
    @IBAction func betButtonPress(sender: AnyObject) {
        
        game.buttonPressed(ButtonPressed.Bet(10.00))
        self.updateGameView()
        
        while (!game.isUserTurn()) && (game.returnHandStatus() != .HandComplete) {
            //            sleep(2)
            game.continueGame()
            self.updateGameView()
        }
    }
    
    @IBAction func checkButtonPress(sender: AnyObject) {
        
        game.buttonPressed(ButtonPressed.Check)
        self.updateGameView()
        
        while (!game.isUserTurn()) && (game.returnHandStatus() != .HandComplete) {
            //            sleep(2)
            game.continueGame()
            self.updateGameView()
        }
    }
    
    @IBAction func raiseButtonPress(sender: AnyObject) {
        
        game.buttonPressed(ButtonPressed.Raise(15.00))
        self.updateGameView()
        
        while (!game.isUserTurn()) && (game.returnHandStatus() != .HandComplete) {
            //            sleep(2)
            game.continueGame()
            self.updateGameView()
        }
    }
    
    @IBAction func foldButtonPress(sender: AnyObject) {
        
        game.buttonPressed(ButtonPressed.Fold)
        self.updateGameView()
        
        while game.returnHandStatus() != .HandComplete {
            //            sleep(2)
            game.continueGame()
            self.updateGameView()
        }
    }
    
    @IBAction func callButtonPress(sender: AnyObject) {
        
        game.buttonPressed(ButtonPressed.Call)
        self.updateGameView()
        
        while (!game.isUserTurn()) && (game.returnHandStatus() != .HandComplete) {
            //            sleep(2)
            game.continueGame()
            self.updateGameView()
        }
    }
    
}

