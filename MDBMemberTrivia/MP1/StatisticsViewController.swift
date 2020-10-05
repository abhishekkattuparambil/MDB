//
//  StatisticsViewController.swift
//  MP1
//
//  Created by Abhishek Kattuparambil on 9/12/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var previousLabel: UILabel!
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    var highScore = 0;
    var previous: [Bool] = []
    var game: GameViewController!
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        highScoreLabel.text = "Highest Score: \(highScore)"
               
        highScoreLabel.layer.cornerRadius = highScoreLabel.frame.height/2
        previousLabel.layer.cornerRadius = previousLabel.frame.height/2
               
        labelOne.layer.cornerRadius = labelOne.frame.height/2
        labelTwo.layer.cornerRadius = labelOne.frame.height/2
        labelThree.layer.cornerRadius = labelOne.frame.height/2
        
        highScoreLabel.layer.masksToBounds = true
        previousLabel.layer.masksToBounds = true
        labelOne.layer.masksToBounds = true
        labelTwo.layer.masksToBounds = true
        labelThree.layer.masksToBounds = true
               
        let labels = [labelOne, labelTwo, labelThree]
        if (previous.count > 0) {
                      for index in 0...previous.count-1 {
                          if previous[index] {
                            labels[index]!.backgroundColor = Constants.optimalGreen
                          } else {
                            labels[index]!.backgroundColor = Constants.optimalRed
                       }
                   }
               }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        game.resume()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
