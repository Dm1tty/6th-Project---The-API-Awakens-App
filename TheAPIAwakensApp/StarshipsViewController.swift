//
//  StarshipsViewController.swift
//  TheAPIAwakensApp
//
//  Created by Dzmitry Matsiulka on 9/3/19.
//  Copyright © 2019 Dzmitry M. All rights reserved.
//

import UIKit

class StarshipsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var crewLabel: UILabel!
    
    @IBOutlet weak var pickerView: UIPickerView!
     @IBOutlet weak var unitsSwitcher: UISegmentedControl!
    @IBOutlet weak var smallestLabel: UILabel!
    @IBOutlet weak var largestLabel: UILabel!
    
    var starships = [StarshipsResult]()
    var nextPageForStarships : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Connect data:
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        getStarships(urlToGet: "https://swapi.co/api/starships/"){
            print("Got the starships")
        }
    }
    
    
    
    
    @IBAction func switchWasPressed(_ sender: Any) {
        if let length = Int.parse(from: lengthLabel.text!) {
            // Do something with this number
            if unitsSwitcher.selectedSegmentIndex==0{
                //metric
                lengthLabel.text = "Length:\(length)"
            }
            else{
                //english
                lengthLabel.text = "Length: \(Double(length)*3.3)ft"
            }
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return starships.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return starships[row].name
    }
    
    func updatePicker(){
        DispatchQueue.main.async {
            self.pickerView!.reloadAllComponents()
            
        }}
    
    
    @IBAction func spaceshipUSDClicked(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "What's the US exchange rate?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input US exchange rate here..."
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let exchangeText = alert.textFields?.first?.text {
                if let exchange = Double(exchangeText) {
                    if exchange>0{
                        if let priceInt = Int.parse(from: self.costLabel.text!){
                            self.costLabel.text = "Cost: " + String(format: "%.2f", Double(priceInt) * exchange) + "$"
                        }}
                    else{
                        return
                    }
                }
            }}))
        
        self.present(alert, animated: true)
        
        
    }
    
    
    func getStarships(urlToGet: String, finished: @escaping () -> Void){
        do{
            if let url = URL(string: urlToGet) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        do {
                            let jsonCharacters = try JSONDecoder().decode(Vehicles.self, from: data)
                            
                            
                            self.starships = self.starships + jsonCharacters.results
                            
                            
                            self.nextPageForStarships = jsonCharacters.next
                            
                            self.updatePicker()
                            finished()
                        } catch let error {
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
       
        
        lengthLabel.text = "Length: \(starships[row].length)m"
        
        nameLabel.text = starships[row].name
        makeLabel.text = "Make: \(starships[row].model)"
        costLabel.text = "Cost: \(starships[row].costInCredits)"
        classLabel.text = "Class: \(starships[row].starshipClass!)"
        crewLabel.text = "Crew: \(starships[row].crew)"
        
        if starships[row].name == starships.last?.name{
            print("The last one, loading more")
            if starships[row].name == starships.last?.name{
                print("The last one, loading more")
                if nextPageForStarships != nil {
                    getStarships(urlToGet: nextPageForStarships!, finished: sortStarships)
                }
                
            }
            
            
        }
    }
    func sortStarships(){
        let sortedStarships = self.starships.sorted{$0.length.compare($1.length, options: .numeric) == .orderedDescending}
        let largestVehicle = sortedStarships.first
        let smallestVehicle = sortedStarships.last
        DispatchQueue.main.async {
            self.smallestLabel.text = "Smallest \(smallestVehicle!.name)"
            self.largestLabel.text = "Largest \(largestVehicle!.name)"
        }
        
    }
}

