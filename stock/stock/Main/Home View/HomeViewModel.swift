//
//  HomeViewModel.swift
//  stock
//
//  Created by Lauriane Haydari on 18/06/2020.
//  Copyright © 2020 Christophe Bugnon. All rights reserved.
//

import Foundation

class HomeViewModel {

    // MARK: - Properties

    static let shared = HomeViewModel()

    private var graphDataItems: [GraphDataItem] = [] {
        didSet {
            self.visibleItems?(self.graphDataItems)
        }
    }

    var manager = HomeManager.shared

    // MARK: - Outputs

    var visibleItems: (([GraphDataItem]) -> Void)?

    // MARK: - Inputs

    func viewDidLoad() {
        setUpGraphDataItems()
    }

    // MARK: - Private Files

    fileprivate func setUpGraphDataItems() {
        let data = manager.getFakeData()
        guard let firstData = data.first else { return }
        let graphDataItem = GraphDataItem(name: firstData.name,
                                          symbol: firstData.symbol,
                                          maxPrice: firstData.maxPrice,
                                          minPrice: firstData.minPrice,
                                          day: firstData.day,
                                          price: firstData.price,
                                          atClose: firstData.atClose,
                                          inflation: firstData.inflation)
        graphDataItems = [graphDataItem]
    }
}
