

import Foundation
import SpriteKit

class GameModeScreen: SKScene{
    
    let wagonLabel = SKLabelNode(fontNamed: "Brain Flower Euro")
    let touchLabel = SKLabelNode(fontNamed: "Brain Flower Euro")
    let backLabel = SKLabelNode(fontNamed: "Brain Flower Euro")
    let hand_wagon = SKSpriteNode(imageNamed: "the_new_hand_wagon")
    let hand_touch = SKSpriteNode(imageNamed: "the_hand_touch")
    
    override func didMoveToView(view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "red_background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.size = self.size
        background.zPosition = 0
        self.addChild(background)
        
        
        let gameModeLabel = SKLabelNode(fontNamed: "Brain Flower Euro")
        gameModeLabel.text = "Pick a Mode:"
        gameModeLabel.fontSize = 200
        gameModeLabel.fontColor = SKColor.blackColor()
        gameModeLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.8)
        gameModeLabel.zPosition = 1
        self.addChild(gameModeLabel)
        
        wagonLabel.text = " | WAGON |"
        wagonLabel.fontSize = 110
        wagonLabel.fontColor = SKColor.blackColor()
        wagonLabel.zPosition = 1
        wagonLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.65)
        self.addChild(wagonLabel)
        
        hand_wagon.position = CGPoint(x: self.size.width/2, y: self.size.height*0.57)
        hand_wagon.size = CGSizeMake(300, 200)
        hand_wagon.zPosition = 1
        self.addChild(hand_wagon)
        
        touchLabel.text = "| TOUCH |"
        touchLabel.fontSize = 110
        touchLabel.fontColor = SKColor.blackColor()
        touchLabel.zPosition = 1
        touchLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.4)
        self.addChild(touchLabel)
        
        hand_touch.position = CGPoint(x: self.size.width/2, y: self.size.height*0.32)
        hand_touch.size = CGSizeMake(250, 250)
        hand_touch.zPosition = 1
        self.addChild(hand_touch)
        
        backLabel.text = "| BACK |"
        backLabel.fontSize = 80
        backLabel.fontColor = SKColor.blackColor()
        backLabel.zPosition = 1
        backLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.08)
        self.addChild(backLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.locationInNode(self)
            
            if (wagonLabel.containsPoint(pointOfTouch) || hand_wagon.containsPoint(pointOfTouch)){
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fadeWithDuration(0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
                gameScore = 0
            }
            
            if (touchLabel.containsPoint(pointOfTouch) || hand_touch.containsPoint(pointOfTouch)){
                let sceneToMoveToTouch = GameSceneTwo(size: self.size)
                sceneToMoveToTouch.scaleMode = self.scaleMode
                let myTransitionTouch = SKTransition.fadeWithDuration(0.5)
                self.view!.presentScene(sceneToMoveToTouch, transition: myTransitionTouch)
                
                gameScore = 0
            }
            
            if backLabel.containsPoint(pointOfTouch){
                let sceneToMoveToBack = IntroductionScene(size: self.size)
                sceneToMoveToBack.scaleMode = self.scaleMode
                let myTransitionBack = SKTransition.fadeWithDuration(0.5)
                self.view!.presentScene(sceneToMoveToBack, transition: myTransitionBack)
                
                gameScore = 0
            }
        }
    }
}






