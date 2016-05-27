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
    public let origin: Vector
    public let edge1: Vector
    public let edge2: Vector
    
    public init(_ origin: Vector, _ edge1: Vector, _ edge2: Vector) {
        self.origin = origin
        self.edge1 = edge1
        self.edge2 = edge2
    }
    
    public func map(vector: Vector) -> Vector {
        let scale1 = edge1.scale(vector.x)
        let scale2 = edge2.scale(vector.y)
        
        return origin
            .add(scale1)
            .add(scale2)
    }
}

public struct Segment {
    public let start: Vector
    public let end: Vector
    
    public init(_ start: Vector, _ end: Vector) {
        self.start = start
        self.end = end
    }
}

public typealias Painter = (frame: Frame) -> ()

public typealias PainterCombiner = (Painter, Painter) -> Painter
