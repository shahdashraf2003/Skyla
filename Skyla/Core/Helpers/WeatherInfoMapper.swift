//
//  WeatherInfoMapper.swift
//  Skyla
//
//  Created by Shahd Ashraf on 28/05/2026.
//


struct WeatherInfoMapper {

    static func map(from current: CurrentWeather) -> [InfoItem] {
        [
            .init(title: "VISIBILITY", value: "\(Int(current.visKm)) km"),
            .init(title: "HUMIDITY", value: "\(current.humidity)%"),
            .init(title: "FEELS LIKE", value: "\(Int(current.feelslikeC))°"),
            .init(title: "PRESSURE", value: "\(Int(current.pressureMb)) mb"),
            .init(title: "WIND", value: "\(Int(current.windKph)) kph \(current.windDir)"),
            .init(title: "UV INDEX", value: "\(Int(current.uv))")
        ]
    }
}
