//
//  GraphDataItem.swift
//  stock
//
//  Created by Lauriane Haydari on 27/05/2020.
//  Copyright © 2020 Christophe Bugnon. All rights reserved.
//

import Foundation

struct GraphDataItem {
    let name: String
    let symbol: String
    let maxPrice: Float
    let minPrice: Float
    let day: [Int]
    let price: [Float]
    let atClose: String
    let inflation: String
}

