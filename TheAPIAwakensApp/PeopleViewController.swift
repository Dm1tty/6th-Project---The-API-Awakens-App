//
//  PeopleViewController.swift
//  TheAPIAwakensApp
//
//  Created by Dzmitry Matsiulka on 9/1/19.
//  Copyright © 2019 Dzmitry M. All rights reserved.
//

import UIKit


class PeopleViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var pickerView: UIPickerView!
    
    var characters = [CharactersResult]()
    var nextPageUrlForCharacters : String?
    
    
    @IBOutlet weak var smallestLabel: UILabel!
    @IBOutlet weak var largestLabel: UILabel!
    
    @IBOutlet weak var unitsSwitcher: UISegmentedControl!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bornLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var eyesLabel: UILabel!
    @IBOutlet weak var hairLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        // Do any additional setup after loading the view.
        
        // Connect data:
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    
        getCharacters(urlToGet: "https://swapi.co/api/people/"){
            self.sortCharacters()
            print("Sorting Characters")
        
        }

    }
    
    
    @IBAction func switchWasPressed(_ sender: Any) {
        if let height = Int.parse(from: heightLabel.text!) {
            // Do something with this number
            print(height)
            
            
            if unitsSwitcher.selectedSegmentIndex==0{
                //metric
                heightLabel.text = "Height:\(height)"
            }
            else{
                //english
                 heightLabel.text = "Height: \(Double(height)*0.033)ft"
            }
        }
    }
    
  
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return characters.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.retrievePlanet(urlToGet: self.characters[0].homeworld)
        return characters[row].name
    }
    
    func updatePicker(){
        DispatchQueue.main.async {
        self.pickerView!.reloadAllComponents()
            
        }}

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        var height = Double(characters[row].height)
        heightLabel.text = "Height: \(height!/100)m"
        
        nameLabel.text = characters[row].name
        bornLabel.text = "Born: \(characters[row].birthYear)"
        eyesLabel.text = "Eyes: \(characters[row].eyeColor)"
        hairLabel.text = "Hair: \(characters[row].hairColor)"
        retrievePlanet(urlToGet: characters[row].homeworld)
        
        
        if characters[row].name == characters.last?.name{
            print("The last one, loading more")
            if nextPageUrlForCharacters != nil {
                getCharacters(urlToGet: nextPageUrlForCharacters!, finished: sortCharacters)
            }
            
        }
     
        
    }
    func retrievePlanet(urlToGet: String){
        do{
            if let url = URL(string: urlToGet) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        do {
                            let planet = try JSONDecoder().decode(Planets.self, from: data)
                         DispatchQueue.main.async {
                            self.homeLabel.text = "Home: \(planet.name)"
                            }
                        } catch let error {
                            print(error)
                        }
                    }
                }.resume()
            }
            
        
        }
    }
    
    
    func getCharacters(urlToGet: String, finished: @escaping () -> Void){
        do{
            if let url = URL(string: urlToGet) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        do {
                            let jsonCharacters = try JSONDecoder().decode(Characters.self, from: data)
                            
                            
                            self.characters = self.characters + jsonCharacters.results
                            
                          
                            self.nextPageUrlForCharacters = jsonCharacters.next
                            
                            self.updatePicker()
                            finished()
                        } catch {
                            print(error)
                            var message = ""
                            guard let httpResponse = response as? HTTPURLResponse else {
                                print("Request failed.")
                                message = "Request failed."
                                return
                            }
                            switch httpResponse.statusCode{
                                
                                
                            case 300...399:
                                print("Redirection error. Try again later")
                                 message = "Redirection error. Try again later"
                            case 400...499:
                                print("Error happened on the client's side. Try again later")
                                 message =  "Error happened on the client's side. Try again later"
                            case 500...599:
                                print("Server error. Try again later")
                                  message =  "Server error. Try again later"
                            default:
                                print("Unknown error")
                                message =  "Unknown error"
                                
                                let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                                
                                
                                self.present(alertController, animated: true, completion: nil)
                            }
    
                            
                        }
                    }
                    }.resume()
                
            }
            
        }
    }
    

    
    func sortCharacters(){
        let sortedCharacters = self.characters.sorted{$0.height.compare($1.height, options: .numeric) == .orderedDescending}
        let largestCharacter = sortedCharacters.first
        let smallestCharacter = sortedCharacters.last
         DispatchQueue.main.async {
            self.smallestLabel.text = "Smallest \(smallestCharacter!.name)"
            self.largestLabel.text = "Largest \(largestCharacter!.name)"
        }
        
    }
}


extension Int {
    static func parse(from string: String) -> Int? {
        return Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
}
