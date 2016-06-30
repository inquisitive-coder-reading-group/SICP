import UIKit

extension Frame {
    public init(rect: CGRect) {
        origin = Vector(Double(rect.origin.x), Double(rect.origin.y))
        edge1 = Vector(Double(rect.size.width), 0)
        edge2 = Vector(0, Double(rect.size.height))
    }
}

public class PainterView: UIView {
    let painter: Painter
    
    public init(painter: Painter) {
        self.painter = painter
        
        super.init(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func drawRect(rect: CGRect) {
        let flippedPainter = flipVert(painter)
        flippedPainter(frame: Frame(rect: bounds))
    }
}
