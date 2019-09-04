//
//  VehiclesViewController.swift
//  TheAPIAwakensApp
//
//  Created by Dzmitry Matsiulka on 9/3/19.
//  Copyright © 2019 Dzmitry M. All rights reserved.
//

import UIKit

class VehiclesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var crewLabel: UILabel!
    
    @IBOutlet weak var pickerView: UIPickerView!
     @IBOutlet weak var unitsSwitcher: UISegmentedControl!
  
    @IBOutlet weak var priceSwitcher: UISegmentedControl!
    
    
    
    @IBOutlet weak var smallestLabel: UILabel!
    @IBOutlet weak var largestLabel: UILabel!
    
    var vehicles = [StarshipsResult]()
    var nextPageForVehicles : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Connect data:
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        getVehicles(urlToGet: "https://swapi.co/api/vehicles/"){
            print("Got the vehicles")
        }
    }

    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return vehicles.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return vehicles[row].name
    }
    
    func updatePicker(){
        DispatchQueue.main.async {
            self.pickerView!.reloadAllComponents()
            
        }}

    
    func getVehicles(urlToGet: String, finished: @escaping () -> Void){
        do{
            if let url = URL(string: urlToGet) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        do {
                            let jsonCharacters = try JSONDecoder().decode(Vehicles.self, from: data)
                            
                            
                            self.vehicles = self.vehicles + jsonCharacters.results
                            
                            
                            self.nextPageForVehicles = jsonCharacters.next
                            
                            self.updatePicker()
                            finished()
                        } catch let error {
                            print(error)
                            
                            
                        }
                    }
                    }.resume()
                
            }
            
        }
}
    
    
    @IBAction func switchWasPressed(_ sender: Any) {
        if let length = Int.parse(from: lengthLabel.text!) {
            // Do something with this number
            if unitsSwitcher.selectedSegmentIndex==0{
                //metric
                lengthLabel.text = "Length:\(length)m"
            }
            else{
                //english
                lengthLabel.text = "Length: \(Double(length)*3.3)ft"
            }
        }
    }
    
    @IBAction func moneyConversion(_ sender: Any) {
        if let priceInt = Int.parse(from: costLabel.text!){
            if priceSwitcher.selectedSegmentIndex==1{
                let price = Double(priceInt) * 1.3
                costLabel.text = "Cost: $\(price)"
            }
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
          unitsSwitcher.selectedSegmentIndex = 0
            priceSwitcher.selectedSegmentIndex = 0
        
         lengthLabel.text = "Length: \(vehicles[row].length)m"
        
        nameLabel.text = vehicles[row].name
        makeLabel.text = "Make: \(vehicles[row].model)"
        costLabel.text = "Cost: \(vehicles[row].costInCredits)"
       
        classLabel.text = "Class: \(vehicles[row].vehicleClass!)"
        crewLabel.text = "Crew: \(vehicles[row].crew)"
        
        if vehicles[row].name == vehicles.last?.name{
            print("The last one, loading more")
            if vehicles[row].name == vehicles.last?.name{
                print("The last one, loading more")
                if nextPageForVehicles != nil {
                    getVehicles(urlToGet: nextPageForVehicles!, finished: sortVehicles)
                }
                
            }
        
        
    }
}
    func sortVehicles(){
        let sortedVehicles = self.vehicles.sorted{$0.length.compare($1.length, options: .numeric) == .orderedDescending}
        let largestVehicle = sortedVehicles.first
        let smallestVehicle = sortedVehicles.last
        DispatchQueue.main.async {
            self.smallestLabel.text = "Smallest \(smallestVehicle!.name)"
            self.largestLabel.text = "Largest \(largestVehicle!.name)"
        }
        
    }
    
    
   
    
    
}
