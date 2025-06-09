#!/usr/bin/env swift

// MARK: - Foundation and Core Libraries Playground
// Exploring Foundation framework features and core library functionality

import Foundation

print("=== Foundation and Core Libraries Playground ===\n")

// MARK: - Date and Time Operations
print("1. Date and Time Operations")

let now = Date()
let calendar = Calendar.current
let timeZone = TimeZone.current

print("Current date: \(now)")
print("Current timezone: \(timeZone.identifier)")

// Date formatting
let dateFormatter = DateFormatter()
dateFormatter.dateStyle = .full
dateFormatter.timeStyle = .medium
print("Formatted date: \(dateFormatter.string(from: now))")

// Custom date formatting
dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
print("Custom format: \(dateFormatter.string(from: now))")

// ISO 8601 formatting
let isoFormatter = ISO8601DateFormatter()
print("ISO 8601 format: \(isoFormatter.string(from: now))")

// Date components
let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
print("Components - Year: \(components.year!), Month: \(components.month!), Day: \(components.day!)")

// Creating specific dates
let specificDate = calendar.date(from: DateComponents(year: 2024, month: 12, day: 25, hour: 9, minute: 0))!
print("Christmas 2024: \(dateFormatter.string(from: specificDate))")

// Date calculations
let tomorrow = calendar.date(byAdding: .day, value: 1, to: now)!
let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: now)!
let daysBetween = calendar.dateComponents([.day], from: now, to: specificDate).day!

print("Tomorrow: \(dateFormatter.string(from: tomorrow))")
print("Next week: \(dateFormatter.string(from: nextWeek))")
print("Days until Christmas: \(daysBetween)")

// Time intervals
let timeInterval = specificDate.timeIntervalSince(now)
let days = timeInterval / (24 * 60 * 60)
print("Time interval: \(String(format: "%.2f", days)) days")
print()

// MARK: - URL and URLComponents
print("2. URL Handling")

// Basic URL creation
let basicURL = URL(string: "https://www.example.com/path/to/resource")!
print("Basic URL: \(basicURL)")
print("Scheme: \(basicURL.scheme ?? "none")")
print("Host: \(basicURL.host ?? "none")")
print("Path: \(basicURL.path)")

// URL with query parameters
var urlComponents = URLComponents(string: "https://api.example.com/search")!
urlComponents.queryItems = [
    URLQueryItem(name: "q", value: "swift programming"),
    URLQueryItem(name: "limit", value: "10"),
    URLQueryItem(name: "sort", value: "relevance")
]

let searchURL = urlComponents.url!
print("Search URL: \(searchURL)")

// URL manipulation
let baseURL = URL(string: "https://api.example.com/")!
let endpointURL = baseURL.appendingPathComponent("users")
let userURL = endpointURL.appendingPathComponent("123")
let profileURL = userURL.appendingPathExtension("json")

print("Base URL: \(baseURL)")
print("User profile URL: \(profileURL)")

// File URLs
let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let tempFileURL = documentsPath.appendingPathComponent("temp.txt")
print("Documents directory: \(documentsPath)")
print("Temp file URL: \(tempFileURL)")
print()

// MARK: - JSON Handling
print("3. JSON Processing")

// Sample data structure
struct User: Codable {
    let id: Int
    let name: String
    let email: String
    let isActive: Bool
    let preferences: UserPreferences
    
    struct UserPreferences: Codable {
        let theme: String
        let notifications: Bool
        let language: String
    }
}

let sampleUser = User(
    id: 1,
    name: "John Doe",
    email: "john@example.com",
    isActive: true,
    preferences: User.UserPreferences(
        theme: "dark",
        notifications: true,
        language: "en"
    )
)

// Encoding to JSON
let encoder = JSONEncoder()
encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

do {
    let jsonData = try encoder.encode(sampleUser)
    let jsonString = String(data: jsonData, encoding: .utf8)!
    print("Encoded JSON:")
    print(jsonString)
    
    // Decoding from JSON
    let decoder = JSONDecoder()
    let decodedUser = try decoder.decode(User.self, from: jsonData)
    print("Decoded user: \(decodedUser.name) (\(decodedUser.email))")
    print("Theme preference: \(decodedUser.preferences.theme)")
    
} catch {
    print("JSON error: \(error)")
}

// Working with raw JSON
let rawJsonString = """
{
    "users": [
        {"name": "Alice", "age": 25},
        {"name": "Bob", "age": 30},
        {"name": "Charlie", "age": 35}
    ],
    "total": 3
}
"""

if let jsonData = rawJsonString.data(using: .utf8),
   let jsonObject = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
    
    print("Raw JSON parsing:")
    print("Total users: \(jsonObject["total"] ?? 0)")
    
    if let users = jsonObject["users"] as? [[String: Any]] {
        for user in users {
            let name = user["name"] as? String ?? "Unknown"
            let age = user["age"] as? Int ?? 0
            print("User: \(name), Age: \(age)")
        }
    }
}
print()

// MARK: - String Processing and Localization
print("4. String Processing")

let sampleText = "  The Quick Brown Fox Jumps Over The Lazy Dog  "
print("Original: '\(sampleText)'")

// String cleaning
let trimmed = sampleText.trimmingCharacters(in: .whitespacesAndNewlines)
let lowercased = trimmed.lowercased()
let capitalized = trimmed.capitalized

print("Trimmed: '\(trimmed)'")
print("Lowercased: '\(lowercased)'")
print("Capitalized: '\(capitalized)'")

// String searching and replacing
let searchTerm = "fox"
let containsFox = sampleText.localizedCaseInsensitiveContains(searchTerm)
let replaced = sampleText.replacingOccurrences(of: "fox", with: "cat", options: .caseInsensitive)

print("Contains 'fox': \(containsFox)")
print("Replaced: '\(replaced.trimmingCharacters(in: .whitespacesAndNewlines))'")

// Regular expressions
let emailPattern = #"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}"#
let emailText = "Contact us at support@example.com or sales@company.org"

do {
    let regex = try NSRegularExpression(pattern: emailPattern)
    let matches = regex.matches(in: emailText, range: NSRange(emailText.startIndex..., in: emailText))
    
    print("Email addresses found:")
    for match in matches {
        let range = Range(match.range, in: emailText)!
        print("- \(emailText[range])")
    }
} catch {
    print("Regex error: \(error)")
}

// String comparison
let string1 = "café"
let string2 = "cafe"
let literalComparison = string1 == string2
let diacriticInsensitive = string1.compare(string2, options: .diacriticInsensitive) == .orderedSame

print("Literal comparison '\(string1)' == '\(string2)': \(literalComparison)")
print("Diacritic insensitive: \(diacriticInsensitive)")
print()

// MARK: - File System Operations
print("5. FileManager Operations")

let fileManager = FileManager.default
let tempDir = fileManager.temporaryDirectory

print("Temporary directory: \(tempDir.path)")

// Create a test file
let testFileURL = tempDir.appendingPathComponent("test_file.txt")
let testContent = "Hello, Swift FileManager!\nThis is a test file."

do {
    // Write file
    try testContent.write(to: testFileURL, atomically: true, encoding: .utf8)
    print("Created test file: \(testFileURL.lastPathComponent)")
    
    // Check if file exists
    let fileExists = fileManager.fileExists(atPath: testFileURL.path)
    print("File exists: \(fileExists)")
    
    // Get file attributes
    let attributes = try fileManager.attributesOfItem(atPath: testFileURL.path)
    let fileSize = attributes[.size] as? Int ?? 0
    let creationDate = attributes[.creationDate] as? Date
    
    print("File size: \(fileSize) bytes")
    if let date = creationDate {
        print("Created: \(dateFormatter.string(from: date))")
    }
    
    // Read file content
    let readContent = try String(contentsOf: testFileURL, encoding: .utf8)
    print("File content:")
    print(readContent)
    
    // List directory contents
    let contents = try fileManager.contentsOfDirectory(at: tempDir, includingPropertiesForKeys: [.fileSizeKey])
    print("Temp directory contents (\(contents.count) items):")
    for url in contents.prefix(5) {
        print("- \(url.lastPathComponent)")
    }
    
    // Clean up
    try fileManager.removeItem(at: testFileURL)
    print("Cleaned up test file")
    
} catch {
    print("File operation error: \(error)")
}
print()

// MARK: - Data and Base64
print("6. Data Processing")

let originalString = "Hello, Swift Data Processing! 🚀"
let stringData = originalString.data(using: .utf8)!

print("Original string: \(originalString)")
print("Data size: \(stringData.count) bytes")

// Base64 encoding
let base64Encoded = stringData.base64EncodedString()
print("Base64 encoded: \(base64Encoded)")

// Base64 decoding
if let decodedData = Data(base64Encoded: base64Encoded),
   let decodedString = String(data: decodedData, encoding: .utf8) {
    print("Base64 decoded: \(decodedString)")
}

// Data manipulation
var mutableData = Data(originalString.utf8)
mutableData.append(" Additional text.".data(using: .utf8)!)

if let finalString = String(data: mutableData, encoding: .utf8) {
    print("Modified data: \(finalString)")
}

// Hexadecimal representation
let hexString = stringData.map { String(format: "%02x", $0) }.joined()
print("Hex representation: \(hexString)")
print()

// MARK: - UserDefaults
print("7. UserDefaults")

let defaults = UserDefaults.standard

// Store various types
defaults.set("John Doe", forKey: "username")
defaults.set(42, forKey: "userAge")
defaults.set(true, forKey: "isFirstLaunch")
defaults.set(["Swift", "iOS", "macOS"], forKey: "technologies")

// Retrieve values
let username = defaults.string(forKey: "username") ?? "Unknown"
let userAge = defaults.integer(forKey: "userAge")
let isFirstLaunch = defaults.bool(forKey: "isFirstLaunch")
let technologies = defaults.stringArray(forKey: "technologies") ?? []

print("Username: \(username)")
print("User age: \(userAge)")
print("First launch: \(isFirstLaunch)")
print("Technologies: \(technologies)")

// Remove value
defaults.removeObject(forKey: "isFirstLaunch")
let removedValue = defaults.bool(forKey: "isFirstLaunch") // Returns false (default)
print("After removal, isFirstLaunch: \(removedValue)")

// Synchronize (force write to disk)
defaults.synchronize()
print("UserDefaults synchronized")

print("\n=== Foundation and Core Libraries Complete ===") 