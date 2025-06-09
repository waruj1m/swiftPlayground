#!/usr/bin/env swift

// MARK: - Swift Fundamentals Playground
// Testing basic Swift concepts including types, variables, and control flow

import Foundation

print("=== Swift Fundamentals Playground ===\n")

// MARK: - Basic Types and Variables
print("1. Basic Types and Variables")

// Type inference - Swift can infer types
let message = "Hello, Swift!"
let count = 42
let pi = 3.14159
let isActive = true

print("Message: \(message)")
print("Count: \(count) (type: \(type(of: count)))")
print("Pi: \(pi) (type: \(type(of: pi)))")
print("Active: \(isActive) (type: \(type(of: isActive)))")

// Explicit type annotations
let explicitString: String = "Explicitly typed"
let explicitInt: Int = 100
var mutableValue: Double = 25.5

print("Explicit string: \(explicitString)")
print("Mutable value before: \(mutableValue)")
mutableValue = 30.7
print("Mutable value after: \(mutableValue)\n")

// MARK: - String Interpolation and Manipulation
print("2. String Features")

let firstName = "John"
let lastName = "Doe"
let age = 30

// String interpolation
let introduction = "My name is \(firstName) \(lastName) and I'm \(age) years old."
print(introduction)

// String methods
let sentence = "The quick brown fox jumps over the lazy dog"
print("Original: \(sentence)")
print("Uppercase: \(sentence.uppercased())")
print("Character count: \(sentence.count)")
print("Contains 'fox': \(sentence.contains("fox"))")
print("Starts with 'The': \(sentence.hasPrefix("The"))\n")

// MARK: - Collections
print("3. Collections")

// Arrays
var fruits = ["apple", "banana", "orange"]
print("Fruits: \(fruits)")

fruits.append("grape")
print("After adding grape: \(fruits)")

// Array operations
let numbers = [1, 2, 3, 4, 5]
let doubled = numbers.map { $0 * 2 }
let evenNumbers = numbers.filter { $0 % 2 == 0 }
let sum = numbers.reduce(0, +)

print("Numbers: \(numbers)")
print("Doubled: \(doubled)")
print("Even numbers: \(evenNumbers)")
print("Sum: \(sum)")

// Dictionaries
var scores = ["Alice": 95, "Bob": 87, "Charlie": 92]
print("Scores: \(scores)")

scores["David"] = 88
print("After adding David: \(scores)")

// Dictionary operations
let topScorers = scores.filter { $0.value >= 90 }
print("Top scorers (≥90): \(topScorers)\n")

// MARK: - Control Flow
print("4. Control Flow")

// If statements
let temperature = 25
if temperature < 0 {
    print("It's freezing!")
} else if temperature < 20 {
    print("It's cold")
} else if temperature < 30 {
    print("It's pleasant")
} else {
    print("It's hot!")
}

// Switch statements
let grade = "B"
switch grade {
case "A":
    print("Excellent!")
case "B":
    print("Good job!")
case "C":
    print("You can do better")
case "D", "F":
    print("Need improvement")
default:
    print("Invalid grade")
}

// For loops
print("Counting from 1 to 5:")
for i in 1...5 {
    print("  \(i)")
}

print("Iterating over fruits:")
for (index, fruit) in fruits.enumerated() {
    print("  \(index + 1). \(fruit)")
}

// While loop
print("Powers of 2 less than 100:")
var power = 1
while power < 100 {
    print("  \(power)")
    power *= 2
}

print("\n=== Fundamentals Complete ===") 