

import Foundation
import SwiftUI

import UIKit

public class PieChartUIKitView: UIView {

    public var entities: [PieChartEntity] = [] {
        didSet {
            setNeedsDisplay()
        }
    }

    private let segmentColors: [UIColor] = [
        .systemGreen, .systemYellow, .systemBlue,
        .systemOrange, .systemPurple, .systemGray
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .clear
        isOpaque = false
        contentMode = .redraw
    }

    public override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), !entities.isEmpty else { return }

        UIColor.systemBackground.setFill()
        context.fill(rect)

        let radius = min(bounds.width, bounds.height) / 2 - 20
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let lineWidth: CGFloat = 13
        let total = entities.reduce(Decimal(0)) { $0 + $1.value }
        guard total > 0 else { return }

        var displayEntities: [PieChartEntity] = []

        let topEntities = entities.prefix(5)
        for entity in topEntities {
            let percent = (NSDecimalNumber(decimal: entity.value).doubleValue /
                          NSDecimalNumber(decimal: total).doubleValue) * 100
            displayEntities.append(
                PieChartEntity(value: entity.value, label: entity.label, percent: percent)
            )
        }

        if entities.count > 5 {
            let othersValue = entities.dropFirst(5).reduce(Decimal(0)) { $0 + $1.value }
            let othersPercent = (NSDecimalNumber(decimal: othersValue).doubleValue /
                                NSDecimalNumber(decimal: total).doubleValue) * 100
            displayEntities.append(
                PieChartEntity(value: othersValue, label: "Остальные", percent: othersPercent)
            )
        }


        var startAngle = -CGFloat.pi / 2

        for (index, entity) in displayEntities.enumerated() {
            let fraction = CGFloat((entity.value / total) as NSDecimalNumber)
            let endAngle = startAngle + 2 * .pi * fraction

            context.setStrokeColor(segmentColors[index % segmentColors.count].cgColor)
            context.setLineWidth(lineWidth)
            context.setLineCap(.butt)
            context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            context.strokePath()

            startAngle = endAngle
        }

        drawLegend(in: context, center: center, entities: displayEntities, total: total)
    }

    private func drawLegend(in context: CGContext, center: CGPoint, entities: [PieChartEntity], total: Decimal) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left

        let font = UIFont.systemFont(ofSize: 12)
        let legendSize = CGSize(width: 120, height: CGFloat(entities.count) * 20)

        let startY = center.y - legendSize.height / 2
        for (index, entity) in entities.enumerated() {
            let percentage = entity.percent
            let text = String(format: "%.0f%% %@", percentage, entity.label)
            let point = CGPoint(x: center.x - 50, y: startY + CGFloat(index) * 20)

            let dotRect = CGRect(x: point.x, y: point.y + 4, width: 8, height: 8)
            let path = UIBezierPath(ovalIn: dotRect)
            segmentColors[index % segmentColors.count].setFill()
            path.fill()

            let textRect = CGRect(x: point.x + 14, y: point.y, width: 100, height: 16)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.label
            ]
            (text as NSString).draw(in: textRect, withAttributes: attributes)
        }
    }
}


public struct PieChartEntity {
    public let value: Decimal
    let label: String
    let percent: Double
    
    public init(value: Decimal, label: String, percent: Double) {
        self.value = value
        self.label = label
        self.percent = percent
    }
}









