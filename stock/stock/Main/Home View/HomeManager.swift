//
//  GridManager.swift
//  stock
//
//  Created by Lauriane Haydari on 17/06/2020.
//  Copyright © 2020 Christophe Bugnon. All rights reserved.
//

import Foundation

class HomeManager {

    let calendar = Calendar.current
    let date = Date()

    private var fakeData: [GraphData] = []

    static let shared = HomeManager()

    private init() {
        getLabelData()
    }

    func getFakeData() -> [GraphData] {
        return fakeData
    }

    func update(with value: [GraphData]) {
        self.fakeData = value
    }

    func getLabelData() {
        var days: [Int] = []

        setUpDays(&days)

        fakeData = [GraphData(name: "Apple Inc",
                              symbol: "AAPL",
                              maxPrice: 333.46,
                              minPrice: 278.58,
                              day: days,
                              price: [282.97, 283.17, 278.58, 287.73, 293.80, 289.07, 293.16, 297.56, 300.63, 303.74, 310.13, 315.01, 311.41, 307.65, 309.54, 307.71, 314.96, 313.14, 319.23, 316.85, 318.89, 316.73, 318.11, 318.25, 317.94, 321.85, 323.34, 325.12, 322.32, 331.50, 333.46],
                              atClose: "335.12",
                              inflation: "+ 0,55 %")]
    }

    fileprivate func setUpDays(_ days: inout [Int]) {
        for i in (-30...0) {
            let day = calendar.component(.day, from: calendar.date(byAdding: .day, value: i, to: date)!)
            days.append(day)
        }
    }
}
