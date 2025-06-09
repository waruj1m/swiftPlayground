# Swift Playground Collection

A comprehensive collection of Swift playground scripts designed to explore and test Swift features on Linux.

## 📁 Playground Scripts

### 1. `01_fundamentals.swift`
- **Basic Types**: Variables, constants, type inference
- **String Features**: Interpolation, manipulation, methods
- **Collections**: Arrays, dictionaries, and operations
- **Control Flow**: Conditional statements, loops, ranges

### 2. `02_functions_and_closures.swift`
- **Functions**: Parameters, return types, overloading
- **Closures**: Syntax variations, capturing, trailing closures
- **Higher-Order Functions**: map, filter, reduce, compactMap
- **Function Types**: First-class functions, function composition

### 3. `03_structs_and_classes.swift`
- **Structs**: Value types, methods, computed properties
- **Classes**: Reference types, inheritance, polymorphism
- **Protocols**: Protocol-oriented programming, extensions
- **Generics**: Generic types, constraints, type safety

### 4. `04_advanced_features.swift`
- **Optionals**: Optional chaining, nil coalescing, guard statements
- **Error Handling**: throws, do-catch, Result type
- **Pattern Matching**: Switch statements, tuple matching
- **Custom Operators**: Operator overloading, precedence
- **Memory Management**: ARC, weak/strong references
- **Property Wrappers**: Custom property behaviors

### 5. `05_concurrency_and_async.swift`
- **Async/Await**: Modern concurrency syntax
- **Task Groups**: Structured concurrency patterns
- **Actors**: Thread-safe state management
- **AsyncSequence**: Asynchronous iteration
- **Continuations**: Bridging callback-based APIs
- **Cancellation**: Task management and priorities

## 🚀 Usage

### Run Individual Scripts
```bash
# Make scripts executable
chmod +x *.swift

# Run individual playground
./01_fundamentals.swift
./02_functions_and_closures.swift
# ... etc
```

### Run All Scripts
```bash
# Run all playgrounds sequentially
./run_all.swift
```

### Direct Swift Execution
```bash
# Alternative execution method
swift 01_fundamentals.swift
swift 02_functions_and_closures.swift
# ... etc
```

## 🎯 Learning Objectives

These playgrounds demonstrate:
- Swift language fundamentals and syntax
- Object-oriented and protocol-oriented programming
- Functional programming concepts
- Modern concurrency features
- Best practices from Swift API Design Guidelines
- Real-world coding patterns and techniques

## 🔧 Requirements

- Swift 5.5+ (for async/await features)
- Linux environment with Swift installed
- Foundation framework (included with Swift)

## 📖 API Design Guidelines Compliance

All code follows the [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/):
- Clear, self-documenting names
- Consistent parameter labeling
- Proper use of case conventions
- Fluent usage patterns

## 🧪 Testing Swift Features

Each script is designed to be educational and demonstrate:
- Correct Swift idioms
- Performance considerations
- Memory management patterns
- Error handling strategies
- Concurrent programming techniques

Feel free to modify and experiment with these scripts to deepen your understanding of Swift! 