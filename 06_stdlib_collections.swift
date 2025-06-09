#!/usr/bin/env swift

// MARK: - Standard Library Collections Playground
// Exploring advanced collection types, algorithms, and sequence operations

import Foundation

print("=== Standard Library Collections Playground ===\n")

// MARK: - Advanced Array Operations
print("1. Advanced Array Operations")

let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

// Prefix and suffix operations
let firstThree = numbers.prefix(3)
let lastThree = numbers.suffix(3)
let firstWhileSmall = numbers.prefix(while: { $0 < 5 })

print("Original: \(numbers)")
print("First 3: \(Array(firstThree))")
print("Last 3: \(Array(lastThree))")
print("First while < 5: \(Array(firstWhileSmall))")

// Drop operations
let withoutFirstTwo = numbers.dropFirst(2)
let withoutLastTwo = numbers.dropLast(2)
let dropWhileSmall = numbers.drop(while: { $0 < 4 })

print("Without first 2: \(Array(withoutFirstTwo))")
print("Without last 2: \(Array(withoutLastTwo))")
print("Drop while < 4: \(Array(dropWhileSmall))")

// Chunking and splitting
extension Collection {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[index(startIndex, offsetBy: $0)..<index(startIndex, offsetBy: Swift.min($0 + size, count))])
        }
    }
}

let chunked = numbers.chunked(into: 3)
print("Chunked by 3: \(chunked)")

// First and last with conditions
let firstEven = numbers.first(where: { $0 % 2 == 0 })
let lastOdd = numbers.last(where: { $0 % 2 == 1 })

print("First even: \(firstEven ?? -1)")
print("Last odd: \(lastOdd ?? -1)")
print()

// MARK: - Set Operations
print("2. Set Operations")

let setA: Set = [1, 2, 3, 4, 5]
let setB: Set = [4, 5, 6, 7, 8]
let setC: Set = [1, 2, 3]

print("Set A: \(setA.sorted())")
print("Set B: \(setB.sorted())")
print("Set C: \(setC.sorted())")

// Set operations
let union = setA.union(setB)
let intersection = setA.intersection(setB)
let difference = setA.subtracting(setB)
let symmetricDifference = setA.symmetricDifference(setB)

print("Union A ∪ B: \(union.sorted())")
print("Intersection A ∩ B: \(intersection.sorted())")
print("Difference A - B: \(difference.sorted())")
print("Symmetric Difference A △ B: \(symmetricDifference.sorted())")

// Set relationships
let isSubset = setC.isSubset(of: setA)
let isSuperset = setA.isSuperset(of: setC)
let isDisjoint = setA.isDisjoint(with: Set([10, 11, 12]))

print("C ⊆ A (subset): \(isSubset)")
print("A ⊇ C (superset): \(isSuperset)")
print("A disjoint with {10,11,12}: \(isDisjoint)")
print()

// MARK: - Dictionary Advanced Operations
print("3. Dictionary Advanced Operations")

var inventory = [
    "apples": 50,
    "bananas": 30,
    "oranges": 25,
    "grapes": 40
]

print("Initial inventory: \(inventory)")

// Dictionary transformations
let doubledInventory = inventory.mapValues { $0 * 2 }
let expensiveItems = inventory.filter { $0.value > 30 }
let totalItems = inventory.values.reduce(0, +)

print("Doubled inventory: \(doubledInventory)")
print("Expensive items (>30): \(expensiveItems)")
print("Total items: \(totalItems)")

// Merging dictionaries
let newStock = ["kiwis": 15, "apples": 20]
inventory.merge(newStock) { (current, new) in current + new }
print("After merging new stock: \(inventory)")

// Group by operations
let words = ["apple", "banana", "apricot", "blueberry", "avocado", "blackberry"]
let groupedByFirstLetter = Dictionary(grouping: words) { $0.first! }
print("Grouped by first letter: \(groupedByFirstLetter)")

// Unique key-value mapping
let wordLengths = Dictionary(uniqueKeysWithValues: words.map { ($0, $0.count) })
print("Word lengths: \(wordLengths)")
print()

// MARK: - Sequence and Iterator Protocols
print("4. Custom Sequences")

// Fibonacci sequence
struct FibonacciSequence: Sequence {
    let maxCount: Int
    
    func makeIterator() -> FibonacciIterator {
        return FibonacciIterator(maxCount: maxCount)
    }
}

struct FibonacciIterator: IteratorProtocol {
    let maxCount: Int
    var count = 0
    var current = 0
    var nextValue = 1
    
    mutating func next() -> Int? {
        guard count < maxCount else { return nil }
        
        defer {
            let newNext = current + nextValue
            current = nextValue
            nextValue = newNext
            count += 1
        }
        
        return count == 0 ? 0 : current
    }
}

let fibonacci = FibonacciSequence(maxCount: 10)
print("First 10 Fibonacci numbers: \(Array(fibonacci))")

// Custom range sequence
struct CountdownSequence: Sequence {
    let start: Int
    let step: Int
    
    func makeIterator() -> CountdownIterator {
        return CountdownIterator(current: start, step: step)
    }
}

struct CountdownIterator: IteratorProtocol {
    var current: Int
    let step: Int
    
    mutating func next() -> Int? {
        guard current > 0 else { return nil }
        let result = current
        current -= step
        return result
    }
}

let countdown = CountdownSequence(start: 10, step: 2)
print("Countdown from 10 by 2: \(Array(countdown))")
print()

// MARK: - Lazy Evaluation
print("5. Lazy Evaluation")

let largeRange = 1...1000000

// Regular evaluation (processes all elements)
let startTime1 = Date()
let regularResult = largeRange
    .filter { $0 % 2 == 0 }
    .map { $0 * $0 }
    .prefix(5)
let regularTime = Date().timeIntervalSince(startTime1)

print("Regular evaluation took: \(String(format: "%.6f", regularTime))s")
print("First 5 results: \(Array(regularResult))")

// Lazy evaluation (processes only what's needed)
let startTime2 = Date()
let lazyResult = largeRange
    .lazy
    .filter { $0 % 2 == 0 }
    .map { $0 * $0 }
    .prefix(5)
let lazyTime = Date().timeIntervalSince(startTime2)

print("Lazy evaluation took: \(String(format: "%.6f", lazyTime))s")
print("First 5 results: \(Array(lazyResult))")
print("Performance improvement: \(String(format: "%.1f", regularTime / lazyTime))x faster")
print()

// MARK: - Collection Algorithms
print("6. Collection Algorithms")

var mutableNumbers = [5, 2, 8, 1, 9, 3]
print("Original: \(mutableNumbers)")

// Sorting variations
let sortedAscending = mutableNumbers.sorted()
let sortedDescending = mutableNumbers.sorted(by: >)
print("Sorted ascending: \(sortedAscending)")
print("Sorted descending: \(sortedDescending)")

// In-place sorting
mutableNumbers.sort()
print("After in-place sort: \(mutableNumbers)")

// Shuffling
mutableNumbers.shuffle()
print("After shuffle: \(mutableNumbers)")

// Partitioning
let partitionIndex = mutableNumbers.partition { $0 < 5 }
print("After partition (< 5): \(mutableNumbers)")
print("Partition index: \(partitionIndex)")

// Reverse and rotate
mutableNumbers.reverse()
print("After reverse: \(mutableNumbers)")

// Custom comparison sorting
struct Person {
    let name: String
    let age: Int
}

let people = [
    Person(name: "Alice", age: 25),
    Person(name: "Bob", age: 30),
    Person(name: "Charlie", age: 20)
]

let sortedByAge = people.sorted { $0.age < $1.age }
let sortedByName = people.sorted { $0.name < $1.name }

print("Sorted by age: \(sortedByAge.map { "\($0.name)(\($0.age))" })")
print("Sorted by name: \(sortedByName.map { "\($0.name)(\($0.age))" })")
print()

// MARK: - Advanced Functional Operations
print("7. Advanced Functional Operations")

let sentences = [
    "The quick brown fox",
    "jumps over the lazy dog",
    "in the moonlight"
]

// FlatMap for flattening
let allWords = sentences.flatMap { $0.split(separator: " ").map(String.init) }
print("All words: \(allWords)")

// Reduce with complex operations
let wordStats = allWords.reduce(into: [String: Int]()) { counts, word in
    counts[word.lowercased(), default: 0] += 1
}
print("Word frequency: \(wordStats)")

// Multiple reductions
let statistics = numbers.reduce(into: (sum: 0, product: 1, count: 0)) { result, number in
    result.sum += number
    result.product *= number
    result.count += 1
}

print("Statistics - Sum: \(statistics.sum), Product: \(statistics.product), Count: \(statistics.count)")

// Scan (accumulating reduce)
extension Sequence {
    func scan<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) -> Result) -> [Result] {
        var result = [initialResult]
        for element in self {
            result.append(nextPartialResult(result.last!, element))
        }
        return result
    }
}

let runningSum = [1, 2, 3, 4, 5].scan(0, +)
print("Running sum: \(runningSum)")

print("\n=== Standard Library Collections Complete ===") 