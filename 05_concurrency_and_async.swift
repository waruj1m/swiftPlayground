#!/usr/bin/env swift

// MARK: - Concurrency and Async/Await Playground
// Exploring Swift's modern concurrency features

import Foundation

print("=== Concurrency and Async/Await Playground ===\n")

// MARK: - Basic Async/Await
print("1. Basic Async/Await")

// Simple async function
func fetchUserName(id: Int) async -> String {
    // Simulate network delay
    try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
    return "User\(id)"
}

// Async function that can throw
func fetchUserData(id: Int) async throws -> [String: Any] {
    // Simulate network delay
    try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
    
    // Simulate potential error
    if id <= 0 {
        throw URLError(.badURL)
    }
    
    return [
        "id": id,
        "name": await fetchUserName(id: id),
        "email": "user\(id)@example.com",
        "created": Date()
    ]
}

// Using async functions
Task {
    print("Starting async operations...")
    
    // Sequential execution
    let startTime = Date()
    let user1 = try? await fetchUserData(id: 1)
    let user2 = try? await fetchUserData(id: 2)
    let sequentialTime = Date().timeIntervalSince(startTime)
    
    print("Sequential execution took \(String(format: "%.2f", sequentialTime))s")
    print("User 1: \(user1?["name"] ?? "unknown")")
    print("User 2: \(user2?["name"] ?? "unknown")")
    
    // Concurrent execution with async let
    let concurrentStartTime = Date()
    async let user3 = try fetchUserData(id: 3)
    async let user4 = try fetchUserData(id: 4)
    
    let results = try? await [user3, user4]
    let concurrentTime = Date().timeIntervalSince(concurrentStartTime)
    
    print("Concurrent execution took \(String(format: "%.2f", concurrentTime))s")
    if let results = results {
        print("User 3: \(results[0]["name"] ?? "unknown")")
        print("User 4: \(results[1]["name"] ?? "unknown")")
    }
    print()
}

// Give time for async operations to complete
try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds

// MARK: - Task Groups and Structured Concurrency
print("2. Task Groups and Structured Concurrency")

func downloadFile(name: String, size: Int) async -> String {
    let delay = UInt64(size * 100_000) // Simulate download time based on size
    try? await Task.sleep(nanoseconds: delay)
    return "Downloaded \(name) (\(size)KB)"
}

// Using TaskGroup for concurrent operations
Task {
    let files = [
        ("document.pdf", 1500),
        ("image.jpg", 800),
        ("video.mp4", 5000),
        ("audio.mp3", 1200)
    ]
    
    let startTime = Date()
    
    let results = await withTaskGroup(of: String.self) { group in
        var downloadResults: [String] = []
        
        // Add tasks to the group
        for (name, size) in files {
            group.addTask {
                await downloadFile(name: name, size: size)
            }
        }
        
        // Collect results as they complete
        for await result in group {
            downloadResults.append(result)
            print("Completed: \(result)")
        }
        
        return downloadResults
    }
    
    let totalTime = Date().timeIntervalSince(startTime)
    print("All downloads completed in \(String(format: "%.2f", totalTime))s")
    print("Total files: \(results.count)")
    print()
}

try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds

// MARK: - Actors for Thread-Safe State
print("3. Actors for Thread-Safe State")

actor BankAccount {
    private var balance: Double
    private let accountNumber: String
    
    init(accountNumber: String, initialBalance: Double = 0) {
        self.accountNumber = accountNumber
        self.balance = initialBalance
    }
    
    func getBalance() -> Double {
        return balance
    }
    
    func deposit(amount: Double) {
        guard amount > 0 else { return }
        balance += amount
        print("Deposited $\(amount) to \(accountNumber). New balance: $\(balance)")
    }
    
    func withdraw(amount: Double) throws {
        guard amount > 0 else { 
            throw BankError.invalidAmount 
        }
        guard balance >= amount else { 
            throw BankError.insufficientFunds 
        }
        
        balance -= amount
        print("Withdrew $\(amount) from \(accountNumber). New balance: $\(balance)")
    }
    
    func transfer(to otherAccount: BankAccount, amount: Double) async throws {
        try withdraw(amount: amount)
        await otherAccount.deposit(amount: amount)
        print("Transferred $\(amount) from \(accountNumber) to \(await otherAccount.accountNumber)")
    }
}

enum BankError: Error {
    case insufficientFunds
    case invalidAmount
}

Task {
    let account1 = BankAccount(accountNumber: "ACC001", initialBalance: 1000)
    let account2 = BankAccount(accountNumber: "ACC002", initialBalance: 500)
    
    print("Initial balances:")
    print("Account 1: $\(await account1.getBalance())")
    print("Account 2: $\(await account2.getBalance())")
    
    // Concurrent operations on actors are automatically serialized
    async let operation1: Void = account1.deposit(amount: 200)
    async let operation2: Void = account2.deposit(amount: 100)
    async let operation3: Void = {
        try? await account1.transfer(to: account2, amount: 300)
    }()
    
    await (operation1, operation2, operation3)
    
    print("Final balances:")
    print("Account 1: $\(await account1.getBalance())")
    print("Account 2: $\(await account2.getBalance())")
    print()
}

try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second

// MARK: - AsyncSequence
print("4. AsyncSequence")

struct NumberSequence: AsyncSequence {
    typealias Element = Int
    
    let start: Int
    let end: Int
    let delay: UInt64
    
    func makeAsyncIterator() -> AsyncIterator {
        return AsyncIterator(start: start, end: end, delay: delay)
    }
    
    struct AsyncIterator: AsyncIteratorProtocol {
        var current: Int
        let end: Int
        let delay: UInt64
        
        init(start: Int, end: Int, delay: UInt64) {
            self.current = start
            self.end = end
            self.delay = delay
        }
        
        mutating func next() async -> Int? {
            guard current <= end else { return nil }
            
            try? await Task.sleep(nanoseconds: delay)
            let value = current
            current += 1
            return value
        }
    }
}

Task {
    let sequence = NumberSequence(start: 1, end: 5, delay: 200_000_000) // 0.2s delay
    
    print("Processing async sequence:")
    for await number in sequence {
        print("Received: \(number)")
    }
    
    // Using async sequence with map and filter
    let evenNumbers = sequence
        .compactMap { $0 % 2 == 0 ? $0 : nil }
    
    print("Even numbers from sequence:")
    for await number in evenNumbers {
        print("Even: \(number)")
    }
    print()
}

try? await Task.sleep(nanoseconds: 3_000_000_000) // 3 seconds

// MARK: - Continuation and Bridging Legacy Code
print("5. Continuation and Bridging Legacy Code")

// Legacy callback-based function
func legacyAsyncOperation(completion: @escaping (Result<String, Error>) -> Void) {
    DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
        if Bool.random() {
            completion(.success("Legacy operation succeeded"))
        } else {
            completion(.failure(URLError(.timedOut)))
        }
    }
}

// Bridging to async/await using continuation
func modernAsyncOperation() async throws -> String {
    return try await withCheckedThrowingContinuation { continuation in
        legacyAsyncOperation { result in
            continuation.resume(with: result)
        }
    }
}

Task {
    do {
        let result = try await modernAsyncOperation()
        print("Modern async result: \(result)")
    } catch {
        print("Modern async error: \(error)")
    }
}

try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second

// MARK: - Async Properties and Main Actor
print("6. Async Properties and Main Actor")

@MainActor
class UIManager {
    private var isLoading = false
    
    var loadingState: String {
        return isLoading ? "Loading..." : "Ready"
    }
    
    func updateUI() {
        print("UI updated on main thread: \(loadingState)")
    }
    
    func performAsyncOperation() async {
        isLoading = true
        updateUI()
        
        // Simulate work on background
        await withCheckedContinuation { continuation in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                continuation.resume()
            }
        }
        
        isLoading = false
        updateUI()
    }
}

Task {
    let uiManager = await UIManager()
    await uiManager.performAsyncOperation()
    print()
}

try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds

// MARK: - Cancellation and Task Priorities
print("7. Task Cancellation and Priorities")

func cancellableOperation(id: Int) async throws -> String {
    for i in 1...10 {
        // Check for cancellation
        try Task.checkCancellation()
        
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        print("Operation \(id) - step \(i)/10")
    }
    return "Operation \(id) completed"
}

Task {
    // Create tasks with different priorities
    let highPriorityTask = Task(priority: .high) {
        try await cancellableOperation(id: 1)
    }
    
    let lowPriorityTask = Task(priority: .low) {
        try await cancellableOperation(id: 2)
    }
    
    // Let them run for a bit
    try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
    
    // Cancel the low priority task
    lowPriorityTask.cancel()
    print("Cancelled low priority task")
    
    // Wait for high priority task to complete
    do {
        let result = try await highPriorityTask.value
        print("High priority task result: \(result)")
    } catch {
        print("High priority task error: \(error)")
    }
    
    // Check if low priority task was cancelled
    do {
        let result = try await lowPriorityTask.value
        print("Low priority task result: \(result)")
    } catch {
        print("Low priority task was cancelled: \(error)")
    }
}

try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds

print("=== Concurrency and Async/Await Complete ===") 