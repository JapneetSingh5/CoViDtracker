//
//  CoViDtracker.swift
//  CoViDtracker
//
//  Created by Japneet Singh on /266/20.
//

import Foundation

struct Country: Identifiable{
    var id = UUID()
    var pos: String
    var name: String
    var confirmedCount: Int
    var recoveredCount: Int
    var deceasedCount: Int
    var thumbnail: String
}

let testData = [
    Country(pos: "1", name: "United States Of America", confirmedCount: 2487511 , recoveredCount: 1043520, deceasedCount: 126372, thumbnail: "🇺🇸" ),
    Country(pos: "2", name: "Brazil", confirmedCount: 1207721 , recoveredCount: 649908, deceasedCount: 54434, thumbnail: "🇧🇷" ),
    Country(pos: "3", name: "Russia", confirmedCount: 613994 , recoveredCount: 375164, deceasedCount: 8605, thumbnail: "🇷🇺" ),
    Country(pos: "4", name: "India", confirmedCount: 491168 , recoveredCount: 285664, deceasedCount: 15308, thumbnail: "🇮🇳" ),
    Country(pos: "5", name: "United Kingdom", confirmedCount: 307980 , recoveredCount: 0, deceasedCount: 43320, thumbnail: "🇬🇧" ),
]
