import Foundation

public func transformPainter(painter: Painter, origin: Vector, corner1: Vector, corner2: Vector) -> Painter {
    return { frame in
        let newOrigin = frame.map(origin)
        let edge1 = frame.map(corner1).subtract(newOrigin)
        let edge2 = frame.map(corner2).subtract(newOrigin)
        let newFrame = Frame(newOrigin, edge1, edge2)
        painter(frame: newFrame)
    }
}

public func addPainters(painter1: Painter, _ painter2: Painter) -> Painter {
    return { frame in
        painter1(frame: frame)
        painter2(frame: frame)
    }
}

public func beside(left left: Painter, right: Painter) -> Painter {
    let newLeft = transformPainter(
        left,
        origin: Vector(0, 0),
        corner1: Vector(0.5, 0),
        corner2: Vector(0, 1))
    
    let newRight = transformPainter(
        right,
        origin: Vector(0.5, 0),
        corner1: Vector(1, 0),
        corner2: Vector(0.5, 1))
    
    return addPainters(newLeft, newRight)
}

public func below(top top: Painter, bottom: Painter) -> Painter {
    let newTop = transformPainter(
        top,
        origin: Vector(0, 0.5),
        corner1: Vector(1, 0.5),
        corner2: Vector(0, 1))
    
    let newBottom = transformPainter(
        bottom,
        origin: Vector(0, 0),
        corner1: Vector(1, 0),
        corner2: Vector(0, 0.5))
    
    return addPainters(newTop, newBottom)
}

public func flipVert(painter: Painter) -> Painter {
    return transformPainter(
        painter,
        origin: Vector(0, 1),
        corner1: Vector(1, 1),
        corner2: Vector(0, 0))
}

public func rightSplit(painter: Painter, n: Int) -> Painter {
    if n == 0 {
        return painter
    }
    else {
        let small = rightSplit(painter, n: n - 1)
        return beside(
            left: painter,
            right: below(
                top: small,
                bottom: small))
    }
}

public func cornerSplit(painter: Painter, n: Int) -> Painter {
    if n == 0 {
        return painter
    }
    else {
        let upSplitPainter = upSplit(painter, n: n - 1)
        let left = below(
            top: (beside(
                left: upSplitPainter,
                right: upSplitPainter)),
            bottom: painter)
        
        let rightSplitPainter = rightSplit(painter, n: n - 1)
        let right = below(
            top: cornerSplit(painter, n: n - 1),
            bottom: below(
                top: rightSplitPainter,
                bottom: rightSplitPainter))
        
        return beside(left: left, right: right)
    }
}

public func squareLimit(painter: Painter, n: Int) -> Painter {
    let cornerSplitPainter = cornerSplit(painter, n: n)
    let half = beside(
        left: flipHoriz(cornerSplitPainter),
        right: cornerSplitPainter)
    
    return below(
        top: half,
        bottom: flipVert(half))
}

public func squareOfFour(topLeft topLeft: Painter, topRight: Painter, bottomLeft: Painter, bottomRight: Painter) -> Painter {
    return below(
        top: beside(
            left: topLeft,
            right: topRight),
        bottom: beside(
            left: bottomLeft,
            right: bottomRight))
}

public func squareLimit2(painter: Painter, n: Int) -> Painter {
    let cornerSplitPainter = cornerSplit(painter, n: n)
    
    return squareOfFour(
        topLeft: flipHoriz(cornerSplitPainter),
        topRight: cornerSplitPainter,
        bottomLeft: flipHoriz(flipVert(cornerSplitPainter)),
        bottomRight: flipVert(cornerSplitPainter))
}

public func flipHoriz(painter: Painter) -> Painter {
    return transformPainter(
        painter,
        origin: Vector(1, 0),
        corner1: Vector(0, 0),
        corner2: Vector(1, 1))
}

public func upSplit(painter: Painter, n: Int) -> Painter {
    if n == 0 {
        return painter
    }
    else {
        let small = upSplit(painter, n: n - 1)
        return below(
            top: beside(
                left: small,
                right: small),
            bottom: painter)
    }
}
