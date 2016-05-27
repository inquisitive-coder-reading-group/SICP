public let trianglePainter = segmentsToPainter([
    Segment(Vector(0.25, 0), Vector(1, 0)),
    Segment(Vector(1, 0), Vector(0.5, 1)),
    Segment(Vector(0.5, 1), Vector(0.25, 0)) ])

PainterView(painter: trianglePainter)

//: ## Exercise 2.44
//: Define the procedure `up-split` used by `corner-split`. It is similar to `right-split`, except that it switches the roles of `below` and `beside`.
func upSplit1(painter: Painter, n: Int) -> Painter {
    if n == 0 {
        return painter
    }
    else {
        let small = upSplit1(painter, n: n - 1)
        return below(
            top: beside(
                left: small,
                right: small),
            bottom: painter)
    }
}

PainterView(painter: upSplit1(trianglePainter, n: 4))

//: ## Exercise 2.45
//: `Right-split` and `up-split` can be expressed as instances of a general splitting operation. Define a procedure `split` with the property that evaluating
//: ```
//: (define right-split (split beside below))
//: (define up-split (split below beside))`
//: ```
//: produces procedures `right-split` and `up-split` with the same behaviors as the ones already defined.
func split(painter: Painter, t1: PainterCombiner, t2: PainterCombiner, n: Int) -> Painter {
    if n == 0 {
        return painter
    }
    else {
        let small = split(painter, t1: t1, t2: t2, n: n - 1)
        return t1(
            painter,
            t2(
                small,
                small))
    }
}

func rightSplit2(painter: Painter, n: Int) -> Painter {
    return split(painter, t1: beside, t2: below, n: n)
}

PainterView(painter: rightSplit2(trianglePainter, n: 4))

func upSplit2(painter: Painter, n: Int) -> Painter {
    return split(painter, t1: below, t2: beside, n: n)
}

PainterView(painter: upSplit2(trianglePainter, n: 4))

//: ## Exercise 2.46
//: A two-dimensional vector `v` running from the origin to a point can be represented as a pair consisting of an `x`-coordinate and a `y`- -coordinate. Implement a data abstraction for vectors by giving a constructor make-vect and corresponding selectors `xcor-vect` and `ycor-vect`. In terms of your selectors and constructor, implement procedures `add-vect`, `sub-vect`, and `scale-vect` that perform the operations vector addition, vector subtraction, and multiplying a vector by a scalar.
// See Types.swift

//: ## Exercise 2.48
//: A directed line segment in the plane can be represented as a pair of vectors—the vector running from the origin to the start-point of the segment, and the vector running from the origin to the end-point of the segment. Use your vector representation from Exercise 2.46 to define a representation for segments with a constructor `make-segment` and selectors `start-segment` and `end-segment`.
// See Types.swift

//: ## Exercise 2.49
//: Use `segments->painter` to define the following primitive painters:
//:
//: The painter that draws the outline of the designated frame.
public let outlinePainter = segmentsToPainter([
    Segment(Vector(0, 0), Vector(0, 1)),
    Segment(Vector(0, 1), Vector(1, 1)),
    Segment(Vector(1, 1), Vector(1, 0)),
    Segment(Vector(1, 0), Vector(0, 0)) ])

PainterView(painter: outlinePainter)
//: The painter that draws an “X” by connecting opposite corners of the frame.
public let xPainter = segmentsToPainter([
    Segment(Vector(0, 0), Vector(1, 1)),
    Segment(Vector(0, 1), Vector(1, 0)) ])

PainterView(painter: xPainter)
//: The painter that draws a diamond shape by connecting the midpoints of the sides of the frame.
public let diamondPainter = segmentsToPainter([
    Segment(Vector(0, 0.5), Vector(0.5, 1)),
    Segment(Vector(0.5, 1), Vector(1, 0.5)),
    Segment(Vector(1, 0.5), Vector(0.5, 0)),
    Segment(Vector(0.5, 0), Vector(0, 0.5)) ])

PainterView(painter: diamondPainter)
//: ## Exercise 2.50
//: Define the transformation `flip-horiz`, which flips painters horizontally, and transformations that rotate painters counterclockwise by 180 degrees and 270 degrees.
func flipHoriz1(painter: Painter) -> Painter {
    return transformPainter(
        painter,
        origin: Vector(1, 0),
        corner1: Vector(0, 0),
        corner2: Vector(1, 1))
}

PainterView(painter: flipHoriz1(trianglePainter))

func rotate180(painter: Painter) -> Painter {
    return transformPainter(
        painter,
        origin: Vector(0, 1),
        corner1: Vector(1, 1),
        corner2: Vector(0, 0))
}

PainterView(painter: rotate180(trianglePainter))

func rotate270(painter: Painter) -> Painter {
    return transformPainter(
        painter,
        origin: Vector(0, 1),
        corner1: Vector(0, 0),
        corner2: Vector(1, 1))
}

PainterView(painter: rotate270(trianglePainter))

func rotate90(painter: Painter) -> Painter {
    return transformPainter(
        painter,
        origin: Vector(1, 0),
        corner1: Vector(1, 1),
        corner2: Vector(0, 0))
}

PainterView(painter: rotate90(trianglePainter))

//: ## Exercise 2.51
//: Define the `below` operation for painters. `Below` takes two painters as arguments. The resulting painter, given a frame, draws with the first painter in the bottom of the frame and with the second painter in the top. Define `below` in two different ways—first by writing a procedure that is analogous to the `beside` procedure given above, and again in terms of beside and suitable rotation operations (from Exercise 2.50).
func below1(top top: Painter, bottom: Painter) -> Painter {
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

PainterView(painter: below1(top: diamondPainter, bottom: trianglePainter))

func below2(top top: Painter, bottom: Painter) -> Painter {
    return rotate270(beside(left: rotate90(top), right: rotate90(bottom)))
}

PainterView(painter: below2(top: diamondPainter, bottom: trianglePainter))
