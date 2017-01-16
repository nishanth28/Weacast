//
//  DataViewController.swift
//  weacast
//
//  Created by Nishanth P on 12/31/16.
//  Copyright © 2016 Nishapp. All rights reserved.
//

import UIKit
import Alamofire

class DataViewController: UIViewController {

   
    var dataObject: String = ""
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var wImage: UIImageView!
    @IBOutlet weak var temperature: UILabel!

    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var rainy: UILabel!
    
    @IBOutlet weak var view1day: UILabel!
    @IBOutlet weak var view1Image: UIImageView!
    @IBOutlet weak var view1Temp: UILabel!
    @IBOutlet weak var view1HighTemp: UILabel!
    
    @IBOutlet weak var view2day: UILabel!
    @IBOutlet weak var view2Image: UIImageView!
    @IBOutlet weak var view2Temp: UILabel!
    @IBOutlet weak var view2HighTemp: UILabel!
    
    @IBOutlet weak var view3day: UILabel!
    @IBOutlet weak var view3Image: UIImageView!
    @IBOutlet weak var view3Temp: UILabel!
    @IBOutlet weak var view3HighTemp: UILabel!
    
    @IBOutlet weak var view4day: UILabel!
    @IBOutlet weak var view4Image: UIImageView!
    @IBOutlet weak var view4Temp: UILabel!
    @IBOutlet weak var view4HighTemp: UILabel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var totalPages:Int = 0
    var pageIndex:Int = 0
   // var currentWeather : WeatherInformation!
    var prediction : Prediction!
    var predicts = [Prediction]()
    
    var testString : String = ""
    
    func downloadPredictionData(city:String,completed: @escaping DownloadComplete)
    {
        let CITY: String = city
        let CURRENT_URL = "\(BASE_URL)q=\(CITY)\(APP_ID)\(API_KEY)"
        print(CURRENT_URL)
        let PREDICTION_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?q="+"\(CITY)"+"&appid=ed168af694450eed3b3b8e14735855a6"
        let predictionURL = URL (string: PREDICTION_URL)
        Alamofire.request(predictionURL!).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String,AnyObject>{
                
                if let list = dict["list"] as? [Dictionary<String,AnyObject>]{
                    
                    for obj in list{
                        
                        let predict = Prediction(weatherDict:obj)
                        self.predicts.append(predict)
                        print(obj)
                        
                    }
                }
                
            }
            completed()
            
        }
        
        
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
       //currentWeather = WeatherInformation()
        //prediction = Prediction()
       
        
        self.downloadPredictionData(city: cities[pageIndex]){
            let predictView1 = self.predicts[1]
            self.setObjectForView1(predict: predictView1)
            let predictView2 = self.predicts[2]
            self.setObjectForView2(predict: predictView2)
            let predictView3 = self.predicts[3]
            self.setObjectForView3(predict: predictView3)
            let predictView4 = self.predicts[4]
            self.setObjectForView4(predict: predictView4)

    }
         print(self.testString)
    }
    
    func setObjectForView1(predict:Prediction){
        
        view1Temp.text = predicts[1].lowTemp
        let image1 = predicts[1].weatherType
        view1Image.image = UIImage(named:"\(image1)")
        view1day.text = predicts[1].date
        view1HighTemp.text = predicts[1].highTemp
        
    }
    func setObjectForView2(predict:Prediction){
        
        view2HighTemp.text = predicts[2].highTemp
        view2Temp.text = predicts[2].lowTemp
        view2Image.image = UIImage(named:"\(predicts[2].weatherType)")
        view2day.text = predicts[2].date
        
    }
    func setObjectForView3(predict:Prediction){
        
        view3HighTemp.text = predicts[3].highTemp
        view3Temp.text = predicts[3].lowTemp
        view3Image.image = UIImage(named:"\(predicts[3].weatherType)")
        view3day.text = predicts[3].date
        
    }
    func setObjectForView4(predict:Prediction){
        
        view4HighTemp.text = predicts[2].highTemp
        view4Temp.text = predicts[4].lowTemp
        view4Image.image = UIImage(named:"\(predicts[3].weatherType)")
        view4day.text = predicts[4].date
        
    }



    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.cityLabel.text = dataObject.replacingOccurrences(of: "+", with: " ")
        
        currentWeatherInfo(city:dataObject){ (weatherObject) in
            if let weather : weatherObject = weatherObject {
                if let temp = weather._temp{
                    self.temperature.text = temp
                }
                if let wspeed = weather._wind{
                    self.windSpeed.text = wspeed
                }
                if let date = weather._date{
                    self.date.text = date
                }
                if let humid = weather._humidity{
                    self.humidity.text = humid
                }
                if let rain = weather._rain{
                    self.rainy.text = rain
                }
                if let type = weather._weatherType{
                    self.wImage.image = UIImage(named:"\(type)")
                    
                }
            }
            
        }
        pageControl.numberOfPages = totalPages
        pageControl.currentPage = pageIndex
        
    }


}

