#!/usr/bin/env swift

// MARK: - Advanced Swift Features Playground
// Exploring error handling, optionals, pattern matching, and advanced concepts

import Foundation

print("=== Advanced Swift Features Playground ===\n")

// MARK: - Optionals and Optional Chaining
print("1. Optionals and Optional Chaining")

struct Address {
    let street: String
    let city: String
    let postalCode: String?
}

struct Person {
    let name: String
    let address: Address?
    let phoneNumber: String?
}

let person1 = Person(
    name: "Alice",
    address: Address(street: "123 Main St", city: "Anytown", postalCode: "12345"),
    phoneNumber: "555-0123"
)

let person2 = Person(name: "Bob", address: nil, phoneNumber: nil)

// Optional chaining
let alicePostalCode = person1.address?.postalCode
let bobPostalCode = person2.address?.postalCode

print("Alice's postal code: \(alicePostalCode ?? "unknown")")
print("Bob's postal code: \(bobPostalCode ?? "unknown")")

// Nil coalescing operator
let defaultPhone = "No phone"
print("Alice's phone: \(person1.phoneNumber ?? defaultPhone)")
print("Bob's phone: \(person2.phoneNumber ?? defaultPhone)")

// Optional binding with if let
if let address = person1.address {
    print("Alice lives at \(address.street), \(address.city)")
    if let postalCode = address.postalCode {
        print("Postal code: \(postalCode)")
    }
}

// Guard statements
func processPersonInfo(_ person: Person) {
    guard let address = person.address else {
        print("\(person.name) has no address on file")
        return
    }
    
    guard let postalCode = address.postalCode else {
        print("\(person.name)'s address has no postal code")
        return
    }
    
    print("\(person.name) lives at \(address.street), \(address.city) \(postalCode)")
}

processPersonInfo(person1)
processPersonInfo(person2)
print()

// MARK: - Error Handling
print("2. Error Handling")

enum ValidationError: Error {
    case empty
    case tooShort(minimumLength: Int)
    case tooLong(maximumLength: Int)
    case invalidCharacters
    
    var localizedDescription: String {
        switch self {
        case .empty:
            return "Value cannot be empty"
        case .tooShort(let min):
            return "Value must be at least \(min) characters"
        case .tooLong(let max):
            return "Value cannot exceed \(max) characters"
        case .invalidCharacters:
            return "Value contains invalid characters"
        }
    }
}

// Throwing function
func validatePassword(_ password: String) throws -> Bool {
    guard !password.isEmpty else {
        throw ValidationError.empty
    }
    
    guard password.count >= 8 else {
        throw ValidationError.tooShort(minimumLength: 8)
    }
    
    guard password.count <= 64 else {
        throw ValidationError.tooLong(maximumLength: 64)
    }
    
    let validCharacters = CharacterSet.alphanumerics.union(.punctuationCharacters)
    let passwordCharacters = CharacterSet(charactersIn: password)
    
    guard passwordCharacters.isSubset(of: validCharacters) else {
        throw ValidationError.invalidCharacters
    }
    
    return true
}

// Error handling with do-catch
func testPassword(_ password: String) {
    do {
        if try validatePassword(password) {
            print("Password '\(password)' is valid")
        }
    } catch ValidationError.empty {
        print("Error: Password cannot be empty")
    } catch ValidationError.tooShort(let minLength) {
        print("Error: Password too short, needs at least \(minLength) characters")
    } catch ValidationError.tooLong(let maxLength) {
        print("Error: Password too long, maximum \(maxLength) characters")
    } catch ValidationError.invalidCharacters {
        print("Error: Password contains invalid characters")
    } catch {
        print("Unexpected error: \(error)")
    }
}

testPassword("")
testPassword("short")
testPassword("validPassword123!")

// try? and try!
let result1 = try? validatePassword("valid123!")
let result2 = try? validatePassword("bad")

print("Result1 (valid): \(result1 ?? false)")
print("Result2 (invalid): \(result2 ?? false)")
print()

// MARK: - Pattern Matching
print("3. Pattern Matching")

enum Weather {
    case sunny(temperature: Int)
    case cloudy
    case rainy(intensity: Double)
    case snowy(accumulation: Double)
}

func describeWeather(_ weather: Weather) -> String {
    switch weather {
    case .sunny(let temp) where temp > 30:
        return "Hot and sunny (\(temp)°C)"
    case .sunny(let temp) where temp > 20:
        return "Warm and sunny (\(temp)°C)"
    case .sunny(let temp):
        return "Cool and sunny (\(temp)°C)"
    case .cloudy:
        return "Cloudy skies"
    case .rainy(let intensity) where intensity > 5:
        return "Heavy rain (\(intensity)mm/h)"
    case .rainy(let intensity):
        return "Light rain (\(intensity)mm/h)"
    case .snowy(let accumulation):
        return "Snow accumulation: \(accumulation)cm"
    }
}

let weatherConditions: [Weather] = [
    .sunny(temperature: 25),
    .sunny(temperature: 35),
    .cloudy,
    .rainy(intensity: 2.5),
    .rainy(intensity: 7.2),
    .snowy(accumulation: 15.0)
]

for weather in weatherConditions {
    print(describeWeather(weather))
}

// Pattern matching with tuples
let coordinates = [(0, 0), (1, 0), (0, 1), (2, 3), (-1, -1)]

for point in coordinates {
    switch point {
    case (0, 0):
        print("Origin")
    case (_, 0):
        print("On x-axis: \(point)")
    case (0, _):
        print("On y-axis: \(point)")
    case (let x, let y) where x < 0 && y < 0:
        print("In third quadrant: \(point)")
    case (let x, let y) where x == y:
        print("On diagonal: \(point)")
    default:
        print("Regular point: \(point)")
    }
}
print()

// MARK: - Advanced Operators and Custom Operators
print("4. Custom Operators")

struct Vector2D {
    var x: Double
    var y: Double
    
    static func + (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func - (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x - right.x, y: left.y - right.y)
    }
    
    static func * (vector: Vector2D, scalar: Double) -> Vector2D {
        return Vector2D(x: vector.x * scalar, y: vector.y * scalar)
    }
    
    static func += (left: inout Vector2D, right: Vector2D) {
        left = left + right
    }
}

// Custom operator
infix operator ••: MultiplicationPrecedence

extension Vector2D {
    static func •• (left: Vector2D, right: Vector2D) -> Double {
        return left.x * right.x + left.y * right.y  // Dot product
    }
}

let vector1 = Vector2D(x: 3, y: 4)
let vector2 = Vector2D(x: 1, y: 2)

print("Vector1: (\(vector1.x), \(vector1.y))")
print("Vector2: (\(vector2.x), \(vector2.y))")

let sum = vector1 + vector2
print("Sum: (\(sum.x), \(sum.y))")

let scaled = vector1 * 2.0
print("Vector1 * 2: (\(scaled.x), \(scaled.y))")

let dotProduct = vector1 •• vector2
print("Dot product: \(dotProduct)")
print()

// MARK: - Memory Management and ARC
print("5. Memory Management")

class Node {
    let value: String
    var next: Node?
    weak var parent: Node?  // Weak reference to avoid retain cycles
    
    init(value: String) {
        self.value = value
        print("Node '\(value)' created")
    }
    
    deinit {
        print("Node '\(value)' deallocated")
    }
}

// Demonstrate ARC
do {
    let nodeA = Node(value: "A")
    let nodeB = Node(value: "B")
    let nodeC = Node(value: "C")
    
    nodeA.next = nodeB
    nodeB.next = nodeC
    nodeB.parent = nodeA
    nodeC.parent = nodeB
    
    print("Nodes created and linked")
} // Nodes go out of scope here

print("Exited scope - nodes should be deallocated")

// Closure capture lists
class Counter {
    var count = 0
    
    lazy var increment: () -> Int = { [unowned self] in
        self.count += 1
        return self.count
    }
    
    deinit {
        print("Counter deallocated")
    }
}

do {
    let counter = Counter()
    print("Count: \(counter.increment())")
    print("Count: \(counter.increment())")
    print("Count: \(counter.increment())")
}
print("Counter should be deallocated")
print()

// MARK: - Property Wrappers
print("6. Property Wrappers")

@propertyWrapper
struct Clamped<Value: Comparable> {
    private var value: Value
    private let range: ClosedRange<Value>
    
    init(wrappedValue: Value, _ range: ClosedRange<Value>) {
        self.range = range
        self.value = min(max(wrappedValue, range.lowerBound), range.upperBound)
    }
    
    var wrappedValue: Value {
        get { value }
        set { value = min(max(newValue, range.lowerBound), range.upperBound) }
    }
}

struct GameSettings {
    @Clamped(0...100) var volume: Int = 50
    @Clamped(1...10) var difficulty: Int = 5
    @Clamped(0.0...1.0) var brightness: Double = 0.8
}

var settings = GameSettings()
print("Initial settings - Volume: \(settings.volume), Difficulty: \(settings.difficulty), Brightness: \(settings.brightness)")

settings.volume = 150  // Will be clamped to 100
settings.difficulty = 0  // Will be clamped to 1
settings.brightness = 1.5  // Will be clamped to 1.0

print("After invalid values - Volume: \(settings.volume), Difficulty: \(settings.difficulty), Brightness: \(settings.brightness)")

print("\n=== Advanced Features Complete ===") 