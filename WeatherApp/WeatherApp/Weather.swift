//
//  Weather.swift
//  WeatherApp
//
//  Created by Tom Nguyen on 7/11/20.
//  Copyright © 2020 tomnguyen. All rights reserved.
//

import Foundation
extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
class Weather {
    var overview: String = ""
    var temperature: Double = 0.0
    var location: String = ""
    
    init(overview: String, temperature: Double, location: String) {
        self.overview = overview
        self.temperature = temperature
        self.location = location
    }
    init() {
        self.overview = ""
        self.temperature = 0
        self.location = ""
    }
}
struct Description: Codable {
    var description: String = ""
}
struct DescriptionStores: Codable {
    var weather: [Description]
}

struct Location : Codable {
    var name: String = ""
}

struct Temperature: Codable {
    var temp: Double = 0
    
    enum CodingKeys: String, CodingKey {
        case temp = "main"
    }
    enum tempKeys: String, CodingKey {
        case temp
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let temp1 = try values.nestedContainer(keyedBy: tempKeys.self, forKey: .temp)
        temp = try temp1.decode(Double.self, forKey: .temp)
    }
}
