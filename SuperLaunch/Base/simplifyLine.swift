import Foundation
import CoreGraphics

func getPerpendicularDistance(_ point: CGPoint, lineStart: CGPoint, lineEnd: CGPoint) -> CGFloat {
    let numerator = abs((lineEnd.y - lineStart.y) * point.x - (lineEnd.x - lineStart.x) * point.y + lineEnd.x * lineStart.y - lineEnd.y * lineStart.x)
    let denominator = sqrt(pow(lineEnd.y - lineStart.y, 2) + pow(lineEnd.x - lineStart.x, 2))
    return numerator / denominator
}

func ramerDouglasPeucker(_ points: [CGPoint], epsilon: CGFloat) -> [CGPoint] {
    if points.count < 3 {
        return points
    }
    
    var maxDistance: CGFloat = 0
    var index = 0
    
    for i in 1..<points.count - 1 {
        let distance = getPerpendicularDistance(points[i], lineStart: points.first!, lineEnd: points.last!)
        if distance > maxDistance {
            maxDistance = distance
            index = i
        }
    }
    
    if maxDistance > epsilon {
        let left = ramerDouglasPeucker(Array(points[0...index]), epsilon: epsilon)
        let right = ramerDouglasPeucker(Array(points[index..<points.count]), epsilon: epsilon)
        return left + right.dropFirst()
    } else {
        return [points.first!, points.last!]
    }
}
