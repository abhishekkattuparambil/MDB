//
//  StartViewController.swift
//  MP1
//
//  Created by Abhishek Kattuparambil on 9/12/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startButton.layer.cornerRadius =
            startButton.frame.height/2
        titleLabel.font = UIFont.boldSystemFont(ofSize: 46)
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
