#!/usr/bin/env swift

// MARK: - Run All Playground Scripts
// Simple script to execute all playground files

import Foundation

print("=== Swift Playground Collection ===\n")

let playgroundFiles = [
    "01_fundamentals.swift",
    "02_functions_and_closures.swift", 
    "03_structs_and_classes.swift",
    "04_advanced_features.swift",
    "05_concurrency_and_async.swift"
]

for (index, file) in playgroundFiles.enumerated() {
    print("📚 Running \(file)...")
    print("=" * 50)
    
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
    process.arguments = [file]
    
    do {
        try process.run()
        process.waitUntilExit()
        
        if process.terminationStatus == 0 {
            print("✅ \(file) completed successfully")
        } else {
            print("❌ \(file) failed with exit code \(process.terminationStatus)")
        }
    } catch {
        print("❌ Failed to run \(file): \(error)")
    }
    
    if index < playgroundFiles.count - 1 {
        print("\n" + "=" * 50)
        print("Press Enter to continue to next playground...")
        _ = readLine()
        print()
    }
}

print("\n🎉 All playgrounds completed!") 