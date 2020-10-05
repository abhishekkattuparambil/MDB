//
//  SplashViewController.swift
//  Pokedex
//
//  Created by Abhishek Kattuparambil on 9/19/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    @IBOutlet weak var progressBar: UIProgressView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        progressBar.transform = progressBar.transform.scaledBy(x: 1.0, y: 5.0)
        progressBar.progressViewStyle = UIProgressView.Style.bar
        progressBar.trackTintColor = UIColor.clear
        progressBar.layer.cornerRadius = progressBar.frame.height/2 + 2
        progressBar.clipsToBounds = true
        animate()
    }
    
    func animate() {
        _ = Timer.scheduledTimer(withTimeInterval: 4, repeats: false, block: {timer in self.performSegue(withIdentifier: "openPokedex", sender: self)})
        UIView.animate(withDuration: 4.0) {
            self.progressBar.setProgress(1.0, animated: true)
        }
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
