//
//  GridDrawer.swift
//  stock
//
//  Created by Lauriane Haydari on 23/05/2020.
//  Copyright © 2020 Christophe Bugnon. All rights reserved.
//

import UIKit

class GraphDrawer: NSObject, CALayerDelegate {

    private var graphDataItem: GraphDataItem?
    private var bounds: CGRect!

    private var w: CGFloat { return bounds.width }
    private var h: CGFloat { return bounds.height }

    var HGridLinesY: [CGFloat] = []

    private var firstTouchPoint: CGPoint?
    private var secondTouchPoint: CGPoint?

    // MARK: Public function

    func layoutSublayers(of layer: CALayer) {
        self.bounds = layer.bounds
    }

    func movePoint(at firstPoint: CGPoint, secondPoint: CGPoint?) {
        firstTouchPoint = firstPoint
        secondTouchPoint = secondPoint
    }

    func moveEnded() {
        firstTouchPoint = nil
        secondTouchPoint = nil
    }

    // MARK: - Get data

    func getData(graphDataItem: GraphDataItem) {
        self.graphDataItem = graphDataItem
    }

    // MARK: - Draw

    func draw(_ layer: CALayer, in ctx: CGContext) {
        guard let data = graphDataItem else { return }
        returnGrid(ctx, data)

        let price = data.price
        guard let firstHLineY = HGridLinesY.first else { return }

        let horizontalStep = (w - 40) / CGFloat(data.day.count)
        let verticalStep = firstHLineY / (CGFloat(data.maxPrice - data.minPrice))

        let points: [CGPoint] = price.enumerated().map { (index, item) in
            let x = CGFloat(index) * horizontalStep
            let y = (CGFloat(data.maxPrice) - CGFloat(item)) * verticalStep
            return CGPoint(x: x, y: y)
        }
        returnGraph(ctx, points, Constants.green.cgColor, Constants.greenGradient)

        if firstTouchPoint != nil {
            guard let endPoint = points.last else { return }
            guard screenSize(touch: firstTouchPoint!, endPoint: endPoint) else { return }
            ctx.saveGState()
            returnGraph(ctx, points, Constants.blueSky.cgColor, Constants.blueColors)
            ctx.resetClip()
            returnCircleAndLineOnGraph(ctx, points, stepY: verticalStep)
            ctx.restoreGState()
        }

    }

    // MARK: - Private Functions

    fileprivate func returnGrid(_ ctx: CGContext, _ data: GraphDataItem) {
        let hDivider = 7
        let vDivider = (Int(data.maxPrice - data.minPrice)) / 4
        drawLines(horizontalLabels: true, ctx, min: 0, max: Int(data.day.count), divider: hDivider, w: w, h: h)
        drawLines(horizontalLabels: false, ctx, min: Int(data.minPrice), max: Int(data.maxPrice), divider: vDivider, w: w, h: h)
    }

    fileprivate func drawLines(horizontalLabels: Bool, _ ctx: CGContext, min: Int, max: Int, divider: Int, w: CGFloat, h: CGFloat) {
        ctx.setLineCap(.square)
        ctx.setLineWidth(0.1)
        ctx.setStrokeColor(UIColor.white.cgColor)
        let horizontalStep = (w - 40) / CGFloat(max)
        let verticalStep = h / (CGFloat(max) - CGFloat(min))

        ctx.move(to: CGPoint(x: 0, y: 0))
        ctx.addLine(to: CGPoint(x: w, y: 0))

        for i in min..<max where i % divider == 0 {

            if horizontalLabels {
                let x = CGFloat(i) * horizontalStep
                drawVerticalLines(i, horizontalStep, ctx, h, x: x)
            } else {
                let y = (CGFloat(max) - CGFloat(i)) * verticalStep + Constants.margin
                drawHorizontalLines(i, verticalStep, ctx, w, y: y)
                HGridLinesY.append(y)
            }
        }
        ctx.strokePath()
    }

    fileprivate func drawVerticalLines(_ i: Int, _ horizontalStep: CGFloat, _ ctx: CGContext, _ h: CGFloat, x: CGFloat) {
        ctx.move(to: CGPoint(x: x, y: 0))
        ctx.addLine(to: CGPoint(x: x, y: h))
    }
    
    fileprivate func drawHorizontalLines(_ i: Int, _ verticalStep: CGFloat, _ ctx: CGContext, _ w: CGFloat, y: CGFloat) {
        ctx.move(to: CGPoint(x: 0, y: y))
        ctx.addLine(to: CGPoint(x: w, y: y))
    }

    fileprivate func returnGraph(_ ctx: CGContext, _ points: [CGPoint], _ color: CGColor, _ colors: [CGColor]) {
        guard let lastPoint = points.last else { return }
        guard let firstYHGridLine = HGridLinesY.first else { return }
        let graphStartPoint = CGPoint(x: bounds.minX, y: 0)
        let graphEndPoint = CGPoint(x: bounds.minX, y: firstYHGridLine)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: Constants.colorLocations)!

        ctx.setStrokeColor(color)
        ctx.setLineWidth(2)
        ctx.beginPath()
        ctx.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        ctx.addLines(between: points)
        ctx.addLine(to: CGPoint(x: lastPoint.x, y: bounds.maxY))
        ctx.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        ctx.clip()

        ctx.drawLinearGradient(gradient, start: graphStartPoint, end: graphEndPoint, options: [])
        ctx.addLines(between: points)
        ctx.drawPath(using: .stroke)
    }


    fileprivate func returnCircleAndLineOnGraph(_ ctx: CGContext, _ points: [CGPoint], stepY: CGFloat) {

        if let firstTouch = firstTouchPoint {
            // line
            ctx.setStrokeColor(Constants.blueSky.cgColor)
            ctx.setLineCap(.square)
            ctx.setLineWidth(1)
            ctx.move(to: CGPoint(x: firstTouch.x, y: bounds.minY))
            ctx.addLine(to: CGPoint(x: firstTouch.x, y: bounds.maxY))
            ctx.strokePath()

            // circle
            let centerPoint = points.filter { (point) in distanceX(from: point.x, to: firstTouch.x) <= stepY }
            guard let point = centerPoint.first else { return }
            ctx.setLineWidth(2)
            ctx.setStrokeColor(UIColor.black.cgColor)
            ctx.setFillColor(Constants.blueSky.cgColor)
            ctx.addArc(center: CGPoint(x: firstTouch.x, y: point.y), radius: 8, startAngle: CGFloat(0).degreesToRadians, endAngle: CGFloat(360).degreesToRadians, clockwise: false)
            ctx.drawPath(using: .fillStroke)

        }
        if let secondTouch = secondTouchPoint {
            // line
            ctx.setStrokeColor(Constants.red.cgColor)
            ctx.setLineCap(.square)
            ctx.setLineWidth(1)
            ctx.move(to: CGPoint(x: secondTouch.x, y: bounds.minY))
            ctx.addLine(to: CGPoint(x: secondTouch.x, y: bounds.maxY))
            ctx.strokePath()

            // circle
            let centerPoint = points.filter { (point) in distanceX(from: point.x, to: secondTouch.x) <= stepY }
            guard let point = centerPoint.first else { return }
            ctx.setLineWidth(2)
            ctx.setStrokeColor(UIColor.black.cgColor)
            ctx.setFillColor(Constants.red.cgColor)
            ctx.addArc(center: CGPoint(x: secondTouch.x, y: point.y), radius: 8, startAngle: CGFloat(0).degreesToRadians, endAngle: CGFloat(360).degreesToRadians, clockwise: false)
            ctx.drawPath(using: .fillStroke)
        }
    }

    fileprivate func distanceX(from xLhs: CGFloat, to xRhs: CGFloat) -> CGFloat {
        let xDistance = xLhs - xRhs
        return (xDistance * xDistance).squareRoot()
    }

    fileprivate func screenSize(touch: CGPoint, endPoint: CGPoint) -> Bool {
        return touch.x > self.bounds.minX && touch.y > self.bounds.minY && touch.x < endPoint.x && touch.y < self.bounds.maxY
    }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
}
