//
//  ViewController.swift
//  WeatherApp
//
//  Created by Tom Nguyen on 7/10/20.
//  Copyright © 2020 tomnguyen. All rights reserved.
//
import CoreLocation
import UIKit
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var temperature: UILabel!
    @IBOutlet var overview: UILabel!
    @IBOutlet var location: UILabel!
    @IBOutlet var icon: UIImageView!
    var tempFound: Bool = true
    var weatherStr: String = ""
 
    var lat : Int = 0
    var lon: Int = 0
    var locationManager = CLLocationManager()
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        guard let weatherURL = URL(string: weatherStr) else {
            return
        }
        updateWeather(url: weatherURL)
        viewDidLoad()
    }
    
    //Update current location's weather
    @IBAction func updateWithCurLoc() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configure Back Button Item
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        backItem.tintColor = .white
        navigationItem.backBarButtonItem = backItem
        
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if weatherStr == "" {
            updateWithCurLoc()
        }
        guard let weatherURL = URL(string: weatherStr) else {
            return
        }
        updateWeather(url: weatherURL)
        
        
    }
    //Get current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        lat = Int(locationValue.latitude)
        lon = Int(locationValue.longitude)
        weatherStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=63e3cea68f8e05f3939aeb79921c171c&units=metric"
        guard let weatherURL = URL(string: weatherStr) else {
            return
        }
        updateWeather(url: weatherURL)
    }

    var weathers: [WeatherMO] = []
    
    
    //Update current weather
    func updateWeather(url: URL) {
        var weather = Weather()
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if let error = error {
            print(error)
            return
        }
        if let data = data {
            weather = self.parseJsonData(data: data)
            
            OperationQueue.main.addOperation( {
                let roundedTemp = Int(round(weather.temperature))
                self.temperature.text = String(roundedTemp) + "°C"
                self.overview.text = weather.overview.capitalized
                self.location.text = weather.location.capitalized
                let description = self.overview.text?.lowercased() ?? ""
                print(description)
                if (description.contains("sun") || description.contains("clear")) {
                    self.icon.image = UIImage(named: "sunny")
                    
                }
                else if (description.contains("wind")) {
                    self.icon.image = UIImage(named: "windy")
                }
                else if (description.contains("mist")) || (description.contains("fog")) {
                    self.icon.image = UIImage(named: "misty")
                }
                else if (description.contains("rain")) {
                    self.icon.image = UIImage(named: "rainy")
                }
                else if (description.contains("thunder")) {
                    self.icon.image = UIImage(named: "thunderstorm")
                }
                else {
                    self.icon.image = UIImage(named: "weather")
                }
           
            })
            //Reload table view
        }
        })
       
        
        task.resume()
        
    }
    func parseJsonData(data: Data) -> Weather {
        let decoder = JSONDecoder()
        let weather = Weather()

        do  {
            let descriptionStore = try decoder.decode(DescriptionStores.self, from: data)
            let descriptions = descriptionStore.weather
            for temp in descriptions {
                weather.overview = temp.description
            }
            let temperature = try decoder.decode(Temperature.self, from: data)
            weather.temperature = temperature.temp
            let location = try decoder.decode(Location.self, from: data)
            weather.location = location.name
        }
        catch {
            tempFound = false
            print(error)
        }
        
        if !tempFound {
            OperationQueue.main.addOperation
             {
                let alertController = UIAlertController(title: "Oops", message: "We can't check for the weather at the desired location. Please input another location.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
                self.tempFound = true
            }
        }
        
        return weather
    }
    @IBAction func newLocationSelected(unwindSegue: UIStoryboardSegue) {
        if let newLocationController = unwindSegue.source as? NewLocationViewController
        {
            var newLocation = newLocationController.newCity?.text
            newLocation = newLocation?.lowercased().replacingOccurrences(of: " ", with: "")
            print(newLocation!)
            weatherStr = "https://api.openweathermap.org/data/2.5/weather?q=\(newLocation!)&appid=63e3cea68f8e05f3939aeb79921c171c&units=metric"
            print(weatherStr)
            guard let weatherURL = URL(string: weatherStr) else {
                return
            }
            updateWeather(url: weatherURL)
        }
    }
}



