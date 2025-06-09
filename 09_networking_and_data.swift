#!/usr/bin/env swift

// MARK: - Networking and Data Playground
// Exploring networking, async data operations, and data transformation

import Foundation

print("=== Networking and Data Playground ===\n")

// MARK: - Mock Network Service
print("1. Mock Network Service")

// Mock data structures
struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let error: String?
}

struct Post: Codable, CustomStringConvertible {
    let id: Int
    let title: String
    let body: String
    let userId: Int
    
    var description: String {
        return "Post \(id): \(title)"
    }
}

struct User: Codable, CustomStringConvertible {
    let id: Int
    let name: String
    let email: String
    let website: String?
    
    var description: String {
        return "\(name) (\(email))"
    }
}

// Mock network service
class MockNetworkService {
    static let shared = MockNetworkService()
    
    private let mockPosts = [
        Post(id: 1, title: "Swift Concurrency", body: "Exploring async/await in Swift", userId: 1),
        Post(id: 2, title: "Protocol-Oriented Programming", body: "Building flexible APIs with protocols", userId: 1),
        Post(id: 3, title: "SwiftUI Fundamentals", body: "Creating beautiful UIs with SwiftUI", userId: 2)
    ]
    
    private let mockUsers = [
        User(id: 1, name: "John Developer", email: "john@dev.com", website: "johndev.com"),
        User(id: 2, name: "Jane Designer", email: "jane@design.com", website: nil)
    ]
    
    // Simulate network delay
    private func simulateNetworkDelay() async {
        let delay = Double.random(in: 0.1...0.5)
        try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
    }
    
    func fetchPosts() async throws -> [Post] {
        await simulateNetworkDelay()
        
        // Simulate occasional network errors
        if Bool.random() && Double.random(in: 0...1) < 0.1 {
            throw URLError(.networkConnectionLost)
        }
        
        return mockPosts
    }
    
    func fetchUser(id: Int) async throws -> User? {
        await simulateNetworkDelay()
        return mockUsers.first { $0.id == id }
    }
    
    func createPost(title: String, body: String, userId: Int) async throws -> Post {
        await simulateNetworkDelay()
        
        let newId = (mockPosts.map { $0.id }.max() ?? 0) + 1
        return Post(id: newId, title: title, body: body, userId: userId)
    }
}

// Basic networking examples
Task {
    do {
        print("Fetching posts...")
        let posts = try await MockNetworkService.shared.fetchPosts()
        print("Fetched \(posts.count) posts:")
        for post in posts {
            print("  - \(post)")
        }
        
        if let firstPost = posts.first {
            print("\nFetching user for first post...")
            if let user = try await MockNetworkService.shared.fetchUser(id: firstPost.userId) {
                print("Post author: \(user)")
            }
        }
    } catch {
        print("Network error: \(error)")
    }
}

// Wait for async operations
try? await Task.sleep(nanoseconds: 1_000_000_000)
print()

// MARK: - Concurrent Network Requests
print("2. Concurrent Network Operations")

// Sequential vs concurrent data fetching
Task {
    // Sequential approach
    print("Sequential approach:")
    let sequentialStart = Date()
    var allUsers: [User] = []
    
    for userId in 1...2 {
        if let user = try? await MockNetworkService.shared.fetchUser(id: userId) {
            allUsers.append(user)
        }
    }
    
    let sequentialTime = Date().timeIntervalSince(sequentialStart)
    print("Sequential fetching took: \(String(format: "%.2f", sequentialTime))s")
    print("Users: \(allUsers.map { $0.name })")
    
    // Concurrent approach using async let
    print("\nConcurrent approach (async let):")
    let concurrentStart = Date()
    
    async let user1 = MockNetworkService.shared.fetchUser(id: 1)
    async let user2 = MockNetworkService.shared.fetchUser(id: 2)
    
    let concurrentUsers = try? await [user1, user2].compactMap { $0 }
    let concurrentTime = Date().timeIntervalSince(concurrentStart)
    
    print("Concurrent fetching took: \(String(format: "%.2f", concurrentTime))s")
    if let users = concurrentUsers {
        print("Users: \(users.map { $0.name })")
    }
    
    let improvement = sequentialTime / concurrentTime
    print("Performance improvement: \(String(format: "%.1f", improvement))x faster")
}

try? await Task.sleep(nanoseconds: 2_000_000_000)
print()

// MARK: - Task Groups for Multiple Requests
print("3. Task Groups for Batch Operations")

Task {
    let userIds = [1, 2, 1, 2, 1] // Intentionally include duplicates
    
    let users = await withTaskGroup(of: User?.self) { group in
        var results: [User] = []
        
        for userId in userIds {
            group.addTask {
                try? await MockNetworkService.shared.fetchUser(id: userId)
            }
        }
        
        for await user in group {
            if let user = user {
                results.append(user)
            }
        }
        
        return results
    }
    
    print("Batch fetched \(users.count) users:")
    for user in users {
        print("  - \(user)")
    }
    
    // Remove duplicates
    let uniqueUsers = Array(Set(users.map { $0.id })).compactMap { id in
        users.first { $0.id == id }
    }
    print("Unique users: \(uniqueUsers.count)")
}

try? await Task.sleep(nanoseconds: 1_000_000_000)
print()

// MARK: - Error Handling and Retry Logic
print("4. Error Handling and Retry Patterns")

func fetchWithRetry<T>(
    maxAttempts: Int = 3,
    delay: TimeInterval = 1.0,
    operation: @escaping () async throws -> T
) async throws -> T {
    var lastError: Error?
    
    for attempt in 1...maxAttempts {
        do {
            return try await operation()
        } catch {
            lastError = error
            print("Attempt \(attempt) failed: \(error)")
            
            if attempt < maxAttempts {
                print("Retrying in \(delay) seconds...")
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
        }
    }
    
    throw lastError ?? URLError(.unknown)
}

Task {
    do {
        let posts = try await fetchWithRetry(maxAttempts: 3) {
            try await MockNetworkService.shared.fetchPosts()
        }
        print("Successfully fetched \(posts.count) posts with retry logic")
    } catch {
        print("Failed after all retry attempts: \(error)")
    }
}

try? await Task.sleep(nanoseconds: 1_500_000_000)
print()

// MARK: - Data Transformation and Processing
print("5. Data Transformation Pipeline")

// Data transformation pipeline
struct PostSummary {
    let id: Int
    let title: String
    let authorName: String
    let wordCount: Int
}

func createPostSummaries() async -> [PostSummary] {
    do {
        let posts = try await MockNetworkService.shared.fetchPosts()
        
        // Transform posts to summaries concurrently
        return await withTaskGroup(of: PostSummary?.self) { group in
            var summaries: [PostSummary] = []
            
            for post in posts {
                group.addTask {
                    guard let user = try? await MockNetworkService.shared.fetchUser(id: post.userId) else {
                        return nil
                    }
                    
                    let wordCount = post.body.components(separatedBy: .whitespacesAndNewlines)
                        .filter { !$0.isEmpty }.count
                    
                    return PostSummary(
                        id: post.id,
                        title: post.title,
                        authorName: user.name,
                        wordCount: wordCount
                    )
                }
            }
            
            for await summary in group {
                if let summary = summary {
                    summaries.append(summary)
                }
            }
            
            return summaries.sorted { $0.id < $1.id }
        }
    } catch {
        print("Error creating summaries: \(error)")
        return []
    }
}

Task {
    let summaries = await createPostSummaries()
    print("Post summaries:")
    for summary in summaries {
        print("  - \(summary.title) by \(summary.authorName) (\(summary.wordCount) words)")
    }
}

try? await Task.sleep(nanoseconds: 2_000_000_000)
print()

// MARK: - JSON Processing with Custom Decoding
print("6. Advanced JSON Processing")

// Custom date formatting
let customDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}()

struct Article: Codable {
    let id: Int
    let title: String
    let content: String
    let publishedAt: Date
    let tags: [String]
    let isPublished: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, title, content, tags
        case publishedAt = "published_at"
        case isPublished = "is_published"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        content = try container.decode(String.self, forKey: .content)
        tags = try container.decode([String].self, forKey: .tags)
        isPublished = try container.decode(Bool.self, forKey: .isPublished)
        
        // Custom date decoding
        let dateString = try container.decode(String.self, forKey: .publishedAt)
        guard let date = customDateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .publishedAt, in: container, debugDescription: "Invalid date format")
        }
        publishedAt = date
    }
}

let articleJSON = """
{
    "id": 1,
    "title": "Swift Networking Best Practices",
    "content": "In this article, we explore modern Swift networking...",
    "published_at": "2024-01-15T10:30:00Z",
    "tags": ["swift", "networking", "async"],
    "is_published": true
}
"""

if let jsonData = articleJSON.data(using: .utf8) {
    do {
        let article = try JSONDecoder().decode(Article.self, from: jsonData)
        print("Decoded article:")
        print("  Title: \(article.title)")
        print("  Published: \(customDateFormatter.string(from: article.publishedAt))")
        print("  Tags: \(article.tags.joined(separator: ", "))")
        print("  Is published: \(article.isPublished)")
    } catch {
        print("JSON decoding error: \(error)")
    }
}
print()

// MARK: - Data Caching Strategy
print("7. Simple Data Caching")

actor DataCache<Key: Hashable, Value> {
    private var cache: [Key: (value: Value, timestamp: Date)] = [:]
    private let ttl: TimeInterval
    
    init(timeToLive: TimeInterval = 300) { // 5 minutes default
        self.ttl = timeToLive
    }
    
    func get(_ key: Key) -> Value? {
        guard let entry = cache[key] else { return nil }
        
        if Date().timeIntervalSince(entry.timestamp) > ttl {
            cache.removeValue(forKey: key)
            return nil
        }
        
        return entry.value
    }
    
    func set(_ key: Key, value: Value) {
        cache[key] = (value: value, timestamp: Date())
    }
    
    func clear() {
        cache.removeAll()
    }
    
    var count: Int {
        return cache.count
    }
}

class CachedNetworkService {
    private let cache = DataCache<String, [Post]>(timeToLive: 30) // 30 seconds TTL
    private let networkService = MockNetworkService.shared
    
    func fetchPosts(useCache: Bool = true) async throws -> [Post] {
        let cacheKey = "posts"
        
        if useCache, let cachedPosts = await cache.get(cacheKey) {
            print("Returning cached posts")
            return cachedPosts
        }
        
        print("Fetching fresh posts from network")
        let posts = try await networkService.fetchPosts()
        await cache.set(cacheKey, value: posts)
        
        return posts
    }
}

Task {
    let cachedService = CachedNetworkService()
    
    // First request - will fetch from network
    let posts1 = try? await cachedService.fetchPosts()
    print("First request: \(posts1?.count ?? 0) posts")
    
    // Second request - should use cache
    let posts2 = try? await cachedService.fetchPosts()
    print("Second request: \(posts2?.count ?? 0) posts")
    
    // Third request without cache
    let posts3 = try? await cachedService.fetchPosts(useCache: false)
    print("Third request (no cache): \(posts3?.count ?? 0) posts")
}

try? await Task.sleep(nanoseconds: 1_000_000_000)

print("\n=== Networking and Data Complete ===") 