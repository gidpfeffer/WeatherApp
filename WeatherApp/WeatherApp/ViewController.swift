//
//  ViewController.swift
//  WeatherApp
//
//  Created by Gideon Pfeffer on 4/18/17.
//  Copyright © 2017 Gideon Pfeffer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let baseURLStart = "http://www.weather-forecast.com/locations/"
    
    let baseURLEnd = "/forecasts/latest"

    @IBOutlet weak var locationField: UITextField!
    
    @IBOutlet weak var displayLabel: UILabel!
    
    @IBAction func submitButton(_ sender: Any) {

        if let city: String = locationField.text{
            let concatURL: String = (baseURLStart + city + baseURLEnd).replacingOccurrences(of: " ", with: "-")
            if let url = URL(string: concatURL){
            let request = NSMutableURLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                data, response, error in
                
                var message = ""
                
                if error != nil{
                    
                    print(error ?? "default error")
                    
                } else{
                    if let unwrappedData = data{
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        
                        let infoArray = dataString?.components(separatedBy: "</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                        
                        if (infoArray?.count)! > 1{
                            
                            if let messageArray = infoArray?[1].components(separatedBy: "</span>"){
                                if messageArray.count > 1{
                                    message = messageArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                }
                            }
                        }
                    }
                }
                
                if message == ""{
                    
                    message = "The weather there could not be found, please enter another location"
                }
                
                DispatchQueue.main.sync(execute: {
                    self.displayLabel.text = message
                })
            }
            
            task.resume()
                
            } else{
                self.displayLabel.text = "Invalid location, please try again"
            }
            
        } else{
            displayLabel.text = "Please Enter Valid Text"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        locationField.resignFirstResponder()
        return true
    }


}

