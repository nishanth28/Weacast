//
//  CityViewController.swift
//  weacast
//
//  Created by Nishanth P on 1/1/17.
//  Copyright © 2017 Nishapp. All rights reserved.
//

import UIKit
import Alamofire
import SCLAlertView

struct weatherObject {
    var _city: String!
    var _temp: String!
    var _weatherType: String!
    var _date: String!
    var _humidity: String!
    var _wind: String!
    var _rain: String!
}

var _cityName : String!
var _date : String!
var _weatherType : String!
var _currentTemp : String!
var _highTemp: String!
var _humidity: Int!
var _wind : Double!
var _rain : Double!

var nsdefaults = UserDefaults.standard
// Data Encapsulation or Data Hiding


var cityName: String{
    if _cityName == nil{
        _cityName = ""
    }
    return _cityName
}

var date: String{
    if _date == nil{
        _date = ""
    }
    let dateFormat = DateFormatter()
    dateFormat.dateStyle = .long
    dateFormat.timeStyle = .none
    
    let currentDate = dateFormat.string(from: Date())
    _date = "Today, \(currentDate)"
    
    return _date
}

var weatherType: String{
    if _weatherType == nil{
        _weatherType = ""
    }
    return _weatherType
}

var currentTemp: String {
    if _currentTemp == nil{
        _currentTemp = "0"
    }
    return _currentTemp
}

var humidity: Int {
    if _humidity == nil{
        _humidity = 0
    }
    return _humidity
}

var wind: Double {
    if _wind == nil{
        _wind = 0.0
    }
    return _wind
}

var rain: Double {
    if _rain == nil{
        _rain = 0.0
    }
    return _rain
}

func currentWeatherInfo(city:String,callback:@escaping(weatherObject)->())
{
    //Alamofire
    
    let CITY: String = city
    let CURRENT_URL = "\(BASE_URL)q=\(CITY)\(APP_ID)\(API_KEY)"
    print(CURRENT_URL)
    let currentWeatherURL = URL(string: CURRENT_URL)
    var wobject = weatherObject()
    wobject._date = date
    Alamofire.request(currentWeatherURL!).responseJSON{ response in
        let result = response.result
        if let dict = result.value as? Dictionary<String,AnyObject>{
            if let name = dict["name"] as? String{
                _cityName = name.capitalized
                print(_cityName)
                wobject._city = name.capitalized
                
            }
            if let weather = dict["weather"] as? [Dictionary<String,AnyObject>]{
                if let main = weather[0]["main"] as? String {
                    _weatherType = main.capitalized
                    print(_weatherType)
                    wobject._weatherType = main.capitalized
                }
            }
            if let main = dict["main"] as? Dictionary<String,AnyObject> {
                if let currentTemperature = main["temp"] as? Double{
                    
                    let ktoFstep1 = (currentTemperature*(9/5)-459.67)
                    let ktoF = Int(round(10*ktoFstep1/10))
                    _currentTemp = "\(ktoF)"
                    print(_currentTemp)
                    wobject._temp = "\(ktoF)"+"°F"

                    
                }
                
                if let humidity = main["humidity"] as? Int{
                    _humidity = humidity
                    print(_humidity)
                    wobject._humidity = "\(humidity)"
                }
            }
            
            if let wind = dict["wind"] as? Dictionary<String,AnyObject> {
                if let windSpeed = wind["speed"] as? Double{
                    _wind = windSpeed
                    print(_wind)
                    wobject._wind = "\(windSpeed)"
                }
            }
            
            if let clouds = dict["clouds"] as? Dictionary<String,AnyObject> {
                if let all = clouds["all"] as? Double{
                    _rain = all
                    print(_rain)
                    wobject._rain = "\(all)"
                }
            }
            
        }
        
        callback(wobject)
        
    }
    
    
    
    
}



var cities1 : [String] = ["Sydney","Beijing","Chennai","Dubai","London","NewYork"]

var cities = [String]()

class CityViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    
    @IBOutlet weak var logoDisplay: UIImageView!
    @IBOutlet weak var cityTable: UITableView!
    @IBOutlet weak var labelDisplay: UILabel!
    
    @IBAction func addCity(_ sender: Any) {
        
        
       // let alert = SCLAlertView()
        let appearance = SCLAlertView.SCLAppearance(
            //showCircularIcon: true,
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        let alertViewIcon = UIImage(named: "Logo") //Replace the IconImage text with the image name
        var alertText = ""
        let txt = alertView.addTextField("Enter a valid city name")
        alertView.addButton("Done") {
            print("City: \(txt.text)")
            let cityText1 = txt.text
            
            let cityText = cityText1?.replacingOccurrences(of: " ", with: "+")
            if cityText == "" || cityText == nil{
                alertText = "Please Enter a valid City"
            }else
            {
            self.labelDisplay.isHidden = true
            self.logoDisplay.isHidden = true
            self.cityTable.isHidden = false
            if let saveCity = nsdefaults.object(forKey: "cities") as? [String]{
                    cities = saveCity
                    cities.append(cityText!)
                    nsdefaults.set(cities,forKey: "cities")
                }
            else{
                cities.append(cityText!)
                nsdefaults.set(cities,forKey: "cities")
                
                }
          
            self.cityTable.reloadData()
            }
        
            
        }
        alertView.showInfo(
            "Weacast", subTitle: "\(alertText)", colorStyle: 0x5D9ED4,colorTextButton: 0xFFFFFF,
            circleIconImage: alertViewIcon)
        
        
        //alertView.showEdit("Edit View", subTitle: "This alert view shows a text box")
        
    }
    
    func save(){
        
    }
    
    
        override func viewDidLoad() {
        super.viewDidLoad()
            city{
                (city) in
                cities = city
                self.cityTable.reloadData()
                
            }

            
            if cities == [] {
                cityTable.isHidden = true
                logoDisplay.isHidden = false
                labelDisplay.isHidden = false
            }
            else{
                cityTable.isHidden = false
                logoDisplay.isHidden = true
                labelDisplay.isHidden = true
                
            }
            
    }
    
    override func viewDidAppear(_ animated: Bool) {
           }
    
    func city(completion:(_ cities:[String])->())
    {
        var city : [String] = [String]()
        if let items = nsdefaults.object(forKey:"cities") as? [String]{
            for item in items{
                city.append(item)
            }
        }
        completion(city)
    }

    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return cities.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
    let cell = cityTable.dequeueReusableCell(withIdentifier:"cell", for:indexPath) as! CitiesTableViewCell
    
    cell.backgroundColor = UIColor.clear
    cell.cityLabel.text = cities[indexPath.row].replacingOccurrences(of: "+", with: " ")
        
    currentWeatherInfo(city: cities[indexPath.row]) { (weatherObject) in
        
        if let temp = weatherObject._temp{
            
            cell.currentTempLabel.text = temp 
            
        }
        if let wtype = weatherObject._weatherType{
            
            cell.climateImage.image = UIImage(named:"\(wtype)")
            
        }
        else
        {
            cell.climateImage.image = UIImage(named:"clouds")
        }
        
        }
    
        
    return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            cities.remove(at: indexPath.row)
            cityTable.deleteRows(at: [indexPath], with: .fade)
            nsdefaults.set(cities,forKey:"cities")
        }
        else if editingStyle == .insert
        {
            print("insert")
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
      let temp1 = cities[sourceIndexPath.row]
      let temp2 = cities[destinationIndexPath.row]
    
        cities[sourceIndexPath.row] = temp2
        cities[destinationIndexPath.row] = temp1
        cityTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let index = cityTable.indexPathForSelectedRow?.row
        let destination = segue.destination as! RootViewController
        destination.pageIndex = index!
    }
    
    
}

