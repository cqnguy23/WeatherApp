//
//  NewLocationViewController.swift
//  WeatherApp
//
//  Created by Tom Nguyen on 7/13/20.
//  Copyright © 2020 tomnguyen. All rights reserved.
//

import UIKit


class NewLocationViewController: UITableViewController {
    @IBOutlet var newCity: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
      
    }
    

    
    
    var weather: WeatherMO!
    // MARK: - Table view data source

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if newCity.text == "" {
            let alertController = UIAlertController(title: "Oops", message: "Please fill in the city's name or zip code of the desired location.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            weather = WeatherMO(context: appDelegate.persistentContainer.viewContext)
            weather.location = newCity.text?.capitalizingFirstLetter()
            
            appDelegate.saveContext()
        }
        print("Show This")

    }
    

    
  

}
