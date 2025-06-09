#!/usr/bin/env swift

// MARK: - Testing and Debugging Playground
// Exploring testing patterns, debugging techniques, and quality assurance

import Foundation
import CoreFoundation

print("=== Testing and Debugging Playground ===\n")

// MARK: - Basic Testing Concepts
print("1. Basic Testing Patterns")

// Simple test framework
struct TestResult {
    let name: String
    let passed: Bool
    let message: String?
    let duration: TimeInterval
}

class SimpleTestRunner {
    private var results: [TestResult] = []
    
    func test(_ name: String, _ testBody: () throws -> Void) {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        do {
            try testBody()
            let duration = CFAbsoluteTimeGetCurrent() - startTime
            results.append(TestResult(name: name, passed: true, message: nil, duration: duration))
            print("✅ \(name)")
        } catch {
            let duration = CFAbsoluteTimeGetCurrent() - startTime
            results.append(TestResult(name: name, passed: false, message: error.localizedDescription, duration: duration))
            print("❌ \(name): \(error)")
        }
    }
    
    func assert(_ condition: Bool, _ message: String = "Assertion failed") throws {
        if !condition {
            throw TestError.assertionFailed(message)
        }
    }
    
    func assertEqual<T: Equatable>(_ actual: T, _ expected: T, _ message: String = "") throws {
        if actual != expected {
            let errorMessage = message.isEmpty ? "Expected \(expected), got \(actual)" : message
            throw TestError.assertionFailed(errorMessage)
        }
    }
    
    func printSummary() {
        let passed = results.filter { $0.passed }.count
        let failed = results.count - passed
        let totalTime = results.reduce(0) { $0 + $1.duration }
        
        print("\n📊 Test Summary:")
        print("Total: \(results.count), Passed: \(passed), Failed: \(failed)")
        print("Total time: \(String(format: "%.3f", totalTime))s")
        
        if failed > 0 {
            print("\n❌ Failed tests:")
            for result in results where !result.passed {
                print("  - \(result.name): \(result.message ?? "Unknown error")")
            }
        }
    }
}

enum TestError: Error {
    case assertionFailed(String)
}

// Example class to test
class Calculator {
    func add(_ a: Int, _ b: Int) -> Int {
        return a + b
    }
    
    func subtract(_ a: Int, _ b: Int) -> Int {
        return a - b
    }
    
    func multiply(_ a: Int, _ b: Int) -> Int {
        return a * b
    }
    
    func divide(_ a: Int, _ b: Int) throws -> Double {
        guard b != 0 else {
            throw CalculatorError.divisionByZero
        }
        return Double(a) / Double(b)
    }
    
    enum CalculatorError: Error {
        case divisionByZero
    }
}

// Running tests
let testRunner = SimpleTestRunner()
let calculator = Calculator()

testRunner.test("Addition works correctly") {
    try testRunner.assertEqual(calculator.add(2, 3), 5)
    try testRunner.assertEqual(calculator.add(-1, 1), 0)
    try testRunner.assertEqual(calculator.add(0, 0), 0)
}

testRunner.test("Subtraction works correctly") {
    try testRunner.assertEqual(calculator.subtract(5, 3), 2)
    try testRunner.assertEqual(calculator.subtract(1, 1), 0)
    try testRunner.assertEqual(calculator.subtract(0, 5), -5)
}

testRunner.test("Multiplication works correctly") {
    try testRunner.assertEqual(calculator.multiply(3, 4), 12)
    try testRunner.assertEqual(calculator.multiply(-2, 3), -6)
    try testRunner.assertEqual(calculator.multiply(0, 100), 0)
}

testRunner.test("Division works correctly") {
    let result1 = try calculator.divide(10, 2)
    try testRunner.assert(abs(result1 - 5.0) < 0.001, "10/2 should equal 5.0")
    
    let result2 = try calculator.divide(7, 3)
    try testRunner.assert(abs(result2 - 2.333333) < 0.001, "7/3 should be approximately 2.333333")
}

testRunner.test("Division by zero throws error") {
    var threwError = false
    do {
        _ = try calculator.divide(5, 0)
    } catch Calculator.CalculatorError.divisionByZero {
        threwError = true
    } catch {
        // Unexpected error
    }
    try testRunner.assert(threwError, "Division by zero should throw an error")
}

testRunner.printSummary()
print()

// MARK: - Property-Based Testing
print("2. Property-Based Testing")

// Simple property-based testing
func generateRandomInts(count: Int, range: ClosedRange<Int>) -> [Int] {
    return (0..<count).map { _ in Int.random(in: range) }
}

func propertyTest<T>(
    name: String,
    iterations: Int = 100,
    generator: () -> T,
    property: (T) -> Bool
) {
    var failures: [T] = []
    
    for _ in 0..<iterations {
        let testValue = generator()
        if !property(testValue) {
            failures.append(testValue)
        }
    }
    
    if failures.isEmpty {
        print("✅ Property test '\(name)' passed (\(iterations) iterations)")
    } else {
        print("❌ Property test '\(name)' failed with \(failures.count) failures")
        print("   First few failures: \(Array(failures.prefix(3)))")
    }
}

// Test properties of our calculator
propertyTest(
    name: "Addition is commutative",
    iterations: 50
) {
    let a = Int.random(in: -100...100)
    let b = Int.random(in: -100...100)
    return (a, b)
} property: { (a, b) in
    calculator.add(a, b) == calculator.add(b, a)
}

propertyTest(
    name: "Addition identity",
    iterations: 50
) {
    Int.random(in: -1000...1000)
} property: { a in
    calculator.add(a, 0) == a
}

propertyTest(
    name: "Multiplication is commutative",
    iterations: 50
) {
    let a = Int.random(in: -50...50)
    let b = Int.random(in: -50...50)
    return (a, b)
} property: { (a, b) in
    calculator.multiply(a, b) == calculator.multiply(b, a)
}

print()

// MARK: - Debugging Techniques
print("3. Debugging Techniques")

// Debug utilities
func debugPrint<T>(_ value: T, file: String = #file, line: Int = #line) {
    let filename = URL(fileURLWithPath: file).lastPathComponent
    print("🐛 [\(filename):\(line)] \(value)")
}

func measureExecutionTime<T>(
    _ operation: () throws -> T,
    file: String = #file,
    line: Int = #line
) rethrows -> T {
    let filename = URL(fileURLWithPath: file).lastPathComponent
    let startTime = CFAbsoluteTimeGetCurrent()
    let result = try operation()
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    print("⏱️ [\(filename):\(line)] Execution time: \(String(format: "%.4f", timeElapsed))s")
    return result
}

// Example debugging in action
func complexCalculation(_ numbers: [Int]) -> Int {
    debugPrint("Starting calculation with \(numbers.count) numbers")
    
    let filtered = numbers.filter { $0 > 0 }
    debugPrint("After filtering positive numbers: \(filtered.count) remaining")
    
    let squared = filtered.map { $0 * $0 }
    debugPrint("After squaring: \(squared)")
    
    let sum = squared.reduce(0, +)
    debugPrint("Final sum: \(sum)")
    
    return sum
}

let testNumbers = [-2, 3, -1, 4, 0, 5]
let result = measureExecutionTime {
    complexCalculation(testNumbers)
}
print("Result: \(result)")
print()

// MARK: - Assertions and Preconditions
print("4. Assertions and Preconditions")

func demonstrateAssertions() {
    let userAge = 25
    
    // Debug assertions (only in debug builds)
    assert(userAge >= 0, "Age cannot be negative")
    
    // Preconditions (checked in both debug and release)
    precondition(userAge < 200, "Age seems unrealistic")
    
    print("Age validation passed: \(userAge)")
}

func safeArrayAccess<T>(_ array: [T], at index: Int) -> T? {
    // Guard against invalid indices
    guard index >= 0 && index < array.count else {
        print("⚠️ Invalid array index: \(index) for array of size \(array.count)")
        return nil
    }
    
    return array[index]
}

demonstrateAssertions()

let sampleArray = [1, 2, 3, 4, 5]
print("Safe access at index 2: \(safeArrayAccess(sampleArray, at: 2) ?? -1)")
print("Safe access at index 10: \(safeArrayAccess(sampleArray, at: 10) ?? -1)")
print()

// MARK: - Error Handling Patterns
print("5. Error Handling and Recovery")

enum ValidationError: Error, CustomStringConvertible {
    case emptyInput
    case invalidFormat
    case valueTooLarge(max: Int)
    case valueTooSmall(min: Int)
    
    var description: String {
        switch self {
        case .emptyInput:
            return "Input cannot be empty"
        case .invalidFormat:
            return "Invalid input format"
        case .valueTooLarge(let max):
            return "Value exceeds maximum allowed (\(max))"
        case .valueTooSmall(let min):
            return "Value is below minimum required (\(min))"
        }
    }
}

func validateAge(_ input: String) throws -> Int {
    guard !input.isEmpty else {
        throw ValidationError.emptyInput
    }
    
    guard let age = Int(input) else {
        throw ValidationError.invalidFormat
    }
    
    guard age >= 0 else {
        throw ValidationError.valueTooSmall(min: 0)
    }
    
    guard age <= 150 else {
        throw ValidationError.valueTooLarge(max: 150)
    }
    
    return age
}

// Test error handling
let testInputs = ["25", "", "abc", "-5", "200"]

for input in testInputs {
    do {
        let age = try validateAge(input)
        print("✅ Valid age: \(age)")
    } catch {
        print("❌ Validation failed for '\(input)': \(error)")
    }
}
print()

// MARK: - Test Doubles and Mocking
print("6. Test Doubles and Mocking")

// Protocol for dependency injection
protocol DataRepository {
    func fetchData() async throws -> [String]
    func saveData(_ data: [String]) async throws
}

// Real implementation
class NetworkRepository: DataRepository {
    func fetchData() async throws -> [String] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 100_000_000)
        return ["real", "network", "data"]
    }
    
    func saveData(_ data: [String]) async throws {
        // Simulate save operation
        try await Task.sleep(nanoseconds: 50_000_000)
    }
}

// Mock implementation for testing
class MockRepository: DataRepository {
    var fetchDataResult: Result<[String], Error> = .success([])
    var saveDataResult: Result<Void, Error> = .success(())
    var fetchCallCount = 0
    var saveCallCount = 0
    var lastSavedData: [String]?
    
    func fetchData() async throws -> [String] {
        fetchCallCount += 1
        switch fetchDataResult {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
    
    func saveData(_ data: [String]) async throws {
        saveCallCount += 1
        lastSavedData = data
        switch saveDataResult {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
}

// Service that uses the repository
class DataService {
    private let repository: DataRepository
    
    init(repository: DataRepository) {
        self.repository = repository
    }
    
    func processAndSaveData() async throws -> Int {
        let data = try await repository.fetchData()
        let processedData = data.map { $0.uppercased() }
        try await repository.saveData(processedData)
        return processedData.count
    }
}

// Test with mock
Task {
    let mockRepo = MockRepository()
    mockRepo.fetchDataResult = .success(["test", "mock", "data"])
    
    let service = DataService(repository: mockRepo)
    
    do {
        let count = try await service.processAndSaveData()
        
        print("✅ Service test passed:")
        print("  - Fetch called \(mockRepo.fetchCallCount) times")
        print("  - Save called \(mockRepo.saveCallCount) times")
        print("  - Processed \(count) items")
        print("  - Last saved: \(mockRepo.lastSavedData ?? [])")
    } catch {
        print("❌ Service test failed: \(error)")
    }
}

try? await Task.sleep(nanoseconds: 500_000_000)
print()

// MARK: - Performance Testing
print("7. Performance Testing and Benchmarking")

func benchmark<T>(
    name: String,
    iterations: Int = 1000,
    operation: () throws -> T
) rethrows {
    var times: [TimeInterval] = []
    
    // Warmup
    for _ in 0..<min(10, iterations / 10) {
        _ = try operation()
    }
    
    // Actual measurements
    for _ in 0..<iterations {
        let startTime = CFAbsoluteTimeGetCurrent()
        _ = try operation()
        let elapsed = CFAbsoluteTimeGetCurrent() - startTime
        times.append(elapsed)
    }
    
    let totalTime = times.reduce(0, +)
    let averageTime = totalTime / Double(times.count)
    let minTime = times.min() ?? 0
    let maxTime = times.max() ?? 0
    
    print("📈 Benchmark '\(name)' (\(iterations) iterations):")
    print("  - Average: \(String(format: "%.6f", averageTime))s")
    print("  - Min: \(String(format: "%.6f", minTime))s")
    print("  - Max: \(String(format: "%.6f", maxTime))s")
    print("  - Total: \(String(format: "%.6f", totalTime))s")
}

// Compare different string concatenation methods
let words = Array(repeating: "test", count: 100)

benchmark(name: "String concatenation with +") {
    var result = ""
    for word in words {
        result += word
    }
    return result
}

benchmark(name: "String concatenation with joined") {
    return words.joined()
}

benchmark(name: "Array operations") {
    let numbers = Array(1...1000)
    return numbers.map { $0 * 2 }.filter { $0 % 4 == 0 }.reduce(0, +)
}

print("\n=== Testing and Debugging Complete ===") 