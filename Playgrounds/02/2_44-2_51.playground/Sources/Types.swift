public struct Vector {
    public let x: Double
    public let y: Double
    
    public init(_ x: Double, _ y: Double) {
        self.x = x
        self.y = y
    }
    
    public func add(vector: Vector) -> Vector {
        return Vector(x + vector.x, y + vector.y)
    }
    
    public func subtract(vector: Vector) -> Vector {
        return Vector(x - vector.x, y - vector.y)
    }
    
    public func scale(scale: Double) -> Vector {
        return Vector(x * scale, y * scale)
    }
}

public struct Frame {
    // "...the offset of the frame’s origin from some absolute origin in the plane"
    public let origin: Vector
    // "...the offsets of the frame’s corners from its origin"
    public let edge1: Vector
    public let edge2: Vector
    
    public init(_ origin: Vector, _ edge1: Vector, _ edge2: Vector) {
        self.origin = origin
        self.edge1 = edge1
        self.edge2 = edge2
    }
    
    // Maps a vector whose coordinates are in the unit square to the coordinate system of the frame. For example, (0, 0) is mapped to the origin of the frame, (1, 1) to the vertex diagonally opposite the origin, and (0.5, 0.5) to the center of the frame.
    public func map(vector: Vector) -> Vector {
        let scale1 = edge1.scale(vector.x)
        let scale2 = edge2.scale(vector.y)
        
        return origin
            .add(scale1)
            .add(scale2)
    }
}

public struct Segment {
    // "...the vector running from the origin to the start-point of the segment"
    public let start: Vector
    // "...the vector running from the origin to the end-point of the segment"
    public let end: Vector
    
    public init(_ start: Vector, _ end: Vector) {
        self.start = start
        self.end = end
    }
}

public typealias Painter = (frame: Frame) -> ()

public typealias PainterCombiner = (Painter, Painter) -> Painter
