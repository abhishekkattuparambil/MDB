//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Abhishek Kattuparambil on 9/19/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit

class PokemonViewController: UIViewController {
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var sprite: UIImageView!
    @IBOutlet weak var attack: UILabel!
    @IBOutlet weak var spattack: UILabel!
    @IBOutlet weak var defense: UILabel!
    @IBOutlet weak var spdefense: UILabel!
    @IBOutlet weak var hp: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var total: UILabel!
    
    var pokemon: Pokemon! = nil
    var labels: [UILabel]! = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        id.text = String("00\(pokemon.id)".suffix(3))
        let url = URL(string: "https://assets.pokemon.com/assets/cms2/img/pokedex/detail/\(id.text!).png")
        if let link = url {
            let data = try? Data(contentsOf: link)
            if let datum = data{
                sprite.image = UIImage(data: datum)
            }
        }
        navigationItem.title = pokemon.name
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: #selector(popToPrevious)
        )
        
        labels = [attack, defense, hp, spattack, spdefense, speed, total]
        for label in labels{
            label.layer.masksToBounds = true
            label.layer.cornerRadius = label.frame.height/2
        }
        attack.layer.cornerRadius = attack.frame.height/2
        attack.text = "\(pokemon.attack)\nAttack"
        defense.text = "\(pokemon.defense)\nDefense"
        hp.text = "\(pokemon.health)\nHP"
        spattack.text = "\(pokemon.specialAttack)\nSp. Attack"
        spdefense.text = "\(pokemon.specialDefense)\nSp. Defense"
        speed.text = "\(pokemon.speed)\nSpeed"
        // Do any additional setup after loading the view.
        let temp = pokemon.speed+pokemon.attack+pokemon.defense+pokemon.health
        total.text = "Total: \(temp+pokemon.specialDefense+pokemon.specialAttack)"
    }
    
    @objc private func popToPrevious() {
        // our custom stuff
        navigationController?.popViewController(animated: true)
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
