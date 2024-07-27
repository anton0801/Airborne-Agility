import SwiftUI
import SpriteKit

class PlayAgilityScene: SKScene, SKPhysicsContactDelegate {
    
    private var gameBackground: SKSpriteNode {
        get {
            let back = SKSpriteNode(imageNamed: "app_background")
            back.size = size
            back.position = CGPoint(x: size.width / 2, y: size.height / 2)
            return back
        }
    }
    
    private var gamePauseButton: SKSpriteNode {
        get {
            let pauseButton = SKSpriteNode(imageNamed: "pause_btn")
            pauseButton.position = CGPoint(x: 100, y: size.height - 130)
            pauseButton.size = CGSize(width: 120, height: 80)
            pauseButton.name = "pause"
            return pauseButton
        }
    }
    
    private var time = 0 {
        didSet {
            timeLabel.text = TimeFormatter.format(seconds: time)
        }
    }
    let timeLabel = SKLabelNode(text: "0:00")
    private var gameTimer = Timer()
    
    private var obstacleTimer = Timer()
    
    private var timeLabelNode: SKSpriteNode {
        get {
            let timeNode = SKSpriteNode()
            
            let timeBackground = SKSpriteNode(imageNamed: "balance_background")
            timeBackground.size = CGSize(width: 250, height: 75)
            timeNode.addChild(timeBackground)
   
            timeLabel.fontSize = 42
            timeLabel.fontName = "Souses"
            timeLabel.fontColor = .red
            timeLabel.position = CGPoint(x: 0, y: -12)
            timeNode.addChild(timeLabel)
            
            timeNode.position = CGPoint(x: gamePauseButton.position.x + (gamePauseButton.size.width) + 100, y: size.height - 130)
            
            return timeNode
        }
    }
    
    private var plane: SKSpriteNode!
    
    private var money = UserDefaults.standard.integer(forKey: "money") {
        didSet {
            moneyLabelNode.removeFromParent()
            moneyLabelNode = createMoneyLabelNode()
            addChild(moneyLabelNode)
            NotificationCenter.default.post(name: Notification.Name("save_money"), object: nil, userInfo: ["money": money])
        }
    }
    
    private var moneyLabelNode: SKSpriteNode!
    
    private var pausedNode: SKSpriteNode!
    
    private func createPausedNode() -> SKSpriteNode {
        let pauseNode = SKSpriteNode()
        
        let pausedBackground = SKSpriteNode(imageNamed: "pause_bg")
        pausedBackground.position = CGPoint(x: 0, y: 0)
        pausedBackground.size = CGSize(width: 120, height: 200)
        pauseNode.addChild(pausedBackground)
        
        let homeBtn = SKSpriteNode(imageNamed: "home")
        homeBtn.name = "home"
        homeBtn.position = CGPoint(x: 0, y: 40)
        homeBtn.size = CGSize(width: homeBtn.size.width, height: 40)
        pauseNode.addChild(homeBtn)
        
        let restartBtn = SKSpriteNode(imageNamed: "restart")
        restartBtn.name = "restart"
        restartBtn.position = CGPoint(x: 0, y: -40)
        restartBtn.size = CGSize(width: homeBtn.size.width, height: 40)
        pauseNode.addChild(restartBtn)
        
        pauseNode.position = CGPoint(x: 100, y: size.height - 260)
        
        return pauseNode
    }
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 800, height: 1335)
        physicsWorld.contactDelegate = self
        
        setUpAllChildrens()
        
        plane = SKSpriteNode(imageNamed: "plane")
        plane.position = CGPoint(x: 200, y: size.height / 2)
        plane.size = CGSize(width: 150, height: 120)
        plane.physicsBody = SKPhysicsBody(rectangleOf: plane.size)
        plane.physicsBody?.isDynamic = true
        plane.physicsBody?.affectedByGravity = false
        plane.physicsBody?.categoryBitMask = 1
        plane.physicsBody?.collisionBitMask = 2
        plane.physicsBody?.contactTestBitMask = 2
        plane.name = "plane"
        addChild(plane)
        
        gameTimer = .scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            if !self.isPaused {
                self.time += 1
            }
        })
        
        obstacleTimer = .scheduledTimer(withTimeInterval: 3.5, repeats: true, block: { _ in
            if !self.isPaused {
                self.spawnObstacle()
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(restartActionCall), name: Notification.Name("restart_game"), object: nil)
    }
    
    @objc private func restartActionCall() {
        view?.presentScene(PlayAgilityScene())
    }
    
    private func spawnObstacle() {
        let obstacles = ["plane_obstacle_1", "plane_obstacle_2"]
        let obstacleName = obstacles.randomElement() ?? "plane_obstacle_1"
        let obstacleY = CGFloat.random(in: 150...900)
        let obstacle = SKSpriteNode(imageNamed: obstacleName)
        obstacle.position = CGPoint(x: size.width + 300, y: obstacleY)
        obstacle.size = CGSize(width: 250, height: 350)
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.affectedByGravity = false
        obstacle.physicsBody?.categoryBitMask = 2
        obstacle.physicsBody?.collisionBitMask = 1
        obstacle.physicsBody?.contactTestBitMask = 1
        obstacle.name = obstacleName
        
        addChild(obstacle)
        
        if Bool.random() {
            let left = SKAction.moveBy(x: -1500, y: 0, duration: 7)
            let actionMoveUp = SKAction.moveBy(x: 0, y: 100, duration: 1.5)
            let actionMoveDown = SKAction.moveBy(x: 0, y: -100, duration: 1.5)
            
            let seq = SKAction.sequence([actionMoveUp, actionMoveDown])
            let repeateFor = SKAction.repeatForever(seq)
            let group = SKAction.group([left, repeateFor])
            obstacle.run(group) {
                self.money += 100
            }
        } else {
            let actionMoveLeft = SKAction.move(to: CGPoint(x: -100, y: obstacleY), duration: 7)
            obstacle.run(actionMoveLeft) {
                self.money += 100
            }
        }
    }
    
    private func setUpAllChildrens() {
        addChild(gameBackground)
        addChild(gamePauseButton)
        addChild(timeLabelNode)
        moneyLabelNode = createMoneyLabelNode()
        addChild(moneyLabelNode)
        pausedNode = createPausedNode()
    }
    
    private func createMoneyLabelNode() -> SKSpriteNode {
        let moneyNode = SKSpriteNode()
        
        let moneyBackground = SKSpriteNode(imageNamed: "balance_background")
        moneyBackground.size = CGSize(width: 300, height: 75)
        moneyNode.addChild(moneyBackground)
        
        let moneyLabel = SKLabelNode(text: "\(money)")
        moneyLabel.fontSize = 42
        moneyLabel.fontName = "Souses"
        moneyLabel.fontColor = .red
        moneyLabel.position = CGPoint(x: 0, y: -12)
        moneyNode.addChild(moneyLabel)
        
        moneyNode.position = CGPoint(x: 625, y: size.height - 130)
        
        return moneyNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let loc = touch.location(in: self)
            let obj = atPoint(loc)
            
            if obj.name == "pause" {
                if isPaused {
                    isPaused = false
                    hidePausedNode()
                } else {
                    isPaused = true
                    showPausedNode()
                }
            } else if obj.name == "restart" {
                view?.presentScene(PlayAgilityScene())
            } else if obj.name == "home" {
                NotificationCenter.default.post(name: Notification.Name("to_home"), object: nil)
            } else {
                plane.run(SKAction.move(to: CGPoint(x: plane.position.x, y: plane.position.y + 10), duration: 0.1))
            }
        }
    }
    
    private func showPausedNode() {
        pausedNode = createPausedNode()
        let actionAppear = SKAction.fadeIn(withDuration: 0.3)
        addChild(pausedNode)
        pausedNode.run(actionAppear)
    }
    
    private func hidePausedNode() {
        let actionFade = SKAction.fadeOut(withDuration: 0.3)
        pausedNode.run(actionFade) {
            self.pausedNode.removeFromParent()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        plane.position.y -= 0.5
        
        if plane.position.y <= 0 {
            isPaused = true
            NotificationCenter.default.post(name: Notification.Name("plane_lose"), object: nil, userInfo: ["time": time])
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA
        let contactB = contact.bodyB
        
        if (contactA.categoryBitMask == 1 && contactB.categoryBitMask == 2) ||
            (contactA.categoryBitMask == 2 && contactB.categoryBitMask == 1) {
            isPaused = true
            NotificationCenter.default.post(name: Notification.Name("plane_lose"), object: nil, userInfo: ["time": time])
            plane.removeFromParent()
        }
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: PlayAgilityScene())
            .ignoresSafeArea()
    }
}
