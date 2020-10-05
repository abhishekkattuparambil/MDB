//
//  PokedexViewController.swift
//  Pokedex
//
//  Created by Abhishek Kattuparambil on 9/19/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController{
    @IBOutlet weak var pokedex: UICollectionView!
    @IBOutlet weak var viewChoice: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var advanceButton: UIButton!
    
    var filterTypes: [String]! = []
    var filterStats: [Int]! = [0,0,0,0,0,0]
    
    var pokemons = PokemonGenerator.getPokemonArray()
    
    var answer = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pokedex.dataSource = self
        pokedex.delegate = self
        pokedex.layer.cornerRadius = 20
        
        searchBar.delegate = self
        navigationItem.titleView?.backgroundColor = UIColor.systemBlue
        
        let q = PokemonGenerator.getQuestions()
        searchBar.placeholder = q[0]
        answer = q[1]
        
        continueButton.layer.cornerRadius = continueButton.frame.height/2
        continueButton.isHidden = true
        advanceButton.layer.cornerRadius = advanceButton.frame.height/2
    }

    @IBAction func changeView(_ sender: Any) {
        pokemons = PokemonGenerator.getPokemonArray().filter { (searchBar.text == nil || searchBar.text!.isEmpty || $0.name.lowercased().contains(searchBar.text!.lowercased())) && filterTypes.allSatisfy($0.types.contains) && $0.attack >= filterStats[0] && $0.defense >= filterStats[1] && $0.health >= filterStats[2] && $0.specialAttack >= filterStats[3] && $0.specialDefense >= filterStats[4] && $0.speed >= filterStats[5]}
        pokedex.reloadData()
    }
    
    @IBAction func `continue`(_ sender: Any) {
        searchBar.text = ""
        continueButton.isHidden = true
        searchBar.isUserInteractionEnabled = true
        advanceButton.isUserInteractionEnabled = true
        changeView(self)
    }
    
}

extension PokedexViewController: UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewChoice.selectedSegmentIndex == 0 {
            if let cell = pokedex.dequeueReusableCell(withReuseIdentifier: "table", for: indexPath) as? PokedexTableCell {
                let pokemon = pokemons[indexPath.row]
                cell.name.text = pokemon.name
                cell.id.text = String("00\(pokemon.id)".suffix(3))
                cell.layer.masksToBounds = false
                let url = URL(string: "https://assets.pokemon.com/assets/cms2/img/pokedex/detail/\(cell.id.text!).png")
                if let link = url {
                    let data = try? Data(contentsOf: link)
                    if let datum = data{
                        cell.sprite.image = UIImage(data: datum)
                    }
                }
                //cell.layer.borderWidth = 2
                //cell.layer.borderColor = UIColor.black.cgColor
                //cell.layer.cornerRadius = cell.frame.height/2
                cell.name.layer.shadowColor = UIColor.white.cgColor
                cell.name.layer.shadowRadius = 2.0
                cell.name.layer.shadowOpacity = 0.7
                cell.name.layer.shadowOffset = CGSize(width: 1, height: 1)
                cell.name.layer.masksToBounds = false
                return cell
            }
        } else if let cell = pokedex.dequeueReusableCell(withReuseIdentifier: "grid", for: indexPath) as? PokedexGridCell {
            let pokemon = pokemons[indexPath.row]
            cell.name.text = pokemon.name
            cell.id.text  = String("00\(pokemon.id)".suffix(3))
            let url = URL(string: "https://assets.pokemon.com/assets/cms2/img/pokedex/detail/\(cell.id.text!).png")
            if let link = url {
                let data = try? Data(contentsOf: link)
                if let datum = data{
                    cell.sprite.image = UIImage(data: datum)
                }
            }
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.black.cgColor
            //cell.layer.cornerRadius = cell.frame.height/4
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if viewChoice.selectedSegmentIndex == 0 {
            let cellWidth = collectionView.bounds.width-20
            let cellHeight = (80/374)*cellWidth
            

            return CGSize(width: cellWidth, height: cellHeight)
        }

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(2 - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(2))

        return CGSize(width: size, height: size)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: pokemons[indexPath.item])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PokemonViewController{
            destination.pokemon = sender as? Pokemon
        }
        else if let destination = segue.destination as? SearchViewController{
            destination.pokedex = self
            destination.filterStats = self.filterStats
            destination.filterTypes = self.filterTypes
        }
    }
}

extension PokedexViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if self.searchBar.text != nil && !self.searchBar.text!.isEmpty && self.searchBar.text!.lowercased() == answer.lowercased(){
            self.searchBar.backgroundColor = UIColor.green
            let q = PokemonGenerator.getQuestions()
            self.searchBar.placeholder = q[0]
            answer = q[1]
            continueButton.isHidden = false
            searchBar.isUserInteractionEnabled = false
            advanceButton.isUserInteractionEnabled = false
        }
        changeView(self)
    }
}

extension UIImageView {
    func loadImageURL(urlString: String){
        let url = URL(string: urlString)
        image = nil
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error ?? "error occured")
                return
            }
            self.image = UIImage(data: data!)
            }).resume()
    }
}
