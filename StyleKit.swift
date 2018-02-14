//
//  StyleKit.swift
//  Double Pendulum
//
//  Created by Andrei Frolov on 2018-02-13.
//  Copyright © 2018 SFU. All rights reserved.
//
//  Generated by PaintCode
//  http://www.paintcodeapp.com
//



import UIKit

public class StyleKit : NSObject {

    //// Cache

    private struct Cache {
        static let mercury: UIColor = UIColor(red: 0.922, green: 0.922, blue: 0.922, alpha: 1.000)
        static let magnesium: UIColor = UIColor(red: 0.757, green: 0.757, blue: 0.757, alpha: 1.000)
        static let aluminum: UIColor = UIColor(red: 0.667, green: 0.667, blue: 0.667, alpha: 1.000)
    }

    //// Colors

    @objc dynamic public class var mercury: UIColor { return Cache.mercury }
    @objc dynamic public class var magnesium: UIColor { return Cache.magnesium }
    @objc dynamic public class var aluminum: UIColor { return Cache.aluminum }

    //// Drawing Methods

    @objc dynamic public class func drawPendulumArm(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 164, height: 32), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 164, height: 32), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 164, y: resizedFrame.height / 32)


        //// Pendulum Body Drawing
        let pendulumBodyPath = UIBezierPath()
        pendulumBodyPath.move(to: CGPoint(x: 129, y: 19))
        pendulumBodyPath.addLine(to: CGPoint(x: 87, y: 19))
        pendulumBodyPath.addCurve(to: CGPoint(x: 84, y: 16), controlPoint1: CGPoint(x: 85.34, y: 19), controlPoint2: CGPoint(x: 84, y: 17.66))
        pendulumBodyPath.addCurve(to: CGPoint(x: 87, y: 13), controlPoint1: CGPoint(x: 84, y: 14.34), controlPoint2: CGPoint(x: 85.34, y: 13))
        pendulumBodyPath.addLine(to: CGPoint(x: 129, y: 13))
        pendulumBodyPath.addCurve(to: CGPoint(x: 132, y: 16), controlPoint1: CGPoint(x: 130.66, y: 13), controlPoint2: CGPoint(x: 132, y: 14.34))
        pendulumBodyPath.addCurve(to: CGPoint(x: 129, y: 19), controlPoint1: CGPoint(x: 132, y: 17.66), controlPoint2: CGPoint(x: 130.66, y: 19))
        pendulumBodyPath.close()
        pendulumBodyPath.move(to: CGPoint(x: 77, y: 19))
        pendulumBodyPath.addLine(to: CGPoint(x: 35, y: 19))
        pendulumBodyPath.addCurve(to: CGPoint(x: 32, y: 16), controlPoint1: CGPoint(x: 33.34, y: 19), controlPoint2: CGPoint(x: 32, y: 17.66))
        pendulumBodyPath.addCurve(to: CGPoint(x: 35, y: 13), controlPoint1: CGPoint(x: 32, y: 14.34), controlPoint2: CGPoint(x: 33.34, y: 13))
        pendulumBodyPath.addLine(to: CGPoint(x: 77, y: 13))
        pendulumBodyPath.addCurve(to: CGPoint(x: 80, y: 16), controlPoint1: CGPoint(x: 78.66, y: 13), controlPoint2: CGPoint(x: 80, y: 14.34))
        pendulumBodyPath.addCurve(to: CGPoint(x: 77, y: 19), controlPoint1: CGPoint(x: 80, y: 17.66), controlPoint2: CGPoint(x: 78.66, y: 19))
        pendulumBodyPath.close()
        pendulumBodyPath.move(to: CGPoint(x: 16, y: 23))
        pendulumBodyPath.addCurve(to: CGPoint(x: 9, y: 16), controlPoint1: CGPoint(x: 12.13, y: 23), controlPoint2: CGPoint(x: 9, y: 19.87))
        pendulumBodyPath.addCurve(to: CGPoint(x: 16, y: 9), controlPoint1: CGPoint(x: 9, y: 12.13), controlPoint2: CGPoint(x: 12.13, y: 9))
        pendulumBodyPath.addCurve(to: CGPoint(x: 23, y: 16), controlPoint1: CGPoint(x: 19.87, y: 9), controlPoint2: CGPoint(x: 23, y: 12.13))
        pendulumBodyPath.addCurve(to: CGPoint(x: 16, y: 23), controlPoint1: CGPoint(x: 23, y: 19.87), controlPoint2: CGPoint(x: 19.87, y: 23))
        pendulumBodyPath.close()
        pendulumBodyPath.move(to: CGPoint(x: 148, y: 0))
        pendulumBodyPath.addCurve(to: CGPoint(x: 134.16, y: 8), controlPoint1: CGPoint(x: 142.08, y: 0), controlPoint2: CGPoint(x: 136.93, y: 3.22))
        pendulumBodyPath.addLine(to: CGPoint(x: 29.84, y: 8))
        pendulumBodyPath.addCurve(to: CGPoint(x: 16, y: 0), controlPoint1: CGPoint(x: 27.07, y: 3.22), controlPoint2: CGPoint(x: 21.92, y: 0))
        pendulumBodyPath.addCurve(to: CGPoint(x: 0, y: 16), controlPoint1: CGPoint(x: 7.16, y: 0), controlPoint2: CGPoint(x: 0, y: 7.16))
        pendulumBodyPath.addCurve(to: CGPoint(x: 16, y: 32), controlPoint1: CGPoint(x: 0, y: 24.84), controlPoint2: CGPoint(x: 7.16, y: 32))
        pendulumBodyPath.addCurve(to: CGPoint(x: 29.84, y: 24), controlPoint1: CGPoint(x: 21.92, y: 32), controlPoint2: CGPoint(x: 27.07, y: 28.78))
        pendulumBodyPath.addLine(to: CGPoint(x: 134.16, y: 24))
        pendulumBodyPath.addCurve(to: CGPoint(x: 148, y: 32), controlPoint1: CGPoint(x: 136.93, y: 28.78), controlPoint2: CGPoint(x: 142.08, y: 32))
        pendulumBodyPath.addCurve(to: CGPoint(x: 164, y: 16), controlPoint1: CGPoint(x: 156.84, y: 32), controlPoint2: CGPoint(x: 164, y: 24.84))
        pendulumBodyPath.addCurve(to: CGPoint(x: 148, y: 0), controlPoint1: CGPoint(x: 164, y: 7.16), controlPoint2: CGPoint(x: 156.84, y: 0))
        pendulumBodyPath.close()
        StyleKit.magnesium.setFill()
        pendulumBodyPath.fill()


        //// Cross Mark
        //// Oval 1 Drawing
        let oval1Rect = CGRect(x: 139, y: 7, width: 18, height: 18)
        let oval1Path = UIBezierPath()
        oval1Path.addArc(withCenter: CGPoint(x: oval1Rect.midX, y: oval1Rect.midY), radius: oval1Rect.width / 2, startAngle: -135 * CGFloat.pi/180, endAngle: -45 * CGFloat.pi/180, clockwise: true)
        oval1Path.addLine(to: CGPoint(x: oval1Rect.midX, y: oval1Rect.midY))
        oval1Path.close()

        UIColor.white.setFill()
        oval1Path.fill()


        //// Oval 2 Drawing
        let oval2Rect = CGRect(x: 139, y: 7, width: 18, height: 18)
        let oval2Path = UIBezierPath()
        oval2Path.addArc(withCenter: CGPoint(x: oval2Rect.midX, y: oval2Rect.midY), radius: oval2Rect.width / 2, startAngle: 45 * CGFloat.pi/180, endAngle: -225 * CGFloat.pi/180, clockwise: true)
        oval2Path.addLine(to: CGPoint(x: oval2Rect.midX, y: oval2Rect.midY))
        oval2Path.close()

        UIColor.white.setFill()
        oval2Path.fill()


        //// Oval 3 Drawing
        let oval3Rect = CGRect(x: 139, y: 7, width: 18, height: 18)
        let oval3Path = UIBezierPath()
        oval3Path.addArc(withCenter: CGPoint(x: oval3Rect.midX, y: oval3Rect.midY), radius: oval3Rect.width / 2, startAngle: -45 * CGFloat.pi/180, endAngle: 45 * CGFloat.pi/180, clockwise: true)
        oval3Path.addLine(to: CGPoint(x: oval3Rect.midX, y: oval3Rect.midY))
        oval3Path.close()

        UIColor.black.setFill()
        oval3Path.fill()


        //// Oval 4 Drawing
        let oval4Rect = CGRect(x: 139, y: 7, width: 18, height: 18)
        let oval4Path = UIBezierPath()
        oval4Path.addArc(withCenter: CGPoint(x: oval4Rect.midX, y: oval4Rect.midY), radius: oval4Rect.width / 2, startAngle: -225 * CGFloat.pi/180, endAngle: -135 * CGFloat.pi/180, clockwise: true)
        oval4Path.addLine(to: CGPoint(x: oval4Rect.midX, y: oval4Rect.midY))
        oval4Path.close()

        UIColor.black.setFill()
        oval4Path.fill()




        //// Washer Drawing
        let washerPath = UIBezierPath(ovalIn: CGRect(x: 9, y: 9, width: 14, height: 14))
        StyleKit.mercury.setStroke()
        washerPath.lineWidth = 1
        washerPath.stroke()
        
        context.restoreGState()

    }

    @objc dynamic public class func drawDoublePendulum(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 640, height: 640), resizing: ResizingBehavior = .aspectFit, phi: CGFloat = 0, psi: CGFloat = 0, upsilon: CGFloat = 0, spread: CGFloat = 20) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 640, height: 640), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 640, y: resizedFrame.height / 640)



        //// Variable Declarations
        let gamma: CGFloat = upsilon + phi - 90
        let alpha: CGFloat = upsilon + spread
        let beta: CGFloat = upsilon - spread

        //// Limit Circle
        //// Second Mass Drawing
        context.saveGState()
        context.translateBy(x: 56, y: 584)
        context.rotate(by: -90 * CGFloat.pi/180)

        let secondMassPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 528, height: 528))
        StyleKit.mercury.setStroke()
        secondMassPath.lineWidth = 1
        secondMassPath.stroke()

        context.restoreGState()


        //// First Mass Drawing
        context.saveGState()
        context.translateBy(x: 188, y: 452)
        context.rotate(by: -90 * CGFloat.pi/180)

        let firstMassPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 264, height: 264))
        StyleKit.mercury.setStroke()
        firstMassPath.lineWidth = 1
        firstMassPath.stroke()

        context.restoreGState()




        //// Suspension
        context.saveGState()
        context.translateBy(x: 180, y: 320)
        context.rotate(by: -90 * CGFloat.pi/180)



        //// Bezier 1 Drawing
        context.saveGState()
        context.translateBy(x: 0, y: 140)
        context.rotate(by: -alpha * CGFloat.pi/180)

        let bezier1Path = UIBezierPath()
        bezier1Path.move(to: CGPoint(x: 0, y: 0))
        bezier1Path.addLine(to: CGPoint(x: 280, y: 0))
        StyleKit.mercury.setStroke()
        bezier1Path.lineWidth = 5
        bezier1Path.lineCapStyle = .round
        bezier1Path.stroke()

        context.restoreGState()


        //// Bezier 2 Drawing
        context.saveGState()
        context.translateBy(x: 0, y: 140)
        context.rotate(by: -beta * CGFloat.pi/180)

        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 0, y: 0))
        bezier2Path.addLine(to: CGPoint(x: 280, y: 0))
        StyleKit.mercury.setStroke()
        bezier2Path.lineWidth = 5
        bezier2Path.lineCapStyle = .round
        bezier2Path.stroke()

        context.restoreGState()



        context.restoreGState()


        //// Origin Mark
        context.saveGState()
        context.translateBy(x: 320, y: 320)
        context.rotate(by: -90 * CGFloat.pi/180)



        //// Oval 1 Drawing
        let oval1Rect = CGRect(x: -9, y: -9, width: 18, height: 18)
        let oval1Path = UIBezierPath()
        oval1Path.addArc(withCenter: CGPoint(x: oval1Rect.midX, y: oval1Rect.midY), radius: oval1Rect.width / 2, startAngle: -135 * CGFloat.pi/180, endAngle: -45 * CGFloat.pi/180, clockwise: true)
        oval1Path.addLine(to: CGPoint(x: oval1Rect.midX, y: oval1Rect.midY))
        oval1Path.close()

        UIColor.white.setFill()
        oval1Path.fill()


        //// Oval 2 Drawing
        let oval2Rect = CGRect(x: -9, y: -9, width: 18, height: 18)
        let oval2Path = UIBezierPath()
        oval2Path.addArc(withCenter: CGPoint(x: oval2Rect.midX, y: oval2Rect.midY), radius: oval2Rect.width / 2, startAngle: 45 * CGFloat.pi/180, endAngle: -225 * CGFloat.pi/180, clockwise: true)
        oval2Path.addLine(to: CGPoint(x: oval2Rect.midX, y: oval2Rect.midY))
        oval2Path.close()

        UIColor.white.setFill()
        oval2Path.fill()


        //// Oval 3 Drawing
        let oval3Rect = CGRect(x: -9, y: -9, width: 18, height: 18)
        let oval3Path = UIBezierPath()
        oval3Path.addArc(withCenter: CGPoint(x: oval3Rect.midX, y: oval3Rect.midY), radius: oval3Rect.width / 2, startAngle: -45 * CGFloat.pi/180, endAngle: 45 * CGFloat.pi/180, clockwise: true)
        oval3Path.addLine(to: CGPoint(x: oval3Rect.midX, y: oval3Rect.midY))
        oval3Path.close()

        UIColor.black.setFill()
        oval3Path.fill()


        //// Oval 4 Drawing
        let oval4Rect = CGRect(x: -9, y: -9, width: 18, height: 18)
        let oval4Path = UIBezierPath()
        oval4Path.addArc(withCenter: CGPoint(x: oval4Rect.midX, y: oval4Rect.midY), radius: oval4Rect.width / 2, startAngle: -225 * CGFloat.pi/180, endAngle: -135 * CGFloat.pi/180, clockwise: true)
        oval4Path.addLine(to: CGPoint(x: oval4Rect.midX, y: oval4Rect.midY))
        oval4Path.close()

        UIColor.black.setFill()
        oval4Path.fill()



        context.restoreGState()


        //// Pendulum
        context.saveGState()
        context.translateBy(x: 320, y: 320)
        context.rotate(by: -gamma * CGFloat.pi/180)



        //// Arm 1 Drawing
        context.saveGState()

        let arm1Rect = CGRect(x: -16, y: -16, width: 164, height: 32)
        context.saveGState()
        context.clip(to: arm1Rect)
        context.translateBy(x: arm1Rect.minX, y: arm1Rect.minY)

        StyleKit.drawPendulumArm(frame: CGRect(origin: .zero, size: arm1Rect.size), resizing: .stretch)
        context.restoreGState()

        context.restoreGState()


        //// Arm 2 Drawing
        context.saveGState()
        context.translateBy(x: 132, y: 0)
        context.rotate(by: -psi * CGFloat.pi/180)

        let arm2Rect = CGRect(x: -16, y: -16, width: 164, height: 32)
        context.saveGState()
        context.clip(to: arm2Rect)
        context.translateBy(x: arm2Rect.minX, y: arm2Rect.minY)

        StyleKit.drawPendulumArm(frame: CGRect(origin: .zero, size: arm2Rect.size), resizing: .stretch)
        context.restoreGState()

        context.restoreGState()



        context.restoreGState()
        
        context.restoreGState()

    }




    @objc(StyleKitResizingBehavior)
    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.

        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
                case .aspectFit:
                    scales.width = min(scales.width, scales.height)
                    scales.height = scales.width
                case .aspectFill:
                    scales.width = max(scales.width, scales.height)
                    scales.height = scales.width
                case .stretch:
                    break
                case .center:
                    scales.width = 1
                    scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}
