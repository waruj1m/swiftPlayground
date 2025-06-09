#!/usr/bin/env swift

// MARK: - Functions and Closures Playground
// Exploring Swift functions, closures, and functional programming concepts

import Foundation

print("=== Functions and Closures Playground ===\n")

// MARK: - Basic Functions
print("1. Basic Functions")

// Simple function with parameters and return type
func greet(name: String) -> String {
    return "Hello, \(name)!"
}

print(greet(name: "Swift"))

// Function with multiple parameters and argument labels
func calculateDistance(from startPoint: (x: Double, y: Double), 
                      to endPoint: (x: Double, y: Double)) -> Double {
    let dx = endPoint.x - startPoint.x
    let dy = endPoint.y - startPoint.y
    return sqrt(dx * dx + dy * dy)
}

let distance = calculateDistance(from: (x: 0, y: 0), to: (x: 3, y: 4))
print("Distance: \(distance)")

// Function with default parameter values
func createMessage(for person: String, 
                  greeting: String = "Hello", 
                  punctuation: String = "!") -> String {
    return "\(greeting), \(person)\(punctuation)"
}

print(createMessage(for: "Alice"))
print(createMessage(for: "Bob", greeting: "Hi"))
print(createMessage(for: "Charlie", greeting: "Hey", punctuation: "."))

// Function with variadic parameters
func average(of numbers: Double...) -> Double {
    guard !numbers.isEmpty else { return 0 }
    return numbers.reduce(0, +) / Double(numbers.count)
}

print("Average: \(average(of: 1.5, 2.5, 3.0, 4.5))\n")

// MARK: - Functions as First-Class Citizens
print("2. Functions as First-Class Citizens")

// Function type aliases
typealias MathOperation = (Double, Double) -> Double

let add: MathOperation = { a, b in a + b }
let multiply: MathOperation = { a, b in a * b }

// Function that takes another function as parameter
func performOperation(_ operation: MathOperation, 
                     on a: Double, 
                     and b: Double) -> Double {
    return operation(a, b)
}

print("5 + 3 = \(performOperation(add, on: 5, and: 3))")
print("5 * 3 = \(performOperation(multiply, on: 5, and: 3))")

// Function that returns a function
func makeIncrementer(incrementAmount: Int) -> (Int) -> Int {
    return { value in
        return value + incrementAmount
    }
}

let incrementByFive = makeIncrementer(incrementAmount: 5)
print("10 incremented by 5: \(incrementByFive(10))\n")

// MARK: - Closures
print("3. Closures")

let names = ["Alice", "Bob", "Charlie", "David", "Eve"]

// Closure with explicit types
let sortedNames = names.sorted { (name1: String, name2: String) -> Bool in
    return name1 < name2
}
print("Sorted names (explicit): \(sortedNames)")

// Simplified closure syntax
let reverseSortedNames = names.sorted { $0 > $1 }
print("Reverse sorted names: \(reverseSortedNames)")

// Trailing closure syntax
let uppercasedNames = names.map { $0.uppercased() }
print("Uppercase names: \(uppercasedNames)")

// Capturing values
func makeCounter() -> () -> Int {
    var count = 0
    return {
        count += 1
        return count
    }
}

let counter = makeCounter()
print("Counter: \(counter()), \(counter()), \(counter())\n")

// MARK: - Higher-Order Functions
print("4. Higher-Order Functions")

let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

// Map - transform elements
let squared = numbers.map { $0 * $0 }
print("Original: \(numbers)")
print("Squared: \(squared)")

// Filter - select elements
let evenNumbers = numbers.filter { $0 % 2 == 0 }
print("Even numbers: \(evenNumbers)")

// Reduce - combine elements
let sum = numbers.reduce(0) { result, number in result + number }
let product = numbers.reduce(1, *)
print("Sum: \(sum)")
print("Product: \(product)")

// Chaining operations
let result = numbers
    .filter { $0 % 2 == 0 }
    .map { $0 * $0 }
    .reduce(0, +)
print("Sum of squares of even numbers: \(result)")

// CompactMap - map and remove nils
let stringNumbers = ["1", "2", "three", "4", "five"]
let validNumbers = stringNumbers.compactMap { Int($0) }
print("Valid numbers from strings: \(validNumbers)")

// Partition (custom implementation)
extension Array {
    func partition(by predicate: (Element) -> Bool) -> (matching: [Element], nonMatching: [Element]) {
        var matching: [Element] = []
        var nonMatching: [Element] = []
        
        for element in self {
            if predicate(element) {
                matching.append(element)
            } else {
                nonMatching.append(element)
            }
        }
        
        return (matching: matching, nonMatching: nonMatching)
    }
}

let (evens, odds) = numbers.partition { $0 % 2 == 0 }
print("Partitioned - Evens: \(evens), Odds: \(odds)\n")

// MARK: - Advanced Function Concepts
print("5. Advanced Function Concepts")

// Autoclosure
func logIfTrue(_ condition: @autoclosure () -> Bool, message: String) {
    if condition() {
        print("Log: \(message)")
    }
}

let debugMode = true
logIfTrue(debugMode && 2 + 2 == 4, message: "Math still works!")

// Escaping closures
func performAsyncOperation(completion: @escaping (String) -> Void) {
    DispatchQueue.global().async {
        // Simulate async work
        Thread.sleep(forTimeInterval: 0.1)
        DispatchQueue.main.async {
            completion("Operation completed!")
        }
    }
}

print("Starting async operation...")
performAsyncOperation { result in
    print("Async result: \(result)")
}

// Give time for async operation to complete
Thread.sleep(forTimeInterval: 0.2)

print("\n=== Functions and Closures Complete ===") 