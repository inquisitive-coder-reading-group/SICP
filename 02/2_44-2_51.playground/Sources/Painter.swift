import UIKit

extension Vector {
    public var point: CGPoint {
        get {
            return CGPoint(x: x, y: y)
        }
    }
}

public func segmentsToPainter(segments: [Segment]) -> Painter {
    return { frame in
        let path = UIBezierPath()
        
        for segment in segments {
            path.moveToPoint(frame.map(segment.start).point)
            path.addLineToPoint(frame.map(segment.end).point)
        }
        
        path.lineWidth = 10
        
        UIColor.redColor().set()
        path.stroke()
    }
}
