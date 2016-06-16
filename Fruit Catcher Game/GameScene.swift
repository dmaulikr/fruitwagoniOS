
import SpriteKit

enum gameState{
    case preGame
    case inGame
    case afterGame
    case introGame
}

var currentGameState = gameState.preGame
var gameScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var wait_a = SKAction.waitForDuration(10, withRange: 7)
    var wait_b = SKAction.waitForDuration(10, withRange: 7)
    var wait_o = SKAction.waitForDuration(10, withRange: 7)
    var wait_w = SKAction.waitForDuration(10, withRange: 7)
    var wait_g = SKAction.waitForDuration(10, withRange: 7)
    
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
        
        let wagonMoveOntoScreen = SKAction.moveToX(self.size.width/2, duration: 1)
        let startLevelAction = SKAction.runBlock(startNewLevel)
        let startGameSequence = SKAction.sequence([wagonMoveOntoScreen, startLevelAction])
        player.runAction(startGameSequence)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if currentGameState == gameState.preGame{
            startGame()
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
        let sceneToMoveTo = GameOverScene(size: self.size)
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
    
    //................................................................................................  a function made for any bodies that come into contact
    func didBeginContact(contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        //................................................................................................  making sure body a and b represent the apropriate thing
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        //................................................................................................  if specific bodies come into contact with each other then...
       
        if (body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy){
            body2.node?.removeFromParent()
            //................................................................................................  has to be '!' and not '?' because there HAS to be a position
            spawnExplosion(body1.node!.position)
            addScore()
            //spawnPoof(body2.node!.position) -> this wont work probably because you have assigned one category to multiple objects?
        }
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
        
        //...........................................................................................  level duration would signify the frequency of falling
        
        switch levelNumber_a{
        case 1: wait_a = SKAction.waitForDuration(10, withRange: 10)
        case 2: wait_a = SKAction.waitForDuration(5, withRange: 8)
        case 3: wait_a = SKAction.waitForDuration(3, withRange: 5)
        case 4: wait_a = SKAction.waitForDuration(2, withRange: 3)
        default: wait_a = SKAction.waitForDuration(5.5, withRange: 3)
        }
        
        switch levelNumber_b{
        case 1: wait_b = SKAction.waitForDuration(9, withRange: 10)
        case 2: wait_b = SKAction.waitForDuration(5, withRange: 8)
        case 3: wait_b = SKAction.waitForDuration(3, withRange: 6)
        case 4: wait_b = SKAction.waitForDuration(1.9, withRange: 3)
        default: wait_b = SKAction.waitForDuration(5.3, withRange: 3)
        }
        
        switch levelNumber_g{
        case 1: wait_g = SKAction.waitForDuration(10, withRange: 10)
        case 2: wait_g = SKAction.waitForDuration(5, withRange: 8)
        case 3: wait_g = SKAction.waitForDuration(3, withRange: 5)
        case 4: wait_g = SKAction.waitForDuration(1.2, withRange: 3)
        default: wait_g = SKAction.waitForDuration(4.8, withRange: 3)
        }
        
        switch levelNumber_o{
        case 1: wait_o = SKAction.waitForDuration(11, withRange: 10)
        case 2: wait_o = SKAction.waitForDuration(6, withRange: 8)
        case 3: wait_o = SKAction.waitForDuration(5, withRange: 6)
        case 4: wait_o = SKAction.waitForDuration(1.4, withRange: 3)
        default: wait_o = SKAction.waitForDuration(5, withRange: 3)
        }
        
        switch levelNumber_w{
        case 1: wait_w = SKAction.waitForDuration(12, withRange: 10)
        case 2: wait_w = SKAction.waitForDuration(7, withRange: 8)
        case 3: wait_w = SKAction.waitForDuration(6, withRange: 7)
        case 4: wait_w = SKAction.waitForDuration(4, withRange: 3)
        default: wait_w = SKAction.waitForDuration(9, withRange: 3)
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
        
        let background = SKSpriteNode(imageNamed: "background")
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
            
            
        //was *0.9
        let moveOntoScreen = SKAction.moveToY(self.size.height*0.5, duration: 0.01)
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
        
        if gameScore == 20 || gameScore == 40 || gameScore == 60{
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
    
    //.............................................................................................. this function will run whenever we tuoch the screen
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches{
        
            let pointOfTouch = touch.locationInNode(self)
            let previousPointOfTouch = touch.previousLocationInNode(self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            if currentGameState == gameState.inGame{
                player.position.x += amountDragged
            }
            
            if player.position.x > CGRectGetMaxX(gameArea) - player.size.width/2{
                player.position.x = CGRectGetMaxX(gameArea) - player.size.width/2
            }
            
            if player.position.x < CGRectGetMinX(gameArea) + player.size.width/2{
                player.position.x = CGRectGetMinX(gameArea) + player.size.width/2
            }
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
            
        let move_enemy_one = SKAction.moveTo(endPoint, duration: 5)
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
        
        let move_enemy_two = SKAction.moveTo(endPoint_two, duration: 5)
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
        
        let move_enemy_three = SKAction.moveTo(endPoint_three, duration: 5)
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
        
        let move_enemy_four = SKAction.moveTo(endPoint_four, duration: 5)
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
        
        let move_enemy_five = SKAction.moveTo(endPoint_five, duration: 5)
        let delete_enemy_five = SKAction.removeFromParent()
        let loseALifeAction_five = SKAction.runBlock(loseALife)
        let enemy_five_sequence = SKAction.sequence([move_enemy_five, delete_enemy_five, loseALifeAction_five])
        
        if currentGameState == gameState.inGame{
            enemy_five.runAction(enemy_five_sequence)
        }
    }
    
    
}
