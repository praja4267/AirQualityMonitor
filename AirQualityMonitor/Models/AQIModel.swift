//
//  AQIModel.swift
//  AirQualityMonitor
//
//  Created by Rajasekhar on 13/09/21.
//

import Foundation
struct AQIModel: Decodable {
    var city: String
    var aqi: Double
    var time: Date?
    
    init(city: String, aqi: Double, time: Date = Date()) {
        self.city = city
        self.aqi = aqi
        self.time = time
    }
    enum CodingKeys: String, CodingKey {
        case city, aqi
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        city = try container.decode(String.self, forKey: .city)
        aqi = try container.decode(Double.self, forKey: .aqi).roundTo2f
        time = Date()
    }
}
