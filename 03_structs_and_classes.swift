#!/usr/bin/env swift

// MARK: - Structs and Classes Playground
// Exploring Swift's object-oriented programming features

import Foundation

print("=== Structs and Classes Playground ===\n")

// MARK: - Structs
print("1. Structs - Value Types")

struct Point {
    var x: Double
    var y: Double
    
    // Computed property
    var magnitude: Double {
        return sqrt(x * x + y * y)
    }
    
    // Method
    func distance(to other: Point) -> Double {
        let dx = other.x - x
        let dy = other.y - y
        return sqrt(dx * dx + dy * dy)
    }
    
    // Mutating method
    mutating func moveBy(dx: Double, dy: Double) {
        x += dx
        y += dy
    }
    
    // Static method
    static func origin() -> Point {
        return Point(x: 0, y: 0)
    }
}

var point1 = Point(x: 3, y: 4)
let point2 = Point(x: 0, y: 0)

print("Point1: (\(point1.x), \(point1.y))")
print("Point1 magnitude: \(point1.magnitude)")
print("Distance from point1 to point2: \(point1.distance(to: point2))")

point1.moveBy(dx: 1, dy: 1)
print("Point1 after moving: (\(point1.x), \(point1.y))")

let origin = Point.origin()
print("Origin: (\(origin.x), \(origin.y))")

// Value semantics demonstration
var pointA = Point(x: 1, y: 2)
var pointB = pointA  // Copy
pointB.x = 10
print("PointA: (\(pointA.x), \(pointA.y)), PointB: (\(pointB.x), \(pointB.y))")
print("Value types create independent copies\n")

// MARK: - Classes
print("2. Classes - Reference Types")

class Vehicle {
    var brand: String
    var year: Int
    private var _mileage: Double = 0
    
    // Computed property with getter and setter
    var mileage: Double {
        get { return _mileage }
        set {
            if newValue >= 0 {
                _mileage = newValue
            }
        }
    }
    
    // Designated initializer
    init(brand: String, year: Int) {
        self.brand = brand
        self.year = year
    }
    
    // Convenience initializer
    convenience init(brand: String) {
        self.init(brand: brand, year: 2023)
    }
    
    func startEngine() {
        print("\(brand) engine started!")
    }
    
    func describe() -> String {
        return "\(year) \(brand) with \(_mileage) miles"
    }
    
    // Class method
    class func vehicleInfo() -> String {
        return "This is a vehicle class"
    }
    
    deinit {
        print("\(brand) vehicle is being deallocated")
    }
}

class Car: Vehicle {
    var numberOfDoors: Int
    
    init(brand: String, year: Int, doors: Int) {
        self.numberOfDoors = doors
        super.init(brand: brand, year: year)
    }
    
    // Override parent method
    override func describe() -> String {
        return super.describe() + " and \(numberOfDoors) doors"
    }
    
    // Method overloading
    func honk() {
        print("Beep beep!")
    }
    
    func honk(times: Int) {
        for _ in 1...times {
            print("Beep!", terminator: " ")
        }
        print()
    }
}

let vehicle1 = Vehicle(brand: "Generic", year: 2020)
vehicle1.mileage = 15000
print(vehicle1.describe())
vehicle1.startEngine()

let car1 = Car(brand: "Toyota", year: 2022, doors: 4)
car1.mileage = 5000
print(car1.describe())
car1.honk()
car1.honk(times: 3)

// Reference semantics demonstration
let carA = Car(brand: "Honda", year: 2021, doors: 4)
let carB = carA  // Reference
carB.mileage = 20000
print("CarA mileage: \(carA.mileage), CarB mileage: \(carB.mileage)")
print("Reference types share the same instance\n")

// MARK: - Protocols
print("3. Protocols")

protocol Drawable {
    func draw()
    var area: Double { get }
}

protocol Colorable {
    var color: String { get set }
}

// Protocol composition
typealias DrawableAndColorable = Drawable & Colorable

struct Circle: DrawableAndColorable {
    var radius: Double
    var color: String
    
    var area: Double {
        return Double.pi * radius * radius
    }
    
    func draw() {
        print("Drawing a \(color) circle with radius \(radius)")
    }
}

struct Rectangle: DrawableAndColorable {
    var width: Double
    var height: Double
    var color: String
    
    var area: Double {
        return width * height
    }
    
    func draw() {
        print("Drawing a \(color) rectangle \(width)×\(height)")
    }
}

let shapes: [DrawableAndColorable] = [
    Circle(radius: 5, color: "red"),
    Rectangle(width: 10, height: 8, color: "blue")
]

for shape in shapes {
    shape.draw()
    print("Area: \(shape.area)")
}

// Protocol with default implementation
protocol Identifiable {
    var id: String { get }
    func displayID()
}

extension Identifiable {
    func displayID() {
        print("ID: \(id)")
    }
}

struct User: Identifiable {
    let id: String
    let name: String
}

let user = User(id: "USER123", name: "John Doe")
user.displayID()
print()

// MARK: - Extensions
print("4. Extensions")

extension String {
    func isPalindrome() -> Bool {
        let cleaned = self.lowercased().replacingOccurrences(of: " ", with: "")
        return cleaned == String(cleaned.reversed())
    }
    
    var wordCount: Int {
        return self.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .count
    }
}

let palindrome = "A man a plan a canal Panama"
print("'\(palindrome)' is palindrome: \(palindrome.isPalindrome())")
print("Word count: \(palindrome.wordCount)")

extension Int {
    func squared() -> Int {
        return self * self
    }
    
    var isEven: Bool {
        return self % 2 == 0
    }
}

let number = 7
print("\(number) squared: \(number.squared())")
print("\(number) is even: \(number.isEven)")
print()

// MARK: - Generics
print("5. Generics")

struct Stack<Element> {
    private var items: [Element] = []
    
    var isEmpty: Bool {
        return items.isEmpty
    }
    
    var count: Int {
        return items.count
    }
    
    mutating func push(_ item: Element) {
        items.append(item)
    }
    
    mutating func pop() -> Element? {
        return items.popLast()
    }
    
    func peek() -> Element? {
        return items.last
    }
}

var stringStack = Stack<String>()
stringStack.push("first")
stringStack.push("second")
stringStack.push("third")

print("String stack count: \(stringStack.count)")
print("Peek: \(stringStack.peek() ?? "empty")")
print("Pop: \(stringStack.pop() ?? "empty")")
print("Stack count after pop: \(stringStack.count)")

var intStack = Stack<Int>()
intStack.push(1)
intStack.push(2)
intStack.push(3)

print("Int stack: \(intStack.count) items")

// Generic function with constraints
func findMax<T: Comparable>(_ array: [T]) -> T? {
    guard !array.isEmpty else { return nil }
    
    var max = array[0]
    for item in array[1...] {
        if item > max {
            max = item
        }
    }
    return max
}

let numbers = [3, 1, 4, 1, 5, 9, 2, 6]
let words = ["apple", "banana", "cherry", "date"]

print("Max number: \(findMax(numbers) ?? 0)")
print("Max word: \(findMax(words) ?? "none")")

print("\n=== Structs and Classes Complete ===") 