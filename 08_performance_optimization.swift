#!/usr/bin/env swift

// MARK: - Performance and Optimization Playground
// Exploring performance measurement, optimization techniques, and memory efficiency

import Foundation
import CoreFoundation

print("=== Performance and Optimization Playground ===\n")

// MARK: - Performance Measurement
print("1. Performance Measurement")

func measureTime<T>(operation: () -> T) -> (result: T, timeElapsed: TimeInterval) {
    let startTime = CFAbsoluteTimeGetCurrent()
    let result = operation()
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    return (result, timeElapsed)
}

// Example: Array vs Set lookup performance
let largeArray = Array(1...10000)
let largeSet = Set(largeArray)
let searchValue = 7500

let (arrayResult, arrayLookupTime) = measureTime {
    largeArray.contains(searchValue)
}

let (setResult, setTime) = measureTime {
    largeSet.contains(searchValue)
}

print("Array contains lookup: \(arrayResult) - Time: \(String(format: "%.6f", arrayLookupTime))s")
print("Set contains lookup: \(setResult) - Time: \(String(format: "%.6f", setTime))s")
print("Set is \(String(format: "%.1f", arrayLookupTime / setTime))x faster for lookups")
print()

// MARK: - Copy-on-Write Semantics
print("2. Copy-on-Write (COW) Semantics")

// Demonstrating COW with arrays
var originalArray = Array(1...1000)
print("Original array count: \(originalArray.count)")

let (_, copyTime) = measureTime {
    let copiedArray = originalArray  // This is O(1) due to COW
    _ = copiedArray.count
}

let (_, modifyTime) = measureTime {
    var copiedArray = originalArray
    copiedArray.append(1001)  // This triggers actual copy - O(n)
}

print("Array copy time: \(String(format: "%.6f", copyTime))s")
print("Array modify time: \(String(format: "%.6f", modifyTime))s")

// Custom COW implementation
struct COWArray<Element> {
    private final class Storage {
        var elements: [Element]
        
        init(_ elements: [Element]) {
            self.elements = elements
        }
    }
    
    private var storage: Storage
    
    init(_ elements: [Element] = []) {
        storage = Storage(elements)
    }
    
    var count: Int {
        return storage.elements.count
    }
    
    subscript(index: Int) -> Element {
        get {
            return storage.elements[index]
        }
        set {
            if !isKnownUniquelyReferenced(&storage) {
                storage = Storage(storage.elements)
            }
            storage.elements[index] = newValue
        }
    }
    
    mutating func append(_ element: Element) {
        if !isKnownUniquelyReferenced(&storage) {
            storage = Storage(storage.elements)
        }
        storage.elements.append(element)
    }
}

var cowArray1 = COWArray([1, 2, 3])
var cowArray2 = cowArray1  // Shares storage

print("COW Array 1 count: \(cowArray1.count)")
print("COW Array 2 count: \(cowArray2.count)")

cowArray2.append(4)  // Triggers copy
print("After modifying array 2:")
print("COW Array 1 count: \(cowArray1.count)")
print("COW Array 2 count: \(cowArray2.count)")
print()

// MARK: - Memory Usage Optimization
print("3. Memory Usage Patterns")

// Value types vs Reference types memory behavior
struct ValuePoint {
    let x: Double
    let y: Double
}

class ReferencePoint {
    let x: Double
    let y: Double
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

func createValuePoints(count: Int) -> [ValuePoint] {
    return (0..<count).map { i in
        ValuePoint(x: Double(i), y: Double(i * 2))
    }
}

func createReferencePoints(count: Int) -> [ReferencePoint] {
    return (0..<count).map { i in
        ReferencePoint(x: Double(i), y: Double(i * 2))
    }
}

let pointCount = 10000

let (valuePoints, valueTime) = measureTime {
    createValuePoints(count: pointCount)
}

let (referencePoints, refTime) = measureTime {
    createReferencePoints(count: pointCount)
}

print("Creating \(pointCount) value points: \(String(format: "%.4f", valueTime))s")
print("Creating \(pointCount) reference points: \(String(format: "%.4f", refTime))s")

// Memory layout demonstration
print("ValuePoint size: \(MemoryLayout<ValuePoint>.size) bytes")
print("ValuePoint alignment: \(MemoryLayout<ValuePoint>.alignment) bytes")
print("ValuePoint stride: \(MemoryLayout<ValuePoint>.stride) bytes")
print()

// MARK: - Algorithm Complexity Analysis
print("4. Algorithm Complexity Comparison")

// O(n²) vs O(n log n) sorting comparison
func bubbleSort(_ array: inout [Int]) {
    let n = array.count
    for i in 0..<n {
        for j in 0..<(n - i - 1) {
            if array[j] > array[j + 1] {
                array.swapAt(j, j + 1)
            }
        }
    }
}

// Test with different sizes
let sizes = [100, 500, 1000]

for size in sizes {
    var bubbleArray = Array((1...size).shuffled())
    var swiftArray = bubbleArray
    
    let (_, bubbleTime) = measureTime {
        bubbleSort(&bubbleArray)
    }
    
    let (_, swiftTime) = measureTime {
        swiftArray.sort()
    }
    
    print("Size \(size) - Bubble sort: \(String(format: "%.4f", bubbleTime))s, Swift sort: \(String(format: "%.4f", swiftTime))s")
    print("Swift sort is \(String(format: "%.1f", bubbleTime / swiftTime))x faster")
}
print()

// MARK: - String Performance
print("5. String Performance Optimization")

// String concatenation performance
func inefficientStringConcat(count: Int) -> String {
    var result = ""
    for i in 0..<count {
        result += "Item \(i), "
    }
    return result
}

func efficientStringConcat(count: Int) -> String {
    var parts: [String] = []
    parts.reserveCapacity(count)
    for i in 0..<count {
        parts.append("Item \(i), ")
    }
    return parts.joined()
}

let stringCount = 1000

let (_, inefficientTime) = measureTime {
    _ = inefficientStringConcat(count: stringCount)
}

let (_, efficientTime) = measureTime {
    _ = efficientStringConcat(count: stringCount)
}

print("Inefficient string concat: \(String(format: "%.4f", inefficientTime))s")
print("Efficient string concat: \(String(format: "%.4f", efficientTime))s")
print("Improvement: \(String(format: "%.1f", inefficientTime / efficientTime))x faster")

// String searching optimization
let longText = String(repeating: "Lorem ipsum dolor sit amet. ", count: 1000)
let searchTerm = "dolor"

let (_, containsTime) = measureTime {
    _ = longText.contains(searchTerm)
}

let (_, rangeTime) = measureTime {
    _ = longText.range(of: searchTerm) != nil
}

print("String.contains: \(String(format: "%.6f", containsTime))s")
print("String.range(of:): \(String(format: "%.6f", rangeTime))s")
print()

// MARK: - Collection Performance
print("6. Collection Performance Patterns")

// Array vs ContiguousArray performance
let dataSize = 100000

let (_, arrayCreationTime) = measureTime {
    var arr = Array<Int>()
    arr.reserveCapacity(dataSize)
    for i in 0..<dataSize {
        arr.append(i)
    }
    return arr.reduce(0, +)
}

let (_, contiguousTime) = measureTime {
    var arr = ContiguousArray<Int>()
    arr.reserveCapacity(dataSize)
    for i in 0..<dataSize {
        arr.append(i)
    }
    return arr.reduce(0, +)
}

print("Array performance: \(String(format: "%.4f", arrayCreationTime))s")
print("ContiguousArray performance: \(String(format: "%.4f", contiguousTime))s")

// Dictionary vs Array for key-value storage
struct KeyValuePair {
    let key: String
    let value: Int
}

let kvPairs = (0..<1000).map { KeyValuePair(key: "key\($0)", value: $0) }
let dictionary = Dictionary(uniqueKeysWithValues: kvPairs.map { ($0.key, $0.value) })

let searchKey = "key500"

let (_, arraySearchTime) = measureTime {
    _ = kvPairs.first { $0.key == searchKey }?.value
}

let (_, dictSearchTime) = measureTime {
    _ = dictionary[searchKey]
}

print("Array search: \(String(format: "%.6f", arraySearchTime))s")
print("Dictionary search: \(String(format: "%.6f", dictSearchTime))s")
print("Dictionary is \(String(format: "%.1f", arraySearchTime / dictSearchTime))x faster for lookups")
print()

// MARK: - Memory Pool Pattern
print("7. Object Pool Pattern")

class ExpensiveObject {
    let data: [Int]
    
    init() {
        // Simulate expensive initialization
        self.data = Array(1...1000)
    }
    
    func reset() {
        // Reset object state for reuse
    }
}

class ObjectPool<T> where T: AnyObject {
    private var pool: [T] = []
    private let createObject: () -> T
    private let resetObject: (T) -> Void
    
    init(initialSize: Int = 0, createObject: @escaping () -> T, resetObject: @escaping (T) -> Void) {
        self.createObject = createObject
        self.resetObject = resetObject
        
        for _ in 0..<initialSize {
            pool.append(createObject())
        }
    }
    
    func get() -> T {
        if let object = pool.popLast() {
            return object
        } else {
            return createObject()
        }
    }
    
    func release(_ object: T) {
        resetObject(object)
        pool.append(object)
    }
}

let pool = ObjectPool<ExpensiveObject>(
    initialSize: 5,
    createObject: { ExpensiveObject() },
    resetObject: { $0.reset() }
)

// Without pool
let (_, withoutPoolTime) = measureTime {
    for _ in 0..<100 {
        let obj = ExpensiveObject()
        _ = obj.data.count
    }
}

// With pool
let (_, withPoolTime) = measureTime {
    for _ in 0..<100 {
        let obj = pool.get()
        _ = obj.data.count
        pool.release(obj)
    }
}

print("Without object pool: \(String(format: "%.4f", withoutPoolTime))s")
print("With object pool: \(String(format: "%.4f", withPoolTime))s")
print("Pool provides \(String(format: "%.1f", withoutPoolTime / withPoolTime))x improvement")

print("\n=== Performance and Optimization Complete ===") 