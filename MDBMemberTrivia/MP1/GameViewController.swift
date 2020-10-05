//
//  swift
//  MP1
//
//  Created by Abhishek Kattuparambil on 9/12/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak var TLButton: UIButton!
    @IBOutlet weak var TRButton: UIButton!
    @IBOutlet weak var BLButton: UIButton!
    @IBOutlet weak var BRButton: UIButton!
    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var statsButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    var buttons: [UIButton] = []
    var pickedName: String! = ""
    var score = 0
    public var highScore = 0
    public var previous: [Bool] = []
    var progressBar: CAShapeLayer! = CAShapeLayer()
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    var timeUsed: Double = 0
    var buttonColor: UIColor!
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonColor = TLButton.backgroundColor!
        
        // Do any additional setup after loading the view.
        BLButton.layer.cornerRadius = BLButton.frame.height/2
        BRButton.layer.cornerRadius = BLButton.frame.height/2
        TLButton.layer.cornerRadius = BLButton.frame.height/2
        TRButton.layer.cornerRadius = BLButton.frame.height/2
        pauseButton.layer.cornerRadius = pauseButton.frame.height/2
        
        TLButton.titleLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping;
        TRButton.titleLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping;
        BLButton.titleLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping;
        BRButton.titleLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping;
        
        TLButton.titleLabel?.textAlignment = .center
        TRButton.titleLabel?.textAlignment = .center
        BLButton.titleLabel?.textAlignment = .center
        BRButton.titleLabel?.textAlignment = .center
        
        TLButton.addTarget(self, action: #selector(checkAnswer(choice: )), for: .touchUpInside)
        TRButton.addTarget(self, action: #selector(checkAnswer(choice: )), for: .touchUpInside)
        BLButton.addTarget(self, action: #selector(checkAnswer(choice: )), for: .touchUpInside)
        BRButton.addTarget(self, action: #selector(checkAnswer(choice: )), for: .touchUpInside)
        
        statsButton.layer.cornerRadius = statsButton.frame.height/2
        
        pauseButton.setImage(UIImage(named: "pause"), for: .normal)
        
        buttons = [TLButton, TRButton, BLButton, BRButton]
        
        progressBar.path = UIBezierPath(arcCenter: CGPoint(x: timerLabel.frame.width/2, y: timerLabel.frame.height/2), radius: timerLabel.frame.width/2, startAngle: -CGFloat.pi/2, endAngle: 3*CGFloat.pi/2, clockwise: true).cgPath
        
        progressBar.strokeColor =  Constants.optimalGreen.cgColor
        progressBar.fillColor = UIColor.clear.cgColor
        progressBar.lineCap = .round
        progressBar.lineWidth = 15
        
        timerLabel.layer.addSublayer(progressBar)

        randomize()
    }
    
    func resetButtons() {
        TLButton.backgroundColor = buttonColor
        TRButton.backgroundColor = buttonColor
        BLButton.backgroundColor = buttonColor
        BRButton.backgroundColor = buttonColor
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5-timeUsed, repeats: false, block: {timer in self.timerOut()})
    }
    
    @objc func randomize() {
        resetButtons()
        startTimer()
        progressBar.path = UIBezierPath(arcCenter: CGPoint(x: timerLabel.frame.width/2, y: timerLabel.frame.height/2), radius: timerLabel.frame.width/2, startAngle: -CGFloat.pi/2, endAngle: 3*CGFloat.pi/2, clockwise: true).cgPath
        timerLabel.layer.sublayers![0].speed = 1
        animate()
        pickedName = Constants.names.randomElement()
        memberImage.image = Constants.getImageFor(name: pickedName!)
        var choices: [String] = [pickedName!]
        while choices.count < 4 {
            let nextName = Constants.names.randomElement()
            if !choices.contains(nextName!) {
                choices.append(nextName!)
            }
        }
        
        for index in 0...3 {
            let name = choices.randomElement()
            buttons[index].setTitle(name, for: .normal)
            choices.remove(at: choices.firstIndex(of: name!)!)
        }
    }
    
    func timerOut() {
        timer.invalidate()
        score = 0
        scoreLabel.text = "Score: 0"
        for btn in buttons{
            if btn.titleLabel?.text == pickedName {
                btn.backgroundColor = Constants.optimalGreen
                break
            }
        }
        timeUsed = 0
        if previous.count == 3 {
            previous.removeLast(1)
            previous.insert(false, at: 0)
        } else {
            previous.insert(false, at: 0)
        }
        perform(#selector(randomize), with: nil, afterDelay: 1)
    }
    
    @objc func checkAnswer(choice pickedButton:UIButton?) {
        timeUsed = 5-timer.fireDate.timeIntervalSinceNow
        timer.invalidate()
        timerLabel.layer.sublayers![0].speed = 0
        progressBar.path = UIBezierPath(arcCenter: CGPoint(x: timerLabel.frame.width/2, y: timerLabel.frame.height/2), radius: timerLabel.frame.width/2, startAngle: -CGFloat.pi/2, endAngle: (3*CGFloat.pi/2) - (2*CGFloat.pi*CGFloat((5-timeUsed)/5)), clockwise: true).cgPath
        if let button = pickedButton {
            if button.titleLabel!.text! == pickedName {
                score += 1
                scoreLabel.text = "Score: \(score)"
                if score > highScore {
                    highScore = score
                }
                if previous.count == 3 {
                    previous.removeLast(1)
                    previous.insert(true, at: 0)
                } else {
                    previous.insert(true, at: 0)
                }
                button.backgroundColor = Constants.optimalGreen
            } else {
                scoreLabel.text = "Score: 0"
                score = 0
                if previous.count == 3 {
                    previous.removeLast(1)
                    previous.insert(false, at: 0)
                } else {
                    previous.insert(false, at: 0)
                }
            }
            button.backgroundColor = Constants.optimalRed
            for btn in buttons{
                if btn.titleLabel?.text == pickedName {
                    btn.backgroundColor = Constants.optimalGreen
                    break
                }
            }
        }
        timeUsed = 0
        disableButtons()
        perform(#selector(randomize), with: nil, afterDelay: 1)
        perform(#selector(enableButtons), with: nil, afterDelay: 1)
    }
    
    @IBAction func pauseGame(_ sender: Any) {
        if pauseButton.image(for: .normal) == UIImage(named: "pause"){
            timeUsed = 5-timer.fireDate.timeIntervalSinceNow
            timer.invalidate()
            pauseButton.setImage(UIImage(named: "play"), for: .normal)
            progressBar.path = UIBezierPath(arcCenter: CGPoint(x: timerLabel.frame.width/2, y: timerLabel.frame.height/2), radius: timerLabel.frame.width/2, startAngle: -CGFloat.pi/2, endAngle: (3*CGFloat.pi/2) - (2*CGFloat.pi*CGFloat((5-timeUsed)/5)), clockwise: true).cgPath
            timerLabel.layer.sublayers![0].speed = 0
            disableButtons()
        } else {
            startTimer()
            progressBar.path = UIBezierPath(arcCenter: CGPoint(x: timerLabel.frame.width/2, y: timerLabel.frame.height/2), radius: timerLabel.frame.width/2, startAngle: -CGFloat.pi/2, endAngle: 3*CGFloat.pi/2, clockwise: true).cgPath
            timerLabel.layer.sublayers![0].speed = 1
            animate()
            pauseButton.setImage(UIImage(named: "pause"), for: .normal)
            enableButtons()
        }
    }
    
    @objc func animate() {
        animation.fromValue = timeUsed/5
        animation.toValue = 1
        animation.duration = 5-timeUsed
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        progressBar.add(animation, forKey: "timer")
    }
    
    @objc func enableButtons() {
        TLButton.enable()
        TRButton.enable()
        BLButton.enable()
        BRButton.enable()
    }
    
    func disableButtons() {
        TLButton.disable()
        TRButton.disable()
        BLButton.disable()
        BRButton.disable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        /*startTimer()
        progressBar.path = UIBezierPath(arcCenter: CGPoint(x: timerLabel.frame.width/2, y: timerLabel.frame.height/2), radius: timerLabel.frame.width/2, startAngle: -CGFloat.pi/2, endAngle: 3*CGFloat.pi/2, clockwise: true).cgPath
        timerLabel.layer.sublayers![0].speed = 1*/
        animate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        timeUsed = 5-timer.fireDate.timeIntervalSinceNow
        timer.invalidate()
        progressBar.path = UIBezierPath(arcCenter: CGPoint(x: timerLabel.frame.width/2, y: timerLabel.frame.height/2), radius: timerLabel.frame.width/2, startAngle: -CGFloat.pi/2, endAngle: (3*CGFloat.pi/2) - (2*CGFloat.pi*CGFloat((5-timeUsed)/5)), clockwise: true).cgPath
        timerLabel.layer.sublayers![0].speed = 0
        if let dest = segue.destination as? StatisticsViewController{
            dest.previous = previous
            dest.highScore = highScore
            dest.game = self
        }
    }
    
    func resume() {
        startTimer()
        progressBar.path = UIBezierPath(arcCenter: CGPoint(x: timerLabel.frame.width/2, y: timerLabel.frame.height/2), radius: timerLabel.frame.width/2, startAngle: -CGFloat.pi/2, endAngle: 3*CGFloat.pi/2, clockwise: true).cgPath
        timerLabel.layer.sublayers![0].speed = 1
        animate()
    }
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        timeUsed = 5-timer.fireDate.timeIntervalSinceNow
        timer.invalidate()
        progressBar.path = UIBezierPath(arcCenter: CGPoint(x: timerLabel.frame.width/2, y: timerLabel.frame.height/2), radius: timerLabel.frame.width/2, startAngle: -CGFloat.pi/2, endAngle: (3*CGFloat.pi/2) - (2*CGFloat.pi*CGFloat((5-timeUsed)/5)), clockwise: true).cgPath
        timerLabel.layer.sublayers![0].speed = 0
    }*/
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
