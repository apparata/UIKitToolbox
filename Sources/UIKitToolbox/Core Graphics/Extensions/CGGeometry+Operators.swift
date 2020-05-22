//
//  Copyright © 2016 Apparata AB. All rights reserved.
//

import Foundation
import CoreGraphics

// MARK: - Addition

public func +(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x + scalar, y: point.y + scalar)
}

public func +(point: CGPoint, scalar: Double) -> CGPoint {
    return CGPoint(x: point.x + CGFloat(scalar), y: point.y + CGFloat(scalar))
}

public func +(p1: CGPoint, p2: CGPoint) -> CGPoint {
    return CGPoint(x: p1.x + p2.x, y: p1.y + p2.y)
}

public func +(point: CGPoint, size: CGSize) -> CGPoint {
    return CGPoint(x: point.x + size.width, y: point.y + size.height)
}

public func +(point: CGPoint, vector: CGVector) -> CGPoint {
    return CGPoint(x: point.x + vector.dx, y: point.y + vector.dy)
}

public func +(size: CGSize, scalar: CGFloat) -> CGSize {
    return CGSize(width: size.width + scalar, height: size.height + scalar)
}

public func +(size: CGSize, scalar: Double) -> CGSize {
    return CGSize(width: size.width + CGFloat(scalar), height: size.height + CGFloat(scalar))
}

public func +(s1: CGSize, s2: CGSize) -> CGSize {
    return CGSize(width: s1.width + s2.width, height: s1.height + s2.height)
}

public func +(size: CGSize, vector: CGVector) -> CGSize {
    return CGSize(width: size.width + vector.dx, height: size.height + vector.dy)
}

public func +(rect: CGRect, point: CGPoint) -> CGRect {
    return CGRect(x: rect.origin.x + point.x, y: rect.origin.y + point.y, width: rect.size.width, height: rect.size.height)
}

public func +(rect: CGRect, size: CGSize) -> CGRect {
    return CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width + size.width, height: rect.size.height + size.height)
}

// MARK: - Incrementing assignment

public func +=(point: inout CGPoint, scalar: CGFloat) {
    point.x += scalar
    point.y += scalar
}

public func +=(point: inout CGPoint, scalar: Double) {
    point.x += CGFloat(scalar)
    point.y += CGFloat(scalar)
}

public func +=(p1: inout CGPoint, p2: CGPoint) {
    p1.x += p2.x
    p1.y += p2.y
}

public func +=(point: inout CGPoint, size: CGSize) {
    point.x += size.width
    point.y += size.height
}

public func +=(point: inout CGPoint, vector: CGVector) {
    point.x += vector.dx
    point.y += vector.dy
}

public func +=(size: inout CGSize, scalar: CGFloat) {
    size.width += scalar
    size.height += scalar
}

public func +=(size: inout CGSize, scalar: Double) {
    size.width += CGFloat(scalar)
    size.height += CGFloat(scalar)
}

public func +=(s1: inout CGSize, s2: CGSize) {
    s1.width += s2.width
    s1.height += s2.height
}

public func +=(size: inout CGSize, vector: CGVector) {
    size.width += vector.dx
    size.height += vector.dy
}

public func +=(rect: inout CGRect, point: CGPoint) {
    rect.origin = CGPoint(x: rect.origin.x + point.x, y: rect.origin.y + point.y)
}

public func +=(rect: inout CGRect, size: CGSize) {
    rect.size = CGSize(width: rect.size.width + size.width, height: rect.size.height + size.height)
}

// MARK: - Subtraction

public func -(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x - scalar, y: point.y - scalar)
}

public func -(point: CGPoint, scalar: Double) -> CGPoint {
    return CGPoint(x: point.x - CGFloat(scalar), y: point.y - CGFloat(scalar))
}

public func -(p1: CGPoint, p2: CGPoint) -> CGPoint {
    return CGPoint(x: p1.x - p2.x, y: p1.y - p2.y)
}

public func -(point: CGPoint, size: CGSize) -> CGPoint {
    return CGPoint(x: point.x - size.width, y: point.y - size.height)
}

public func -(point: CGPoint, vector: CGVector) -> CGPoint {
    return CGPoint(x: point.x - vector.dx, y: point.y - vector.dy)
}

public func -(size: CGSize, scalar: CGFloat) -> CGSize {
    return CGSize(width: size.width - scalar, height: size.height - scalar)
}

public func -(size: CGSize, scalar: Double) -> CGSize {
    return CGSize(width: size.width - CGFloat(scalar), height: size.height - CGFloat(scalar))
}

public func -(s1: CGSize, s2: CGSize) -> CGSize {
    return CGSize(width: s1.width - s2.width, height: s1.height - s2.height)
}

public func -(size: CGSize, vector: CGVector) -> CGSize {
    return CGSize(width: size.width - vector.dx, height: size.height - vector.dy)
}

public func -(rect: CGRect, point: CGPoint) -> CGRect {
    return CGRect(x: rect.origin.x - point.x, y: rect.origin.y - point.y, width: rect.size.width, height: rect.size.height)
}

public func -(rect: CGRect, size: CGSize) -> CGRect {
    return CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width - size.width, height: rect.size.height - size.height)
}

// MARK: - Decrementing assignment

public func -=(point: inout CGPoint, scalar: CGFloat) {
    point.x -= scalar
    point.y -= scalar
}

public func -=(point: inout CGPoint, scalar: Double) {
    point.x -= CGFloat(scalar)
    point.y -= CGFloat(scalar)
}

public func -=(p1: inout CGPoint, p2: CGPoint) {
    p1.x -= p2.x
    p1.y -= p2.y
}

public func -=(point: inout CGPoint, size: CGSize) {
    point.x -= size.width
    point.y -= size.height
}

public func -=(point: inout CGPoint, vector: CGVector) {
    point.x -= vector.dx
    point.y -= vector.dy
}

public func -=(size: inout CGSize, scalar: CGFloat) {
    size.width -= scalar
    size.height -= scalar
}

public func -=(size: inout CGSize, scalar: Double) {
    size.width -= CGFloat(scalar)
    size.height -= CGFloat(scalar)
}

public func -=(s1: inout CGSize, s2: CGSize) {
    s1.width -= s2.width
    s1.height -= s2.height
}

public func -=(size: inout CGSize, vector: CGVector) {
    size.width -= vector.dx
    size.height -= vector.dy
}

public func -=(rect: inout CGRect, point: CGPoint) {
    rect.origin = CGPoint(x: rect.origin.x - point.x, y: rect.origin.y - point.y)
}

public func -=(rect: inout CGRect, size: CGSize) {
    rect.size = CGSize(width: rect.size.width - size.width, height: rect.size.height - size.height)
}

// MARK: - Multiplication with scalar

public func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

public func *(size: CGSize, scalar: CGFloat) -> CGSize {
    return CGSize(width: size.width * scalar, height: size.height * scalar)
}

public func *(vector: CGVector, scalar: CGFloat) -> CGVector {
    return CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
}

public func *(rect: CGRect, scalar: CGFloat) -> CGRect {
    return CGRect(x: rect.origin.x * scalar, y: rect.origin.y * scalar, width: rect.size.width * scalar, height: rect.size.height * scalar)
}

public func *(point: CGPoint, scalar: Double) -> CGPoint {
    return CGPoint(x: point.x * CGFloat(scalar), y: point.y * CGFloat(scalar))
}

public func *(size: CGSize, scalar: Double) -> CGSize {
    return CGSize(width: size.width * CGFloat(scalar), height: size.height * CGFloat(scalar))
}

public func *(vector: CGVector, scalar: Double) -> CGVector {
    return CGVector(dx: vector.dx * CGFloat(scalar), dy: vector.dy * CGFloat(scalar))
}

public func *(rect: CGRect, scalar: Double) -> CGRect {
    let scalar = CGFloat(scalar)
    return CGRect(x: rect.origin.x * scalar, y: rect.origin.y * scalar, width: rect.size.width * scalar, height: rect.size.height * scalar)
}

// MARK: - Multiplication with scalar assignment

public func *=(point: inout CGPoint, scalar: CGFloat) {
    point.x *= scalar
    point.y *= scalar
}

public func *=(size: inout CGSize, scalar: CGFloat) {
    size.width *= scalar
    size.height *= scalar
}

public func *=(vector: inout CGVector, scalar: CGFloat) {
    vector.dx *= scalar
    vector.dy *= scalar
}

public func *=(point: inout CGPoint, scalar: Double) {
    point.x *= CGFloat(scalar)
    point.y *= CGFloat(scalar)
}

public func *=(size: inout CGSize, scalar: Double) {
    size.width *= CGFloat(scalar)
    size.height *= CGFloat(scalar)
}

public func *=(vector: inout CGVector, scalar: Double) {
    vector.dx *= CGFloat(scalar)
    vector.dy *= CGFloat(scalar)
}

// MARK: - Division with scalar

public func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

public func /(size: CGSize, scalar: CGFloat) -> CGSize {
    return CGSize(width: size.width / scalar, height: size.height / scalar)
}

public func /(vector: CGVector, scalar: CGFloat) -> CGVector {
    return CGVector(dx: vector.dx / scalar, dy: vector.dy / scalar)
}

public func /(point: CGPoint, scalar: Double) -> CGPoint {
    return CGPoint(x: point.x / CGFloat(scalar), y: point.y / CGFloat(scalar))
}

public func /(size: CGSize, scalar: Double) -> CGSize {
    return CGSize(width: size.width / CGFloat(scalar), height: size.height / CGFloat(scalar))
}

public func /(vector: CGVector, scalar: Double) -> CGVector {
    return CGVector(dx: vector.dx / CGFloat(scalar), dy: vector.dy / CGFloat(scalar))
}

// MARK: - Division with scalar assignment

public func /=(point: inout CGPoint, scalar: CGFloat) {
    point.x /= scalar
    point.y /= scalar
}

public func /=(size: inout CGSize, scalar: CGFloat) {
    size.width /= scalar
    size.height /= scalar
}

public func /=(vector: inout CGVector, scalar: CGFloat) {
    vector.dx /= scalar
    vector.dy /= scalar
}

public func /=(point: inout CGPoint, scalar: Double) {
    point.x /= CGFloat(scalar)
    point.y /= CGFloat(scalar)
}

public func /=(size: inout CGSize, scalar: Double) {
    size.width /= CGFloat(scalar)
    size.height /= CGFloat(scalar)
}

public func /=(vector: inout CGVector, scalar: Double) {
    vector.dx /= CGFloat(scalar)
    vector.dy /= CGFloat(scalar)
}

// MARK: Multiplication with vector


public func *(point: CGPoint, vector: CGVector) -> CGPoint {
    return CGPoint(x: point.x * vector.dx, y: point.y * vector.dy)
}

public func *(size: CGSize, vector: CGVector) -> CGSize {
    return CGSize(width: size.width * vector.dx, height: size.height * vector.dy)
}

public func *(v1: CGVector, v2: CGVector) -> CGVector {
    return CGVector(dx: v1.dx * v2.dx, dy: v1.dy * v2.dy)
}

// MARK: - Multiplication with vector assignment

public func *=(point: inout CGPoint, vector: CGVector) {
    point.x *= vector.dx
    point.y *= vector.dy
}

public func *=(size: inout CGSize, vector: CGVector) {
    size.width *= vector.dx
    size.height *= vector.dy
}

public func *=(v1: inout CGVector, v2: CGVector) {
    v1.dx *= v2.dx
    v1.dy *= v2.dy
}

// MARK: Division with vector


public func /(point: CGPoint, vector: CGVector) -> CGPoint {
    return CGPoint(x: point.x / vector.dx, y: point.y / vector.dy)
}

public func /(size: CGSize, vector: CGVector) -> CGSize {
    return CGSize(width: size.width / vector.dx, height: size.height / vector.dy)
}

public func /(v1: CGVector, v2: CGVector) -> CGVector {
    return CGVector(dx: v1.dx / v2.dx, dy: v1.dy / v2.dy)
}

// MARK: - Division with vector assignment

public func /=(point: inout CGPoint, vector: CGVector) {
    point.x /= vector.dx
    point.y /= vector.dy
}

public func /=(size: inout CGSize, vector: CGVector) {
    size.width /= vector.dx
    size.height /= vector.dy
}

public func /=(v1: inout CGVector, v2: CGVector) {
    v1.dx /= v2.dx
    v1.dy /= v2.dy
}

