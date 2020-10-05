//
//  SearchViewController.swift
//  Pokedex
//
//  Created by Abhishek Kattuparambil on 10/2/20.
//  Copyright © 2020 Abhishek Kattuparambil. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var popup: UIView!
    @IBOutlet weak var typeOne: UIPickerView!
    @IBOutlet weak var typeTwo: UIPickerView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var attack: UITextField!
    @IBOutlet weak var defense: UITextField!
    @IBOutlet weak var hp: UITextField!
    @IBOutlet weak var spattack: UITextField!
    @IBOutlet weak var spdefense: UITextField!
    @IBOutlet weak var speed: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    var pokedex: PokedexViewController! = nil
    
    let types = ["None", "Water", "Fire", "Grass", "Ground", "Normal", "Flying", "Rock", "Steel", "Fighting", "Electric",
    "Bug", "Dragon", "Dark", "Psychic", "Ghost", "Poison", "Ice", "Fairy"]
    var filterStats: [Int]! = []
    var filterTypes: [String]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let pickers = [typeOne, typeTwo]
        for picker in pickers{
            picker?.delegate = self
            picker?.dataSource = self
            picker?.layer.borderColor = UIColor.systemBlue.cgColor
            picker?.layer.borderWidth = 1
            picker?.layer.cornerRadius = picker!.frame.height/4
        }
        if filterTypes.count > 0{
            typeOne.selectRow(types.firstIndex(of: filterTypes[0])!, inComponent: 0, animated: true)
            if filterTypes.count > 1{
                typeTwo.selectRow(types.firstIndex(of: filterTypes[1])!, inComponent: 0, animated: true)
            }
        }
        
       
        cancelButton.layer.cornerRadius = cancelButton.frame.height/2
        searchButton.layer.cornerRadius = searchButton.frame.height/2
        clearButton.layer.cornerRadius = clearButton.frame.height/2
        
        popup.layer.cornerRadius = 20
        
        let fields = [attack, defense, hp, spattack, spdefense, speed]
        
        for i in 0...5{
            fields[i]!.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
            if filterStats[i] != 0{
                fields[i]!.text = "\(filterStats[i])"
            }
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
    @IBAction func cancel(_ sender: Any) {
        pokedex.filterTypes = self.filterTypes
        pokedex.filterStats = self.filterStats
        pokedex.changeView(self)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func search(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clear(_ sender: Any) {
        pokedex.filterTypes = []
        pokedex.filterStats = [0,0,0,0,0,0]
        pokedex.changeView(self)
        attack.text = ""
        defense.text = ""
        hp.text = ""
        spattack.text = ""
        spdefense.text = ""
        speed.text = ""
        typeOne.selectRow(0, inComponent: 0, animated: true)
        typeTwo.selectRow(0, inComponent: 0, animated: true)
        
    }
}

extension SearchViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        self.view.endEditing(true)
        return types[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let filters = [types[typeOne.selectedRow(inComponent: 0)],types[typeTwo.selectedRow(inComponent: 0)]]
        pokedex.filterTypes = Array(Set(filters.filter {$0 != "None"}))
        pokedex.changeView(self)
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: types[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
}

extension SearchViewController : UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
            var att = 0, def = 0, sp = 0, health = 0, spatt = 0, spdef = 0
             if !(attack.text?.isEmpty ?? true) {
                 att = Int(attack.text!)!
             }
             if !(defense.text?.isEmpty ?? true){
                 def = Int(defense.text!)!
             }
             if !(speed.text?.isEmpty ?? true) {
                 sp = Int(speed.text!)!
             }
             if !(spattack.text?.isEmpty ?? true) {
                 spatt = Int(spattack.text!)!
             }
             if !(spdefense.text?.isEmpty ?? true) {
                 spdef = Int(spdefense.text!)!
             }
             if !(hp.text?.isEmpty ?? true) {
                 health = Int(hp.text!)!
             }
        pokedex.filterStats = [att,def,health,spatt,spdef,sp]
        pokedex.changeView(self)
       }
}
