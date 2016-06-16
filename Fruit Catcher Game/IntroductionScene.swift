

import Foundation
import SpriteKit

class IntroductionScene: SKScene{
    
    let playLabel = SKLabelNode(fontNamed: "Brain Flower Euro")
    
    override func didMoveToView(view: SKView) {
        
        currentGameState = gameState.introGame
        
        let background = SKSpriteNode(imageNamed: "purple_background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.size = self.size
        background.zPosition = 0
        self.addChild(background)
        
        let girlwagon = SKSpriteNode(imageNamed: "wagongirl")
        girlwagon.position = CGPoint(x: self.size.width/2, y: self.size.height/2.5)
        girlwagon.size = CGSizeMake(500, 500)
        girlwagon.zPosition = 1
        self.addChild(girlwagon)
        
        let titleLabel = SKLabelNode(fontNamed: "Brain Flower Euro")
        titleLabel.text = "Fruit Wagon"
        titleLabel.fontSize = 200
        titleLabel.fontColor = SKColor.blackColor()
        titleLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        titleLabel.zPosition = 1
        self.addChild(titleLabel)
        
        playLabel.text = "--- Play ---"
        playLabel.fontSize = 110
        playLabel.fontColor = SKColor.blackColor()
        playLabel.zPosition = 1
        playLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.1)
        self.addChild(playLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.locationInNode(self)
                
                if playLabel.containsPoint(pointOfTouch){
                    let sceneToMoveTo = GameModeScreen(size: self.size)
                    sceneToMoveTo.scaleMode = self.scaleMode
                    let myTransition = SKTransition.fadeWithDuration(0.5)
                    self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                }
            }
        }
    }





