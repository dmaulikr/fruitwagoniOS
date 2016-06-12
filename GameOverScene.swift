//
//  GameOverScene.swift
//  Fruit Catcher Game
//
//  Created by Imran Khan Afrulbasha on 6/3/16.
//  Copyright © 2016 Khan. All rights reserved.
//

import Foundation
import SpriteKit

let defaults = NSUserDefaults()
var highScoreNumber = defaults.integerForKey("highScoreSaved")

class GameOverScene: SKScene{
    
    let restartLabel = SKLabelNode(fontNamed: "Brain Flower Euro")
    let homeLabel = SKLabelNode(fontNamed: "Brain Flower Euro")
    let resetScoreLabel = SKLabelNode(fontNamed: "Brain Flower Euro")
    
    
    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.size = self.size
        background.zPosition = 0
        self.addChild(background)
        
        /*
        let image = UIImage(named: "poof") as UIImage?
        let gameOverLabel = UIButton(type: UIButtonType.Custom) as UIButton
        gameOverLabel.frame = CGRectMake(100, 100, 100, 100)
        gameOverLabel.setImage(image, forState: .Normal)
        self.view?.addSubview(gameOverLabel)
        */
        
        //The equivalent code would be CGRectMake(myOrigin.x, myOrigin.y, size.width, size.height)
        
        
        let gameOverLabel = SKLabelNode(fontNamed: "Brain Flower Euro")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 200
        gameOverLabel.fontColor = SKColor.blackColor()
        gameOverLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)

        
        let scoreLabel = SKLabelNode(fontNamed: "Brain Flower Euro")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = SKColor.blackColor()
        scoreLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
       // let defaults = NSUserDefaults()
       // var highScoreNumber = defaults.integerForKey("highScoreSaved")
        
        if gameScore > highScoreNumber{
            highScoreNumber = gameScore
            defaults.setInteger(highScoreNumber, forKey: "highScoreSaved")
        }
        
        let highScoreLabel = SKLabelNode(fontNamed: "Brain Flower Euro")
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 125
        highScoreLabel.fontColor = SKColor.blackColor()
        highScoreLabel.zPosition = 1
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)
        self.addChild(highScoreLabel)
        
        restartLabel.text = "Restart"
        restartLabel.fontSize = 90
        restartLabel.fontColor = SKColor.blackColor()
        restartLabel.zPosition = 1
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.3)
        self.addChild(restartLabel)
        
        homeLabel.text = "Home"
        homeLabel.fontSize = 90
        homeLabel.fontColor = SKColor.blackColor()
        homeLabel.zPosition = 1
        homeLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.15)
        self.addChild(homeLabel)
        
        
        resetScoreLabel.text = "Reset High Score"
        resetScoreLabel.fontSize = 90
        resetScoreLabel.fontColor = SKColor.blackColor()
        resetScoreLabel.zPosition = 1
        resetScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.05)
        self.addChild(resetScoreLabel)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.locationInNode(self)
            
            if restartLabel.containsPoint(pointOfTouch){
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fadeWithDuration(0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
                gameScore = 0
            }
            if homeLabel.containsPoint(pointOfTouch){
                let sceneToMoveTo = IntroductionScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fadeWithDuration(0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
                gameScore = 0
            }
            if resetScoreLabel.containsPoint(pointOfTouch){
                highScoreNumber = 0
                defaults.setInteger(highScoreNumber, forKey: "highScoreSaved")
                
                gameScore = 0
            }
            
    }
    }
}






