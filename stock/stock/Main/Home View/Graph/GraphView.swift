//
//  GridView.swift
//  stock
//
//  Created by Lauriane Haydari on 22/05/2020.
//  Copyright © 2020 Christophe Bugnon. All rights reserved.
//

import UIKit

class GraphView: UIView {

    // MARK: - Properties

    private(set) var caLayer: CALayer

    private var graphDataItem: GraphDataItem?

    private var w: CGFloat { return bounds.width }
    private var h: CGFloat { return bounds.height }

    private(set) var gridDrawer: GraphDrawer

    private var shouldLayout: Bool = true

    var touchPoint: CGPoint?

    // MARK: - Update

    func updateWithValues(_ graphDataItem: GraphDataItem) {
        self.graphDataItem = graphDataItem
        self.gridDrawer.getData(graphDataItem: graphDataItem)
        self.caLayer.setNeedsDisplay()
    }

    // MARK: - Initializer

    override init(frame: CGRect) {
        self.caLayer = CALayer()
        self.caLayer.contentsScale = UIScreen.main.nativeScale

        self.gridDrawer = GraphDrawer()
        self.caLayer.delegate = self.gridDrawer

        super.init(frame: frame)

        backgroundColor = Constants.gridGray

        self.layer.addSublayer(self.caLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.caLayer.frame = self.bounds

        if !shouldLayout { return }

        shouldLayout = false

        guard let data = graphDataItem else { return }
        let hDivider = 7
        let vDivider = (Int(data.maxPrice - data.minPrice)) / 4
        let numberOfdays = data.day.count

        setUpLabels(horizontal: true, min: 0, max: numberOfdays, divider: hDivider)
        setUpLabels(horizontal: false, min: Int(data.minPrice), max: Int(data.maxPrice), divider: vDivider)
    }

    // MARK: - Touches Functions

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let firstTouch = touches.first!.location(in: self)
        let firstPoint = CGPoint(x: firstTouch.x, y: firstTouch.y)
        touchPoint = firstPoint
        self.gridDrawer.movePoint(at: firstTouch, secondPoint: nil)
        self.caLayer.setNeedsDisplay()

        if touches.count > 1 {
            let secondTouch = touches[touches.index(after: touches.startIndex)].location(in: self)
            self.gridDrawer.movePoint(at: firstPoint, secondPoint: secondTouch)
            self.caLayer.setNeedsDisplay()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.gridDrawer.moveEnded()
        touchPoint = nil
        self.caLayer.setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        let label = UILabel()

        if touchPoint != nil {
            label.textColor = .blue
            label.frame.origin = CGPoint(x: touchPoint!.x, y: bounds.minY - 80)

            label.frame = CGRect(origin: CGPoint(x: touchPoint!.x, y: bounds.minY - 80), size: CGSize(width: 100, height: 50))
            label.text = "\(touchPoint?.x ?? 0)"
        }
        self.addSubview(label)
    }

    // MARK: - Private Functions

    private func setUpLabels(horizontal: Bool, min: Int, max: Int, divider: Int) {
        guard let data = graphDataItem else { return }
        let horizontalStep = (w - 40) / CGFloat(data.day.count)
        let verticalStep = h / (CGFloat(data.maxPrice - data.minPrice))

        for i in min..<max where i % divider == 0 {
            let label = UILabel()
            label.textColor = .white
            label.font = label.font.withSize(13)
            if horizontal {
                let x = CGFloat(i) * horizontalStep
                label.frame = CGRect(origin: CGPoint(x: x + 5, y: h - 30), size: CGSize(width: 50, height: 50))
                let days = data.day
                days.enumerated().forEach { (index, item) in
                    if index - 1 == i {
                        label.text = "\(item)"
                    }
                }
            } else {
                let y = ((CGFloat(max) - CGFloat(i)) * verticalStep) - 50
                label.frame = CGRect(origin: CGPoint(x: w - 30, y: y), size: CGSize(width: 50, height: 50))
                label.text = "\(i)"
            }
            self.addSubview(label)
        }
    }
//
//    func setUpLabelMoving() {
//        let label = UILabel()
//        guard  let touchPoint = touchPoint else { return }
//        label.textColor = .blue
//        label.text = "label"
//        label.font = label.font.withSize(13)
//        label.frame = CGRect(x: touchPoint.x, y: bounds.midY, width: 30, height: 30)
//        self.addSubview(label)
//    }

}
