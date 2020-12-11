//
//  Constants.swift
//  stock
//
//  Created by Lauriane Haydari on 02/06/2020.
//  Copyright © 2020 Christophe Bugnon. All rights reserved.
//

import UIKit

struct Constants {
    static let heightScrollView: CGFloat = 400
    static let margin: CGFloat = 20

    static let gridGray: UIColor = UIColor(named: "gridGray")!
    static let blueSky: UIColor = UIColor(named: "blueSky")!
    static let green: UIColor = .green
    static let red: UIColor = .red

    static let startGreen: UIColor = UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 0.3)
    static let endGreen: UIColor = UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 0.0)
    static let greenGradient: [CGColor] = [Constants.startGreen.cgColor, Constants.endGreen.cgColor]

    static let startBlue: UIColor = UIColor(red: 0/255, green: 9/255, blue: 255/255, alpha: 0.3)
    static let endBlue: UIColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 0.0)
    static let blueColors: [CGColor] = [Constants.startBlue.cgColor, Constants.endBlue.cgColor]

    static let colorLocations: [CGFloat] = [0.0, 1.0]
}
