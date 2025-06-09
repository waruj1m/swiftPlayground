#!/usr/bin/env swift

// MARK: - Run All Playground Scripts
// Simple script to execute all playground files

import Foundation

print("🚀 Swift Playground Collection Runner\n")

let playgroundFiles = [
    "01_fundamentals.swift",
    "02_functions_and_closures.swift", 
    "03_structs_and_classes.swift",
    "04_advanced_features.swift",
    "05_concurrency_and_async.swift"
]

print("Found \(playgroundFiles.count) playground scripts to run.\n")

for (index, file) in playgroundFiles.enumerated() {
    print("📚 [\(index + 1)/\(playgroundFiles.count)] Running \(file)...")
    print(String(repeating: "=", count: 60))
    
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    process.arguments = ["swift", file]
    process.currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    
    let startTime = Date()
    
    do {
        try process.run()
        process.waitUntilExit()
        
        let duration = Date().timeIntervalSince(startTime)
        
        if process.terminationStatus == 0 {
            print("✅ \(file) completed successfully in \(String(format: "%.2f", duration))s")
        } else {
            print("❌ \(file) failed with exit code \(process.terminationStatus)")
        }
    } catch {
        print("❌ Failed to run \(file): \(error)")
    }
    
    if index < playgroundFiles.count - 1 {
        print("\n" + String(repeating: "-", count: 60))
        print("⏯️  Press Enter to continue to next playground (or Ctrl+C to stop)...")
        _ = readLine()
        print()
    }
}

print("\n" + String(repeating: "=", count: 60))
print("🎉 All \(playgroundFiles.count) playground scripts completed!")
print("📖 Check out the README.md for more information about each playground.") 