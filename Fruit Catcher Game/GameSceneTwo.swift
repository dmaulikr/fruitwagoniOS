

import SpriteKit
import Foundation

class GameSceneTwo: SKScene, SKPhysicsContactDelegate {
    
    var timer = NSTimer()
    var timerStop = NSTimer()
    var timerFreeze = NSTimer()
    var timerStopFreeze = NSTimer()
    
    var wait_a = SKAction.waitForDuration(10, withRange: 7)
    var wait_b = SKAction.waitForDuration(10, withRange: 7)
    var wait_o = SKAction.waitForDuration(10, withRange: 7)
    var wait_w = SKAction.waitForDuration(10, withRange: 7)
    var wait_g = SKAction.waitForDuration(10, withRange: 7)
    var wait_life = SKAction.waitForDuration(10, withRange: 7)
    var wait_ice = SKAction.waitForDuration(10, withRange: 7)
    
    var levelNumber_a = 1
    var levelNumber_b = 1
    var levelNumber_g = 1
    var levelNumber_o = 1
    var levelNumber_w = 1
    var levelNumber_life = 1
    var levelNumber_Ice = 1
    var LivesNumber = 3
    let scoreLabel = SKLabelNode(fontNamed: "Brain Flower Euro")
    let livesLabel = SKLabelNode(fontNamed: "Brain Flower Euro")
    
    let player = SKSpriteNode(imageNamed: "box")
    var gameArea: CGRect
    
    let tapToStartLabel = SKLabelNode(fontNamed: "Brain Flower Euro")
    
    func startGame(){
        
        if currentGameState == gameState.preGame{
            
            currentGameState = gameState.inGame
            let fadeOutAction = SKAction.fadeInWithDuration(0.01)
            let deleteAction = SKAction.removeFromParent()
            let deleteSequence = SKAction.sequence([fadeOutAction,deleteAction])
            tapToStartLabel.runAction(deleteSequence)
            
            let startLevelAction = SKAction.runBlock(startNewLevel)
            let startGameSequence = SKAction.sequence([startLevelAction])
            player.runAction(startGameSequence)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if currentGameState == gameState.preGame{
            startGame()
        }
        
        for touch: AnyObject in touches{
            let touchPosition = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(touchPosition)
            
            if (touchedNode.name == "Apple") {
                spawnExplosion(touchPosition)
                touchedNode.removeFromParent()
                addScorePlusOne()
            }
            if (touchedNode.name == "Banana") {
                spawnExplosion(touchPosition)
                touchedNode.removeFromParent()
                addScorePlusOne()
            }
            if (touchedNode.name == "Grape") {
                spawnExplosion(touchPosition)
                touchedNode.removeFromParent()
                addScorePlusThree()
            }
            if (touchedNode.name == "Orange") {
                spawnExplosion(touchPosition)
                touchedNode.removeFromParent()
                addScorePlusOne()
            }
            if (touchedNode.name == "Watermelon") {
                spawnExplosion(touchPosition)
                touchedNode.removeFromParent()
                addScorePlusfive()
            }
            if (touchedNode.name == "Life") {
                addALife()
                spawnLifeExplosion(touchPosition)
                touchedNode.removeFromParent()
            }
            if (touchedNode.name == "Ice") {
                spawnIceExplosion(touchPosition)
                touchedNode.removeFromParent()
                timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "changeGameStateToFreeze", userInfo: nil, repeats: true)
                timerStop = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: "endTimer_one", userInfo: nil, repeats: true)
                
                enumerateChildNodesWithName("*") { node, _ in
                    if node.name == "Apple" || node.name == "Banana" || node.name == "Grape" || node.name == "Watermelon" || node.name == "Orange"{
                        self.spawnExplosion(node.position)
                        node.removeFromParent()
                    }
                    if node.name == "Life"{
                        self.spawnLifeExplosion(node.position)
                        node.removeFromParent()
                    }
                    if node.name == "Ice"{
                        self.spawnIceExplosion(node.position)
                        node.removeFromParent()
                    }
                }
                
            }
        }
    }
    
    func runGameOver(){
        self.removeAllActions()
        
        self.enumerateChildNodesWithName("Apple"){
            apple, stop in
            apple.removeAllActions()
        }
        
        self.enumerateChildNodesWithName("Banana"){
            banana, stop in
            banana.removeAllActions()
        }
        self.enumerateChildNodesWithName("Grape"){
            grape, stop in
            grape.removeAllActions()
        }
        self.enumerateChildNodesWithName("Orange"){
            orange, stop in
            orange.removeAllActions()
        }
        self.enumerateChildNodesWithName("Watermelon"){
            watermelon, stop in
            watermelon.removeAllActions()
        }
        self.enumerateChildNodesWithName("Life"){
            life, stop in
            life.removeAllActions()
        }
        self.enumerateChildNodesWithName("Ice"){
            life, stop in
            life.removeAllActions()
        }
        
        currentGameState = gameState.afterGame
        
        let changeSceneAction = SKAction.runBlock(changeScene)
        let waitToChangeScene = SKAction.waitForDuration(1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.runAction(changeSceneSequence)
    }
    
    func changeScene(){
        let sceneToMoveTo = GameOverSceneTwo(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fadeWithDuration(0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    override init(size: CGSize) {
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height/maxAspectRatio
        let margin = (size.width - playableWidth)/2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
    }
    
    struct PhysicsCategories{
        static let None : UInt32 = 0                // 0
        static let Player : UInt32 = 0b1            // 1
        static let Ice : UInt32 = 0b10              // 2
        static let Life : UInt32 = 0b100            // 4
        static let Apple : UInt32 = 0b1000
        static let Orange : UInt32 = 0b10000
        static let Banana : UInt32 = 0b100000
        static let Watermelon : UInt32 = 0b1000000
        static let Grape : UInt32 = 0b1000000000
    }
    
    func changeGameStateToFreeze()
    {
        currentGameState = gameState.freezeGame
        startGame()
    }
    
    //change the game state to pregame right after the timer for the freezer ends for approximately 5 seconds.
    
    func endTimer_one(){
        currentGameState = gameState.inGame
        timer.invalidate()
        timerStop.invalidate()
        
        timerFreeze = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "changeGameStateToPreGame", userInfo: nil, repeats: true)
        timerStopFreeze = NSTimer.scheduledTimerWithTimeInterval(9.0, target: self, selector: "endTimer_two", userInfo: nil, repeats: true)
    }
    
    func changeGameStateToPreGame()
    {
        currentGameState = gameState.introGame
        startGame()
    }
    
    func endTimer_two(){
        timerFreeze.invalidate()
        timerStopFreeze.invalidate()
        currentGameState = gameState.inGame
    }
    
    //............................................................................................... the variables below will dictate how long the fruits will fall for
    
    var fall_time_apple = NSTimeInterval.abs(10)
    var fall_time_banana = NSTimeInterval.abs(10)
    var fall_time_orange = NSTimeInterval.abs(10)
    var fall_time_grape = NSTimeInterval.abs(10)
    var fall_time_watermelon = NSTimeInterval.abs(10)
    var fall_time_life = NSTimeInterval.abs(10)
    var fall_time_ice = NSTimeInterval.abs(10)
    
    func startNewLevel(){
        
        if ((gameScore >= 0) && (gameScore < 20)){
            levelNumber_a = 1
            levelNumber_b = 1
            levelNumber_g = 1
            levelNumber_o = 1
            levelNumber_w = 1
            levelNumber_life = 1
            levelNumber_Ice = 1
        }
        else if ((gameScore >= 20) && (gameScore  < 100)){
            levelNumber_a = 2
            levelNumber_b = 2
            levelNumber_g = 2
            levelNumber_o = 2
            levelNumber_w = 2
            levelNumber_life = 2
            levelNumber_Ice = 2
        }
        else if ((gameScore >= 100) && (gameScore < 310)){
            levelNumber_a = 3
            levelNumber_b = 3
            levelNumber_g = 3
            levelNumber_o = 3
            levelNumber_w = 3
            levelNumber_life = 3
            levelNumber_Ice = 3
        }
        else if (gameScore >= 310){
            levelNumber_a = 4
            levelNumber_b = 4
            levelNumber_g = 4
            levelNumber_o = 4
            levelNumber_w = 4
            levelNumber_life = 4
            levelNumber_Ice = 4
        }
        
        //...........................................................................................  this allows us to stop the current level with it's special key and start a new one
        if self.actionForKey("spawningEnemies_one") != nil{
            self.removeActionForKey("spawningEnemies_one")
        }
        if self.actionForKey("spawningEnemies_two") != nil{
            self.removeActionForKey("spawningEnemies_two")
        }
        if self.actionForKey("spawningEnemies_three") != nil{
            self.removeActionForKey("spawningEnemies_three")
        }
        if self.actionForKey("spawningEnemies_four") != nil{
            self.removeActionForKey("spawningEnemies_four")
        }
        if self.actionForKey("spawningEnemies_five") != nil{
            self.removeActionForKey("spawningEnemies_five")
        }
        if self.actionForKey("spawningEnemies_six") != nil{
            self.removeActionForKey("spawningEnemies_six")
        }
        if self.actionForKey("spawningEnemies_seven") != nil{
            self.removeActionForKey("spawningEnemies_seven")
        }
        
        //...........................................................................................  the first level is about right
        //...........................................................................................  the second level is about right
        //...........................................................................................  remember to adjust falling speed AND timing intervals
        //...........................................................................................  set the default to the last level because there wont be any more levels after that?
        //...........................................................................................  REMEMBER: IT WILL VARY BY HALF OF THE RANGE
        //...........................................................................................  "withRange" should be 0.1 less than  2 * waitForDuration
        
        switch levelNumber_a{
        case 1: wait_a = SKAction.waitForDuration(8, withRange: 15.9)
        fall_time_apple = NSTimeInterval.abs(5)
            
        case 2: wait_a = SKAction.waitForDuration(4, withRange: 7.9)
        fall_time_apple = NSTimeInterval.abs(3)
            
        case 3: wait_a = SKAction.waitForDuration(3, withRange: 5.9)
        fall_time_apple = NSTimeInterval.abs(2.2)
            
        case 4: wait_a = SKAction.waitForDuration(2, withRange: 3.9)
        fall_time_apple = NSTimeInterval.abs(1.5)
            
        default: wait_a = SKAction.waitForDuration(3, withRange: 5.9)
        fall_time_apple = NSTimeInterval.abs(2.2)
        }
        
        switch levelNumber_b{
        case 1: wait_b = SKAction.waitForDuration(8, withRange: 15.9)
        fall_time_banana = NSTimeInterval.abs(5.5)
            
        case 2: wait_b = SKAction.waitForDuration(4, withRange: 7.9)
        fall_time_banana = NSTimeInterval.abs(4)
            
        case 3: wait_b = SKAction.waitForDuration(3, withRange: 5.9)
        fall_time_banana = NSTimeInterval.abs(2.3)
            
        case 4: wait_b = SKAction.waitForDuration(2, withRange: 3.9)
        fall_time_banana = NSTimeInterval.abs(1.6)
            
        default: wait_b = SKAction.waitForDuration(3, withRange: 5.9)
        fall_time_banana = NSTimeInterval.abs(2.3)
        }
        
        switch levelNumber_g{
        case 1: wait_g = SKAction.waitForDuration(8, withRange: 15.9)
        fall_time_grape = NSTimeInterval.abs(4)
            
        case 2: wait_g = SKAction.waitForDuration(4, withRange: 7.9)
        fall_time_grape = NSTimeInterval.abs(3)
            
        case 3: wait_g = SKAction.waitForDuration(2.5, withRange: 3.9)
        fall_time_grape = NSTimeInterval.abs(2.0)
            
        case 4: wait_g = SKAction.waitForDuration(2, withRange: 3.9)
        fall_time_grape = NSTimeInterval.abs(1.2)
            
        default: wait_g = SKAction.waitForDuration(2.5, withRange: 3.9)
        fall_time_grape = NSTimeInterval.abs(2.0)
        }
        
        switch levelNumber_o{
        case 1: wait_o = SKAction.waitForDuration(8, withRange: 15.9)
        fall_time_orange = NSTimeInterval.abs(4.5)
            
        case 2: wait_o = SKAction.waitForDuration(4, withRange: 7.9)
        fall_time_orange = NSTimeInterval.abs(3)
            
        case 3: wait_o = SKAction.waitForDuration(2, withRange: 3.9)
        fall_time_orange = NSTimeInterval.abs(2.2)
            
        case 4: wait_o = SKAction.waitForDuration(2, withRange: 3.9)
        fall_time_orange = NSTimeInterval.abs(1.4)
            
        default: wait_o = SKAction.waitForDuration(2, withRange: 3.9)
        fall_time_orange = NSTimeInterval.abs(2.2)
        }
        
        switch levelNumber_w{
        case 1: wait_w = SKAction.waitForDuration(8, withRange: 15.9)
        fall_time_watermelon = NSTimeInterval.abs(3.5)
            
        case 2: wait_w = SKAction.waitForDuration(4, withRange: 7.9)
        fall_time_watermelon = NSTimeInterval.abs(2.5)
            
        case 3: wait_w = SKAction.waitForDuration(3, withRange: 5.9)
        fall_time_watermelon = NSTimeInterval.abs(1.9)
            
        case 4: wait_w = SKAction.waitForDuration(2, withRange: 3.9)
        fall_time_watermelon = NSTimeInterval.abs(1.1)
            
        default: wait_w = SKAction.waitForDuration(3, withRange: 5.9)
        fall_time_watermelon = NSTimeInterval.abs(1.9)
        }
        
        //....................................... make sure you keep adjusting so that life and Ice do not always appear at the same time
        
        switch levelNumber_life{
        case 1: wait_life = SKAction.waitForDuration(11, withRange: 11)
        fall_time_life = NSTimeInterval.abs(4.5)
            
        case 2: wait_life = SKAction.waitForDuration(11, withRange: 11)
        fall_time_life = NSTimeInterval.abs(4)
            
        case 3: wait_life = SKAction.waitForDuration(5, withRange: 5)
        fall_time_life = NSTimeInterval.abs(4)
            
        case 4: wait_life = SKAction.waitForDuration(5, withRange: 5)
        fall_time_life = NSTimeInterval.abs(4)
            
        default: wait_life = SKAction.waitForDuration(10, withRange: 10)
        fall_time_life = NSTimeInterval.abs(4)
        }
        
        switch levelNumber_Ice{
        case 1: wait_ice = SKAction.waitForDuration(13, withRange: 4)
        fall_time_ice = NSTimeInterval.abs(4.5)
            
        case 2: wait_ice = SKAction.waitForDuration(13, withRange: 4)
        fall_time_ice = NSTimeInterval.abs(4)
            
        case 3: wait_ice = SKAction.waitForDuration(5, withRange: 5)
        fall_time_ice = NSTimeInterval.abs(4)
            
        case 4: wait_ice = SKAction.waitForDuration(5, withRange: 5)
        fall_time_ice = NSTimeInterval.abs(4)
            
        default: wait_ice = SKAction.waitForDuration(10, withRange: 10)
        fall_time_ice = NSTimeInterval.abs(4)
        }
        
        let spawn_a =  SKAction.runBlock(spawnApples)
        let spawnSequence_a = SKAction.sequence([wait_a, spawn_a])
        let spawnForever_a = SKAction.repeatActionForever(spawnSequence_a)
        self.runAction(spawnForever_a, withKey: "spawningEnemies_one")
        
        let spawn_b =  SKAction.runBlock(spawnBananas)
        let spawnSequence_b = SKAction.sequence([wait_b, spawn_b])
        let spawnForever_b = SKAction.repeatActionForever(spawnSequence_b)
        self.runAction(spawnForever_b, withKey: "spawningEnemies_two")
        
        let spawn_o =  SKAction.runBlock(spawnOranges)
        let spawnSequence_o = SKAction.sequence([wait_o, spawn_o])
        let spawnForever_o = SKAction.repeatActionForever(spawnSequence_o)
        self.runAction(spawnForever_o, withKey: "spawningEnemies_three")
        
        let spawn_g =  SKAction.runBlock(spawnGrapes)
        let spawnSequence_g = SKAction.sequence([wait_g, spawn_g])
        let spawnForever_g = SKAction.repeatActionForever(spawnSequence_g)
        self.runAction(spawnForever_g, withKey: "spawningEnemies_four")
        
        let spawn_w =  SKAction.runBlock(spawnWatermelons)
        let spawnSequence_w = SKAction.sequence([wait_w, spawn_w])
        let spawnForever_w = SKAction.repeatActionForever(spawnSequence_w)
        self.runAction(spawnForever_w, withKey: "spawningEnemies_five")
        
        let spawn_life =  SKAction.runBlock(spawnLife)
        let spawnSequence_life = SKAction.sequence([wait_life, spawn_life])
        let spawnForever_life = SKAction.repeatActionForever(spawnSequence_life)
        self.runAction(spawnForever_life, withKey: "spawningEnemies_six")
        
        let spawn_ice =  SKAction.runBlock(spawnIceCube)
        let spawnSequence_ice = SKAction.sequence([wait_ice, spawn_ice])
        let spawnForever_ice = SKAction.repeatActionForever(spawnSequence_ice)
        self.runAction(spawnForever_ice, withKey: "spawningEnemies_seven")
    }
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func changeSceneToIntro(){
        let sceneToMoveTo = IntroductionScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fadeWithDuration(0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    
    //.............................................................................................. this function will run as soon as the scene loads up
    
    override func didMoveToView(view: SKView) {
        
        if currentGameState == gameState.preGame{
            let changeSceneActionIntro = SKAction.runBlock(changeSceneToIntro)
            let waitToChangeSceneToIntro = SKAction.waitForDuration(1)
            let changeSceneSequenceToIntro = SKAction.sequence([waitToChangeSceneToIntro, changeSceneActionIntro])
            self.runAction(changeSceneSequenceToIntro)
        }
        
        if currentGameState == gameState.introGame || currentGameState == gameState.afterGame{
            
            currentGameState = gameState.preGame
            self.physicsWorld.contactDelegate = self
            
            let background = SKSpriteNode(imageNamed: "blue_background")
            background.setScale(4)
            background.size = self.size
            background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            background.zPosition = 0
            self.addChild(background)
            
            player.setScale(0.2)
            player.position = CGPoint(x: -player.size.width, y: self.size.height/5)
            player.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: player.size.width, height: player.size.height * 0.3)) //player.size
            player.physicsBody!.affectedByGravity = false
            player.physicsBody!.categoryBitMask = PhysicsCategories.Player
            player.physicsBody!.collisionBitMask = PhysicsCategories.None
            player.physicsBody!.contactTestBitMask = PhysicsCategories.Apple | PhysicsCategories.Orange | PhysicsCategories.Banana
            PhysicsCategories.Watermelon | PhysicsCategories.Grape
            player.zPosition = 2
            self.addChild(player)
            
            scoreLabel.text = "Score: 0"
            scoreLabel.fontSize = 70
            scoreLabel.fontColor = SKColor.blackColor()
            scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            scoreLabel.position = CGPoint(x: self.size.width*0.15, y: self.size.height + scoreLabel.frame.size.height)
            scoreLabel.zPosition = 75
            self.addChild(scoreLabel)
            
            livesLabel.text = "Lives: 3"
            livesLabel.fontSize = 70
            livesLabel.fontColor = SKColor.blackColor()
            livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
            livesLabel.position = CGPoint(x: self.size.width*0.85, y: self.size.height + scoreLabel.frame.size.height)
            livesLabel.zPosition = 75
            self.addChild(livesLabel)
            
            
            //was *0.9
            let moveOntoScreen = SKAction.moveToY(self.size.height*0.5, duration: 0.01)
            scoreLabel.runAction(moveOntoScreen)
            livesLabel.runAction(moveOntoScreen)
            
            tapToStartLabel.text = "| Tap to Begin |"
            tapToStartLabel.fontSize = 100
            tapToStartLabel.fontColor = SKColor.blackColor()
            tapToStartLabel.zPosition = 1
            tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            tapToStartLabel.alpha = 0
            self.addChild(tapToStartLabel)
            
            let fadeInAction = SKAction.fadeInWithDuration(0.3)
            tapToStartLabel.runAction(fadeInAction)
        }
    }
    
    func addScorePlusThree(){
        gameScore += 3
        scoreLabel.text = "Score: \(gameScore)"
        startNewLevel()
    }
    
    func addScorePlusfive(){
        gameScore += 5
        scoreLabel.text = "Score: \(gameScore)"
        startNewLevel()
    }
    
    func addScorePlusOne(){
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        startNewLevel()
    }
    
    func loseALife(){
        LivesNumber -= 1
        livesLabel.text = "Lives: \(LivesNumber)"
        
        let scaleUp = SKAction.scaleTo(1.5, duration: 0.2)
        let scaleDown = SKAction.scaleTo(1.0, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp,scaleDown])
        livesLabel.runAction(scaleSequence)
        
        if LivesNumber == 0{
            runGameOver()
        }
    }
    
    func addALife(){
        LivesNumber += 1
        livesLabel.text = "Lives: \(LivesNumber)"
        
        let scaleUp_add = SKAction.scaleTo(1.5, duration: 0.2)
        let scaleDown_add = SKAction.scaleTo(1.0, duration: 0.2)
        let scaleSequence_add = SKAction.sequence([scaleUp_add,scaleDown_add])
        livesLabel.runAction(scaleSequence_add)
    }
    
    func spawnPlusOne(spawnPosition: CGPoint){
        
        let plus_one = SKSpriteNode(imageNamed: "the_plus_one")
        plus_one.position = spawnPosition
        plus_one.setScale(0)
        plus_one.zPosition = 2
        self.addChild(plus_one)
        
        let fadeOut_plus_one = SKAction.fadeOutWithDuration(0.1)
        let scaleIn = SKAction.scaleTo(0.1, duration: 0.1)
        let endPointPlusOne = CGPoint(x: spawnPosition.x, y: spawnPosition.y + 700)
        let delete_plus_one = SKAction.removeFromParent()
        let move_plus_one = SKAction.moveTo(endPointPlusOne, duration: 0.75)
        
        let plusOneSequence = SKAction.sequence([scaleIn, move_plus_one, fadeOut_plus_one, delete_plus_one])
        
        plus_one.runAction(plusOneSequence)
        
    }
    func spawnPlusThree(spawnPosition: CGPoint){
        
        let plus_three = SKSpriteNode(imageNamed: "the_plus_three")
        plus_three.position = spawnPosition
        plus_three.setScale(0)
        plus_three.zPosition = 2
        self.addChild(plus_three)
        
        let fadeOut_plus_three = SKAction.fadeOutWithDuration(0.1)
        let scaleIn = SKAction.scaleTo(0.1, duration: 0.1)
        let endPointPlusThree = CGPoint(x: spawnPosition.x, y: spawnPosition.y + 700)
        let delete_plus_three = SKAction.removeFromParent()
        let move_plus_three = SKAction.moveTo(endPointPlusThree, duration: 0.75)
        
        let plusThreeSequence = SKAction.sequence([scaleIn, move_plus_three, fadeOut_plus_three, delete_plus_three])
        
        plus_three.runAction(plusThreeSequence)
        
    }
    func spawnPlusFive(spawnPosition: CGPoint){
        
        let plus_five = SKSpriteNode(imageNamed: "the_plus_five")
        plus_five.position = spawnPosition
        plus_five.setScale(0)
        plus_five.zPosition = 2
        self.addChild(plus_five)
        
        let fadeOut_five = SKAction.fadeOutWithDuration(0.1)
        let scaleIn = SKAction.scaleTo(0.1, duration: 0.1)
        let endPointPlusFive = CGPoint(x: spawnPosition.x, y: spawnPosition.y + 700)
        let delete_plus_five = SKAction.removeFromParent()
        let move_plus_five = SKAction.moveTo(endPointPlusFive, duration: 0.75)
        
        let plusFiveSequence = SKAction.sequence([scaleIn, move_plus_five, fadeOut_five, delete_plus_five])
        
        plus_five.runAction(plusFiveSequence)
        
    }
    
    func spawnExplosion(spawnPosition: CGPoint){
        
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.setScale(0)
        explosion.zPosition = 1
        self.addChild(explosion)
        
        let scaleIn = SKAction.scaleTo(0.4, duration: 0.1)
        let fadeOut = SKAction.fadeOutWithDuration(0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([scaleIn, fadeOut, delete])
        
        explosion.runAction(explosionSequence)
    }
    
    func spawnLifeExplosion(spawnPosition: CGPoint){
        let explosion_life = SKSpriteNode(imageNamed: "life_explosion")
        explosion_life.position = spawnPosition
        explosion_life.setScale(0)
        explosion_life.zPosition = 1
        self.addChild(explosion_life)
        
        let scaleIn_life = SKAction.scaleTo(0.4, duration: 0.1)
        let fadeOut_life = SKAction.fadeOutWithDuration(0.1)
        let delete_life = SKAction.removeFromParent()
        let explosionSequence_life = SKAction.sequence([scaleIn_life, fadeOut_life, delete_life])
        explosion_life.runAction(explosionSequence_life)
    }
    
    func spawnIceExplosion(spawnPosition: CGPoint){
        let explosion_ice = SKSpriteNode(imageNamed: "ice_explosion")
        explosion_ice.position = spawnPosition
        explosion_ice.setScale(0)
        explosion_ice.zPosition = 1
        self.addChild(explosion_ice)
        
        let scaleIn_ice = SKAction.scaleTo(0.4, duration: 0.1)
        let fadeOut_ice = SKAction.fadeOutWithDuration(0.1)
        let delete_ice = SKAction.removeFromParent()
        let explosionSequence_ice = SKAction.sequence([scaleIn_ice, fadeOut_ice, delete_ice])
        explosion_ice.runAction(explosionSequence_ice)
    }
    
    func spawnApples(){
        
        let enemy_one = SKSpriteNode(imageNamed: "apple")
        enemy_one.physicsBody = SKPhysicsBody(rectangleOfSize: enemy_one.size)
        
        let randomXStart = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        var startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.1)
        var endPoint = CGPoint(x: randomXStart, y: -self.size.height * 0.1)
        
        if randomXStart > CGRectGetMaxX(gameArea) - enemy_one.size.width/2{
            startPoint = CGPoint(x: CGRectGetMaxX(gameArea) - enemy_one.size.width/2, y: self.size.height * 1.1)
            endPoint = CGPoint(x: CGRectGetMaxX(gameArea) - enemy_one.size.width/2, y: -self.size.height * 0.1)
        }
        
        if randomXStart < CGRectGetMinX(gameArea) + player.size.width/2{
            startPoint = CGPoint(x: CGRectGetMinX(gameArea) + enemy_one.size.width/2, y: self.size.height * 1.1)
            endPoint = CGPoint(x: CGRectGetMinX(gameArea) + enemy_one.size.width/2, y: -self.size.height * 0.1)
        }
        
        enemy_one.name = "Apple"
        enemy_one.setScale(0.2)
        enemy_one.position = startPoint
        enemy_one.zPosition = 1
        enemy_one.physicsBody!.affectedByGravity = false
        enemy_one.physicsBody!.categoryBitMask = PhysicsCategories.Apple
        enemy_one.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy_one.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        self.addChild(enemy_one)
        
        
        if currentGameState == gameState.inGame{
            let move_enemy_one = SKAction.moveTo(endPoint, duration: fall_time_apple)
            let delete_enemy_one = SKAction.removeFromParent()
            let loseALifeAction = SKAction.runBlock(loseALife)
            let enemy_one_sequence = SKAction.sequence([move_enemy_one, delete_enemy_one, loseALifeAction])
            enemy_one.runAction(enemy_one_sequence)
        }
        
        if currentGameState == gameState.freezeGame{
            let move_enemy_one = SKAction.moveTo(endPoint, duration: 15)
            let delete_enemy_one = SKAction.removeFromParent()
            let loseALifeAction = SKAction.runBlock(loseALife)
            let enemy_one_sequence = SKAction.sequence([move_enemy_one, delete_enemy_one, loseALifeAction])
            enemy_one.runAction(enemy_one_sequence)
        }
    }
    
    func spawnBananas(){
        
        let enemy_two = SKSpriteNode(imageNamed: "banana")
        enemy_two.physicsBody = SKPhysicsBody(rectangleOfSize: enemy_two.size)
        
        let randomXStart_two = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        var startPoint_two = CGPoint(x: randomXStart_two, y: self.size.height * 1.1)
        var endPoint_two = CGPoint(x: randomXStart_two, y: -self.size.height * 0.1)
        
        if randomXStart_two > CGRectGetMaxX(gameArea) - enemy_two.size.width/2{
            startPoint_two = CGPoint(x: CGRectGetMaxX(gameArea) - enemy_two.size.width/2, y: self.size.height * 1.1)
            endPoint_two = CGPoint(x: CGRectGetMaxX(gameArea) - enemy_two.size.width/2, y: -self.size.height * 0.1)
        }
        
        if randomXStart_two < CGRectGetMinX(gameArea) + player.size.width/2{
            startPoint_two = CGPoint(x: CGRectGetMinX(gameArea) + enemy_two.size.width/2, y: self.size.height * 1.1)
            endPoint_two = CGPoint(x: CGRectGetMinX(gameArea) + enemy_two.size.width/2, y: -self.size.height * 0.1)
        }
        
        enemy_two.name = "Banana"
        enemy_two.setScale(0.2)
        enemy_two.position = startPoint_two
        enemy_two.zPosition = 1
        enemy_two.physicsBody!.affectedByGravity = false
        enemy_two.physicsBody!.categoryBitMask = PhysicsCategories.Banana
        enemy_two.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy_two.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        self.addChild(enemy_two)
        
        if currentGameState == gameState.inGame{
            let move_enemy_two = SKAction.moveTo(endPoint_two, duration: fall_time_banana)
            let delete_enemy_two = SKAction.removeFromParent()
            let loseALifeAction_two = SKAction.runBlock(loseALife)
            let enemy_two_sequence = SKAction.sequence([move_enemy_two, delete_enemy_two,loseALifeAction_two])
            enemy_two.runAction(enemy_two_sequence)
        }
        
        if currentGameState == gameState.freezeGame{
            let move_enemy_two = SKAction.moveTo(endPoint_two, duration: 15)
            let delete_enemy_two = SKAction.removeFromParent()
            let loseALifeAction_two = SKAction.runBlock(loseALife)
            let enemy_two_sequence = SKAction.sequence([move_enemy_two, delete_enemy_two,loseALifeAction_two])
            enemy_two.runAction(enemy_two_sequence)
        }
    }
    
    func spawnGrapes(){
        
        let enemy_three = SKSpriteNode(imageNamed: "grapes")
        enemy_three.physicsBody = SKPhysicsBody(rectangleOfSize: enemy_three.size)
        
        let randomXStart_three = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        var startPoint_three = CGPoint(x: randomXStart_three, y: self.size.height * 1.1)
        var endPoint_three = CGPoint(x: randomXStart_three, y: -self.size.height * 0.1)
        
        if randomXStart_three > CGRectGetMaxX(gameArea) - enemy_three.size.width/2{
            startPoint_three = CGPoint(x: CGRectGetMaxX(gameArea) - enemy_three.size.width/2, y: self.size.height * 1.1)
            endPoint_three = CGPoint(x: CGRectGetMaxX(gameArea) - enemy_three.size.width/2, y: -self.size.height * 0.1)
        }
        
        if randomXStart_three < CGRectGetMinX(gameArea) + player.size.width/2{
            startPoint_three = CGPoint(x: CGRectGetMinX(gameArea) + enemy_three.size.width/2, y: self.size.height * 1.1)
            endPoint_three = CGPoint(x: CGRectGetMinX(gameArea) + enemy_three.size.width/2, y: -self.size.height * 0.1)
        }
        
        enemy_three.name = "Grape"
        enemy_three.setScale(0.2)
        enemy_three.position = startPoint_three
        enemy_three.zPosition = 1
        enemy_three.physicsBody!.affectedByGravity = false
        enemy_three.physicsBody!.categoryBitMask = PhysicsCategories.Grape
        enemy_three.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy_three.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        self.addChild(enemy_three)
        
        if currentGameState == gameState.inGame{
            let move_enemy_three = SKAction.moveTo(endPoint_three, duration: fall_time_grape)
            let delete_enemy_three = SKAction.removeFromParent()
            let loseALifeAction_three = SKAction.runBlock(loseALife)
            let enemy_three_sequence = SKAction.sequence([move_enemy_three, delete_enemy_three, loseALifeAction_three])
            enemy_three.runAction(enemy_three_sequence)
        }
        
        if currentGameState == gameState.freezeGame{
            let move_enemy_three = SKAction.moveTo(endPoint_three, duration: 15)
            let delete_enemy_three = SKAction.removeFromParent()
            let loseALifeAction_three = SKAction.runBlock(loseALife)
            let enemy_three_sequence = SKAction.sequence([move_enemy_three, delete_enemy_three, loseALifeAction_three])
            enemy_three.runAction(enemy_three_sequence)
        }
    }
    
    func spawnOranges(){
        
        let enemy_four = SKSpriteNode(imageNamed: "orange")
        enemy_four.physicsBody = SKPhysicsBody(rectangleOfSize: enemy_four.size)
        
        let randomXStart_four = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        var startPoint_four = CGPoint(x: randomXStart_four, y: self.size.height * 1.1)
        var endPoint_four = CGPoint(x: randomXStart_four, y: -self.size.height * 0.1)
        
        if randomXStart_four > CGRectGetMaxX(gameArea) - enemy_four.size.width/2{
            startPoint_four = CGPoint(x: CGRectGetMaxX(gameArea) - enemy_four.size.width/2, y: self.size.height * 1.1)
            endPoint_four = CGPoint(x: CGRectGetMaxX(gameArea) - enemy_four.size.width/2, y: -self.size.height * 0.1)
        }
        
        if randomXStart_four < CGRectGetMinX(gameArea) + player.size.width/2{
            startPoint_four = CGPoint(x: CGRectGetMinX(gameArea) + enemy_four.size.width/2, y: self.size.height * 1.1)
            endPoint_four = CGPoint(x: CGRectGetMinX(gameArea) + enemy_four.size.width/2, y: -self.size.height * 0.1)
        }
        
        enemy_four.name = "Orange"
        enemy_four.setScale(0.2)
        enemy_four.position = startPoint_four
        enemy_four.zPosition = 1
        enemy_four.physicsBody!.affectedByGravity = false
        enemy_four.physicsBody!.categoryBitMask = PhysicsCategories.Orange
        enemy_four.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy_four.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        self.addChild(enemy_four)
        
        if currentGameState == gameState.inGame{
            let move_enemy_four = SKAction.moveTo(endPoint_four, duration: fall_time_orange)
            let delete_enemy_four = SKAction.removeFromParent()
            let loseALifeAction_four = SKAction.runBlock(loseALife)
            let enemy_four_sequence = SKAction.sequence([move_enemy_four, delete_enemy_four, loseALifeAction_four])
            enemy_four.runAction(enemy_four_sequence)
        }
        
        if currentGameState == gameState.freezeGame{
            let move_enemy_four = SKAction.moveTo(endPoint_four, duration: 15)
            let delete_enemy_four = SKAction.removeFromParent()
            let loseALifeAction_four = SKAction.runBlock(loseALife)
            let enemy_four_sequence = SKAction.sequence([move_enemy_four, delete_enemy_four, loseALifeAction_four])
            enemy_four.runAction(enemy_four_sequence)
        }
    }
    
    func spawnWatermelons(){
        
        let enemy_five = SKSpriteNode(imageNamed: "watermelon")
        enemy_five.physicsBody = SKPhysicsBody(rectangleOfSize: enemy_five.size)
        
        let randomXStart_five = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        var startPoint_five = CGPoint(x: randomXStart_five, y: self.size.height * 1.1)
        var endPoint_five = CGPoint(x: randomXStart_five, y: -self.size.height * 0.1)
        
        if randomXStart_five > CGRectGetMaxX(gameArea) - enemy_five.size.width/2{
            startPoint_five = CGPoint(x: CGRectGetMaxX(gameArea) - enemy_five.size.width/2, y: self.size.height * 1.1)
            endPoint_five = CGPoint(x: CGRectGetMaxX(gameArea) - enemy_five.size.width/2, y: -self.size.height * 0.1)
        }
        
        if randomXStart_five < CGRectGetMinX(gameArea) + player.size.width/2{
            startPoint_five = CGPoint(x: CGRectGetMinX(gameArea) + enemy_five.size.width/2, y: self.size.height * 1.1)
            endPoint_five = CGPoint(x: CGRectGetMinX(gameArea) + enemy_five.size.width/2, y: -self.size.height * 0.1)
        }
        
        enemy_five.name = "Watermelon"
        enemy_five.setScale(0.2)
        enemy_five.position = startPoint_five
        enemy_five.zPosition = 1
        enemy_five.physicsBody!.affectedByGravity = false
        enemy_five.physicsBody!.categoryBitMask = PhysicsCategories.Watermelon
        enemy_five.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy_five.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        self.addChild(enemy_five)
        
        if currentGameState == gameState.inGame{
            let move_enemy_five = SKAction.moveTo(endPoint_five, duration: fall_time_watermelon)
            let delete_enemy_five = SKAction.removeFromParent()
            let loseALifeAction_five = SKAction.runBlock(loseALife)
            let enemy_five_sequence = SKAction.sequence([move_enemy_five, delete_enemy_five, loseALifeAction_five])
            enemy_five.runAction(enemy_five_sequence)
        }
        
        if currentGameState == gameState.freezeGame{
            let move_enemy_five = SKAction.moveTo(endPoint_five, duration: 15)
            let delete_enemy_five = SKAction.removeFromParent()
            let loseALifeAction_five = SKAction.runBlock(loseALife)
            let enemy_five_sequence = SKAction.sequence([move_enemy_five, delete_enemy_five, loseALifeAction_five])
            enemy_five.runAction(enemy_five_sequence)
        }
        
    }
    
    func spawnLife(){
        
        let enemy_six = SKSpriteNode(imageNamed: "the_life")
        enemy_six.physicsBody = SKPhysicsBody(rectangleOfSize: enemy_six.size)
        
        let randomXStart_six = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        var startPoint_six = CGPoint(x: randomXStart_six, y: self.size.height * 1.1)
        var endPoint_six = CGPoint(x: randomXStart_six, y: -self.size.height * 0.1)
        
        if randomXStart_six > CGRectGetMaxX(gameArea) - enemy_six.size.width/2{
            startPoint_six = CGPoint(x: CGRectGetMaxX(gameArea) - enemy_six.size.width/2, y: self.size.height * 1.1)
            endPoint_six = CGPoint(x: CGRectGetMaxX(gameArea) - enemy_six.size.width/2, y: -self.size.height * 0.1)
        }
        
        if randomXStart_six < CGRectGetMinX(gameArea) + player.size.width/2{
            startPoint_six = CGPoint(x: CGRectGetMinX(gameArea) + enemy_six.size.width/2, y: self.size.height * 1.1)
            endPoint_six = CGPoint(x: CGRectGetMinX(gameArea) + enemy_six.size.width/2, y: -self.size.height * 0.1)
        }
        
        enemy_six.name = "Life"
        enemy_six.setScale(0.12)
        enemy_six.position = startPoint_six
        enemy_six.zPosition = 1
        enemy_six.physicsBody!.affectedByGravity = false
        enemy_six.physicsBody!.categoryBitMask = PhysicsCategories.Life
        enemy_six.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy_six.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        self.addChild(enemy_six)
        
        if currentGameState == gameState.inGame{
            let move_enemy_six = SKAction.moveTo(endPoint_six, duration: fall_time_life)
            let delete_enemy_six = SKAction.removeFromParent()
            let enemy_six_sequence = SKAction.sequence([move_enemy_six, delete_enemy_six])
            enemy_six.runAction(enemy_six_sequence)
        }
    }
    
    func spawnIceCube(){
        
        let enemy_seven = SKSpriteNode(imageNamed: "the_ice")
        enemy_seven.physicsBody = SKPhysicsBody(rectangleOfSize: enemy_seven.size)
        
        let randomXStart_seven = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        var startPoint_seven = CGPoint(x: randomXStart_seven, y: self.size.height * 1.1)
        var endPoint_seven = CGPoint(x: randomXStart_seven, y: -self.size.height * 0.1)
        
        if randomXStart_seven > CGRectGetMaxX(gameArea) - enemy_seven.size.width/2{
            startPoint_seven = CGPoint(x: CGRectGetMaxX(gameArea) - enemy_seven.size.width/2, y: self.size.height * 1.1)
            endPoint_seven = CGPoint(x: CGRectGetMaxX(gameArea) - enemy_seven.size.width/2, y: -self.size.height * 0.1)
        }
        
        if randomXStart_seven < CGRectGetMinX(gameArea) + player.size.width/2{
            startPoint_seven = CGPoint(x: CGRectGetMinX(gameArea) + enemy_seven.size.width/2, y: self.size.height * 1.1)
            endPoint_seven = CGPoint(x: CGRectGetMinX(gameArea) + enemy_seven.size.width/2, y: -self.size.height * 0.1)
        }
        
        enemy_seven.name = "Ice"
        enemy_seven.setScale(0.10)
        enemy_seven.position = startPoint_seven
        enemy_seven.zPosition = 1
        enemy_seven.physicsBody!.affectedByGravity = false
        enemy_seven.physicsBody!.categoryBitMask = PhysicsCategories.Ice
        enemy_seven.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy_seven.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        self.addChild(enemy_seven)
        
        if currentGameState == gameState.inGame{
            let move_enemy_seven = SKAction.moveTo(endPoint_seven, duration: fall_time_ice)
            let delete_enemy_seven = SKAction.removeFromParent()
            let enemy_seven_sequence = SKAction.sequence([move_enemy_seven, delete_enemy_seven])
            enemy_seven.runAction(enemy_seven_sequence)
        }
    }
}


/*
import Foundation
import SpriteKit



class GameSceneTwo: SKScene, SKPhysicsContactDelegate {

    var levelNumber_a = 0
    var levelNumber_b = 0
    var levelNumber_g = 0
    var levelNumber_o = 0
    var levelNumber_w = 0
    var LivesNumber = 3
    let scoreLabel = SKLabelNode(fontNamed: "Brain Flower Euro")
    let livesLabel = SKLabelNode(fontNamed: "Brain Flower Euro")

    let player = SKSpriteNode(imageNamed: "box")
    var gameArea: CGRect

    let tapToStartLabel = SKLabelNode(fontNamed: "Brain Flower Euro")
    
    func startGame(){
        currentGameState = gameState.inGame
        let fadeOutAction = SKAction.fadeInWithDuration(0.01)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction,deleteAction])
        tapToStartLabel.runAction(deleteSequence)
        
        let startLevelAction = SKAction.runBlock(startNewLevel)
        let startGameSequence = SKAction.sequence([startLevelAction])
        player.runAction(startGameSequence)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if currentGameState == gameState.preGame{
            startGame()
        }
        for touch: AnyObject in touches{
            let touchPosition = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(touchPosition)
            if (touchedNode.name == "Apple") {
                touchedNode.removeFromParent()
                addScore()
            }
            if (touchedNode.name == "Banana") {
                touchedNode.removeFromParent()
                addScore()
            }
            if (touchedNode.name == "Grape") {
                touchedNode.removeFromParent()
                addScore()
            }
            if (touchedNode.name == "Orange") {
                touchedNode.removeFromParent()
                addScore()
            }
            if (touchedNode.name == "Watermelon") {
                touchedNode.removeFromParent()
                addScore()
            }
        }
    }
    
    //...................................................................................it will start at this state
    
    func runGameOver(){
        
        self.removeAllActions()
        
        //...................................................................................makes a list of THAT object and goes through the list to delete each instance of the object
        self.enumerateChildNodesWithName("Apple"){
            apple, stop in
            apple.removeAllActions()
        }
        
        self.enumerateChildNodesWithName("Banana"){
            banana, stop in
            banana.removeAllActions()
        }
        self.enumerateChildNodesWithName("Grape"){
            grape, stop in
            grape.removeAllActions()
        }
        self.enumerateChildNodesWithName("Orange"){
            orange, stop in
            orange.removeAllActions()
        }
        self.enumerateChildNodesWithName("Watermelon"){
            watermelon, stop in
            watermelon.removeAllActions()
        }
        
        currentGameState = gameState.afterGame
        
        let changeSceneAction = SKAction.runBlock(changeScene)
        let waitToChangeScene = SKAction.waitForDuration(1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.runAction(changeSceneSequence)
    }
    
    func changeScene(){
        let sceneToMoveTo = GameOverSceneTwo(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fadeWithDuration(0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    override init(size: CGSize) {
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height/maxAspectRatio
        let margin = (size.width - playableWidth)/2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
    }
    
    struct PhysicsCategories{
        static let None : UInt32 = 0                // 0
        static let Player : UInt32 = 0b1            // 1
        static let Enemy : UInt32 = 0b10            // 2
    }
    
    //................................................................................................  this function controlls the frequency of spawn
    func startNewLevel(){
        
        levelNumber_a += 1
        levelNumber_b += 1
        levelNumber_g += 1
        levelNumber_o += 1
        levelNumber_w += 1
        
        //...........................................................................................  this allows us to stop the current level with it's special key and start a new one
        if self.actionForKey("spawningEnemies_one") != nil{
            self.removeActionForKey("spawningEnemies_one")
        }
        if self.actionForKey("spawningEnemies_two") != nil{
            self.removeActionForKey("spawningEnemies_two")
        }
        if self.actionForKey("spawningEnemies_three") != nil{
            self.removeActionForKey("spawningEnemies_three")
        }
        if self.actionForKey("spawningEnemies_four") != nil{
            self.removeActionForKey("spawningEnemies_four")
        }
        if self.actionForKey("spawningEnemies_five") != nil{
            self.removeActionForKey("spawningEnemies_five")
        }
        
        var levelDuration_a = NSTimeInterval()
        var levelDuration_b = NSTimeInterval()
        var levelDuration_g = NSTimeInterval()
        var levelDuration_o = NSTimeInterval()
        var levelDuration_w = NSTimeInterval()
        
        //...........................................................................................  level duration would signify the frequency of falling
        
        switch levelNumber_a{
        case 1: levelDuration_a = 6
        case 2: levelDuration_a = 5.5
        case 3: levelDuration_a = 3.7
        case 4: levelDuration_a = 2.8
        default:
            levelDuration_a = 0.5
            print("cannot find level number information")
        }
        
        switch levelNumber_b{
        case 1: levelDuration_b = 6.4
        case 2: levelDuration_b = 5
        case 3: levelDuration_b = 3.3
        case 4: levelDuration_b = 2.6
        default:
            levelDuration_b = 0.5
            print("cannot find level number information")
        }
        
        switch levelNumber_g{
        case 1: levelDuration_g = 5.7
        case 2: levelDuration_g = 5.3
        case 3: levelDuration_g = 3.4
        case 4: levelDuration_g = 2.7
        default:
            levelDuration_b = 0.5
            print("cannot find level number information")
        }
        
        switch levelNumber_o{
        case 1: levelDuration_o = 6.2
        case 2: levelDuration_o = 5.1
        case 3: levelDuration_o = 3.6
        case 4: levelDuration_o = 2.9
        default:
            levelDuration_o = 0.5
            print("cannot find level number information")
        }
        
        switch levelNumber_w{
        case 1: levelDuration_w = 6.7
        case 2: levelDuration_w = 5.9
        case 3: levelDuration_w = 3.9
        case 4: levelDuration_w = 3.0
        default:
            levelDuration_w = 0.5
            print("cannot find level number information")
        }
        
        let spawn =  SKAction.runBlock(spawnApples)
        let waitToSpawn = SKAction.waitForDuration(levelDuration_a)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatActionForever(spawnSequence)
        self.runAction(spawnForever, withKey: "spawningEnemies_one")
        
        let spawn_two =  SKAction.runBlock(spawnBananas)
        let waitToSpawn_two = SKAction.waitForDuration(levelDuration_b)
        let spawnSequence_two = SKAction.sequence([waitToSpawn_two, spawn_two])
        let spawnForever_two = SKAction.repeatActionForever(spawnSequence_two)
        self.runAction(spawnForever_two, withKey: "spawningEnemies_two")
        
        let spawn_three =  SKAction.runBlock(spawnGrapes)
        let waitToSpawn_three = SKAction.waitForDuration(levelDuration_g)
        let spawnSequence_three = SKAction.sequence([waitToSpawn_three, spawn_three])
        let spawnForever_three = SKAction.repeatActionForever(spawnSequence_three)
        self.runAction(spawnForever_three, withKey: "spawningEnemies_three")
        
        let spawn_four =  SKAction.runBlock(spawnOranges)
        let waitToSpawn_four = SKAction.waitForDuration(levelDuration_o)
        let spawnSequence_four = SKAction.sequence([waitToSpawn_four, spawn_four])
        let spawnForever_four = SKAction.repeatActionForever(spawnSequence_four)
        self.runAction(spawnForever_four, withKey: "spawningEnemies_four")
        
        let spawn_five =  SKAction.runBlock(spawnWatermelons)
        let waitToSpawn_five = SKAction.waitForDuration(levelDuration_w)
        let spawnSequence_five = SKAction.sequence([waitToSpawn_five, spawn_five])
        let spawnForever_five = SKAction.repeatActionForever(spawnSequence_five)
        self.runAction(spawnForever_five, withKey: "spawningEnemies_five")
    }
    
    
    //.............................................................................................. function that randomizes how the fruits spawn
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
    
    //.............................................................................................. something that was added to by the error produced
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func changeSceneToIntro(){
        let sceneToMoveTo = IntroductionScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fadeWithDuration(0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    
    //.............................................................................................. this function will run as soon as the scene loads up
    
    override func didMoveToView(view: SKView) {
        
        if currentGameState == gameState.preGame{
            let changeSceneActionIntro = SKAction.runBlock(changeSceneToIntro)
            let waitToChangeSceneToIntro = SKAction.waitForDuration(1)
            let changeSceneSequenceToIntro = SKAction.sequence([waitToChangeSceneToIntro, changeSceneActionIntro])
            self.runAction(changeSceneSequenceToIntro)
        }
        
        if currentGameState == gameState.introGame || currentGameState == gameState.afterGame{
            
            currentGameState = gameState.preGame
            
            //................................................................................................without this, the fruits would not disappear with contact
            
            self.physicsWorld.contactDelegate = self
            
            let background = SKSpriteNode(imageNamed: "blue_background")
            background.setScale(4)
            background.size = self.size
            background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            background.zPosition = 0
            self.addChild(background)
            
            
            //.............................................................................................. for the box
            player.setScale(0.2)
            player.position = CGPoint(x: -player.size.width, y: self.size.height/5)
            player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
            player.physicsBody!.affectedByGravity = false
            player.physicsBody!.categoryBitMask = PhysicsCategories.Player
            //.............................................................................................. collisions will not happpen
            player.physicsBody!.collisionBitMask = PhysicsCategories.None
            //.............................................................................................. tells which objects it may come into contact with
            player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
            player.zPosition = 2
            self.addChild(player)
            
            scoreLabel.text = "Score: 0"
            scoreLabel.fontSize = 70
            scoreLabel.fontColor = SKColor.blackColor()
            scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            scoreLabel.position = CGPoint(x: self.size.width*0.15, y: self.size.height + scoreLabel.frame.size.height)
            scoreLabel.zPosition = 75
            self.addChild(scoreLabel)
            
            livesLabel.text = "Lives: 3"
            livesLabel.fontSize = 70
            livesLabel.fontColor = SKColor.blackColor()
            livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
            livesLabel.position = CGPoint(x: self.size.width*0.85, y: self.size.height + scoreLabel.frame.size.height)
            livesLabel.zPosition = 75
            self.addChild(livesLabel)
            
            let moveOntoScreen = SKAction.moveToY(self.size.height*0.9, duration: 0.01)
            scoreLabel.runAction(moveOntoScreen)
            livesLabel.runAction(moveOntoScreen)
            
            tapToStartLabel.text = "--- Tap to Begin ---"
            tapToStartLabel.fontSize = 100
            tapToStartLabel.fontColor = SKColor.blackColor()
            tapToStartLabel.zPosition = 1
            tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            tapToStartLabel.alpha = 0
            self.addChild(tapToStartLabel)
            
            let fadeInAction = SKAction.fadeInWithDuration(0.3)
            tapToStartLabel.runAction(fadeInAction)
        }
    }
    
    func addScore(){
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        
        if gameScore == 10 || gameScore == 30 || gameScore == 50{
            startNewLevel()
        }
    }
    
    func loseALife(){
        LivesNumber -= 1
        livesLabel.text = "Lives: \(LivesNumber)"
        
        let scaleUp = SKAction.scaleTo(1.5, duration: 0.2)
        let scaleDown = SKAction.scaleTo(1.0, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp,scaleDown])
        livesLabel.runAction(scaleSequence)
        
        if LivesNumber == 0{
            runGameOver()
        }
    }
    
    //.............................................................................................. this function spawns an explosion at the location of contact
    
    func spawnExplosion(spawnPosition: CGPoint){
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.setScale(0)
        explosion.zPosition = 1
        self.addChild(explosion)
        
        let scaleIn = SKAction.scaleTo(1, duration: 0.1)
        let fadeOut = SKAction.fadeOutWithDuration(0.1)
        let delete = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([scaleIn, fadeOut, delete])
        explosion.runAction(explosionSequence)
    }
    
    
    func spawnApples(){
        
        let randomXStart = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXStart, y: -self.size.height * 0.2)
    
        let enemy_one = SKSpriteNode(imageNamed: "apple")
        enemy_one.name = "Apple"
        enemy_one.setScale(0.2)
        enemy_one.position = startPoint
        enemy_one.zPosition = 1
        enemy_one.physicsBody = SKPhysicsBody(rectangleOfSize: enemy_one.size)
        enemy_one.physicsBody!.affectedByGravity = false
        enemy_one.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy_one.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy_one.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        self.addChild(enemy_one)
        
        let move_enemy_one = SKAction.moveTo(endPoint, duration: 20)
        let delete_enemy_one = SKAction.removeFromParent()
        let loseALifeAction = SKAction.runBlock(loseALife)
        let enemy_one_sequence = SKAction.sequence([move_enemy_one, delete_enemy_one, loseALifeAction])
        
        if currentGameState == gameState.inGame{
            enemy_one.runAction(enemy_one_sequence)
        }
    }
    
    func spawnBananas(){
        
        let randomXStart_two = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        let startPoint_two = CGPoint(x: randomXStart_two, y: self.size.height * 1.2)
        let endPoint_two = CGPoint(x: randomXStart_two, y: -self.size.height * 0.2)
        
        let enemy_two = SKSpriteNode(imageNamed: "banana")
        enemy_two.name = "Banana"
        enemy_two.setScale(0.2)
        enemy_two.position = startPoint_two
        enemy_two.zPosition = 1
        enemy_two.physicsBody = SKPhysicsBody(rectangleOfSize: enemy_two.size)
        enemy_two.physicsBody!.affectedByGravity = false
        enemy_two.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy_two.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy_two.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        self.addChild(enemy_two)
        
        let move_enemy_two = SKAction.moveTo(endPoint_two, duration: 20)
        let delete_enemy_two = SKAction.removeFromParent()
        let loseALifeAction_two = SKAction.runBlock(loseALife)
        let enemy_two_sequence = SKAction.sequence([move_enemy_two, delete_enemy_two,loseALifeAction_two])
        
        if currentGameState == gameState.inGame{
            enemy_two.runAction(enemy_two_sequence)
        }
    }
    
    func spawnGrapes(){
        
        let randomXStart_three = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        let startPoint_three = CGPoint(x: randomXStart_three, y: self.size.height * 1.2)
        let endPoint_three = CGPoint(x: randomXStart_three, y: -self.size.height * 0.2)
        
        let enemy_three = SKSpriteNode(imageNamed: "grapes")
        enemy_three.name = "Grape"
        enemy_three.setScale(0.2)
        enemy_three.position = startPoint_three
        enemy_three.zPosition = 1
        enemy_three.physicsBody = SKPhysicsBody(rectangleOfSize: enemy_three.size)
        enemy_three.physicsBody!.affectedByGravity = false
        enemy_three.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy_three.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy_three.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        self.addChild(enemy_three)
        
        let move_enemy_three = SKAction.moveTo(endPoint_three, duration: 20)
        let delete_enemy_three = SKAction.removeFromParent()
        let loseALifeAction_three = SKAction.runBlock(loseALife)
        let enemy_three_sequence = SKAction.sequence([move_enemy_three, delete_enemy_three, loseALifeAction_three])
        
        if currentGameState == gameState.inGame{
            enemy_three.runAction(enemy_three_sequence)
        }
    }
    
    func spawnOranges(){
        
        let randomXStart_four = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        let startPoint_four = CGPoint(x: randomXStart_four, y: self.size.height * 1.2)
        let endPoint_four = CGPoint(x: randomXStart_four, y: -self.size.height * 0.2)
        
        let enemy_four = SKSpriteNode(imageNamed: "orange")
        enemy_four.name = "Orange"
        enemy_four.setScale(0.2)
        enemy_four.position = startPoint_four
        enemy_four.zPosition = 1
        enemy_four.physicsBody = SKPhysicsBody(rectangleOfSize: enemy_four.size)
        enemy_four.physicsBody!.affectedByGravity = false
        enemy_four.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy_four.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy_four.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        self.addChild(enemy_four)
        
        let move_enemy_four = SKAction.moveTo(endPoint_four, duration: 20)
        let delete_enemy_four = SKAction.removeFromParent()
        let loseALifeAction_four = SKAction.runBlock(loseALife)
        let enemy_four_sequence = SKAction.sequence([move_enemy_four, delete_enemy_four, loseALifeAction_four])
        
        if currentGameState == gameState.inGame{
            enemy_four.runAction(enemy_four_sequence)
        }
    }
    
    func spawnWatermelons(){
        
        let randomXStart_five = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        let startPoint_five = CGPoint(x: randomXStart_five, y: self.size.height * 1.2)
        let endPoint_five = CGPoint(x: randomXStart_five, y: -self.size.height * 0.2)
        
        let enemy_five = SKSpriteNode(imageNamed: "watermelon")
        enemy_five.name = "Watermelon"
        enemy_five.setScale(0.2)
        enemy_five.position = startPoint_five
        enemy_five.zPosition = 1
        enemy_five.physicsBody = SKPhysicsBody(rectangleOfSize: enemy_five.size)
        enemy_five.physicsBody!.affectedByGravity = false
        enemy_five.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy_five.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy_five.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        self.addChild(enemy_five)
        
        let move_enemy_five = SKAction.moveTo(endPoint_five, duration: 20)
        let delete_enemy_five = SKAction.removeFromParent()
        let loseALifeAction_five = SKAction.runBlock(loseALife)
        let enemy_five_sequence = SKAction.sequence([move_enemy_five, delete_enemy_five, loseALifeAction_five])
        
        if currentGameState == gameState.inGame{
            enemy_five.runAction(enemy_five_sequence)
        }
    }
}
*/