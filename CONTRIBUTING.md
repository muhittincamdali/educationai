# Contributing to EducationAI

Thank you for your interest in contributing to EducationAI! This document provides guidelines and information for contributors.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)
- [Release Process](#release-process)

## Code of Conduct

This project adheres to the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## Getting Started

### Prerequisites
- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+
- Git

### Fork and Clone
1. Fork the repository
2. Clone your fork locally
3. Add the original repository as upstream

```bash
git clone https://github.com/your-username/educationai.git
cd educationai
git remote add upstream https://github.com/original-org/educationai.git
```

## Development Setup

### 1. Environment Setup
```bash
# Install dependencies
swift package resolve

# Build the project
swift build

# Run tests
swift test
```

### 2. Xcode Setup
1. Open `Package.swift` in Xcode (File > Open... > select `Package.swift`)
2. Select your target device / scheme
3. Build and run tests

### 3. Pre-commit Hooks
```bash
# Install SwiftLint
brew install swiftlint

# Run linting
swiftlint lint
```

## Coding Standards

### Swift Style Guide
We follow the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/) and [Google Swift Style Guide](https://google.github.io/swift/).

### Key Principles
- **Clean Architecture**: Follow Clean Architecture principles
- **SOLID Principles**: Apply SOLID design principles
- **Testability**: Write testable code
- **Documentation**: Document public APIs
- **Performance**: Consider performance implications

### Code Formatting
```swift
// ✅ Good
public struct User {
    public let id: UUID
    public var name: String
    public var email: String
    
    public init(id: UUID, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
}

// ❌ Bad
public struct User{
    public let id:UUID
    public var name:String
    public var email:String
    public init(id:UUID,name:String,email:String){
        self.id=id
        self.name=name
        self.email=email
    }
}
```

### Naming Conventions
- **Types**: PascalCase (`User`, `CourseRepository`)
- **Properties**: camelCase (`userName`, `courseId`)
- **Functions**: camelCase (`getUser()`, `createCourse()`)
- **Constants**: camelCase (`maxRetryCount`, `defaultTimeout`)

### Documentation
```swift
/// Represents a user in the EducationAI system.
///
/// A user contains personal information, learning progress,
/// and preferences for the AI-driven learning experience.
public struct User: Codable, Identifiable {
    /// Unique identifier for the user
    public let id: UUID
    
    /// User's display name
    public var name: String
    
    /// User's email address
    public var email: String
    
    /// User's learning progress and achievements
    public var progress: UserProgress
    
    /// Creates a new user with the specified information.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the user
    ///   - name: User's display name
    ///   - email: User's email address
    ///   - progress: User's learning progress
    public init(id: UUID, name: String, email: String, progress: UserProgress) {
        self.id = id
        self.name = name
        self.email = email
        self.progress = progress
    }
}
```

## Testing

### Test Structure
```
Tests/
├── EducationAITests/
│   ├── Domain/
│   │   ├── Entities/
│   │   ├── UseCases/
│   │   └── Repositories/
│   ├── Infrastructure/
│   │   ├── AI/
│   │   ├── Security/
│   │   └── Services/
│   └── App/
└── EducationAIUITests/
    ├── Authentication/
    ├── Learning/
    └── Profile/
```

### Test Guidelines
- **Unit Tests**: Test individual components in isolation
- **Integration Tests**: Test component interactions
- **UI Tests**: Test user interface flows
- **Performance Tests**: Test performance characteristics

### Test Examples
```swift
import XCTest
@testable import EducationAI

final class UserTests: XCTestCase {
    
    func testUserInitialization() {
        // Given
        let id = UUID()
        let name = "John Doe"
        let email = "john@example.com"
        let progress = UserProgress()
        
        // When
        let user = User(id: id, name: name, email: email, progress: progress)
        
        // Then
        XCTAssertEqual(user.id, id)
        XCTAssertEqual(user.name, name)
        XCTAssertEqual(user.email, email)
        XCTAssertEqual(user.progress, progress)
    }
    
    func testUserCodable() throws {
        // Given
        let user = User(
            id: UUID(),
            name: "Jane Doe",
            email: "jane@example.com",
            progress: UserProgress()
        )
        
        // When
        let data = try JSONEncoder().encode(user)
        let decodedUser = try JSONDecoder().decode(User.self, from: data)
        
        // Then
        XCTAssertEqual(user, decodedUser)
    }
}
```

## Pull Request Process

### 1. Create Feature Branch
```bash
git checkout -b feature/your-feature-name
```

### 2. Make Changes
- Write code following our standards
- Add comprehensive tests
- Update documentation
- Update CHANGELOG.md

### 3. Commit Messages
Use conventional commit format:
```
feat: add user authentication
fix: resolve memory leak in AI service
docs: update API documentation
test: add unit tests for user model
refactor: improve code organization
```

### 4. Submit Pull Request
1. Push your branch
2. Create pull request
3. Fill out the PR template
4. Request review

### PR Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] UI tests added/updated
- [ ] All tests pass

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] CHANGELOG updated
```

## Release Process

### 1. Version Bumping
```bash
# Update version in Package.swift
# Update CHANGELOG.md
# Create release branch
git checkout -b release/v1.0.0
```

### 2. Testing
- Run full test suite
- Perform integration testing
- Test on multiple devices
- Security review

### 3. Release
- Merge to main branch
- Create GitHub release
- Tag the release
- Deploy to App Store

## Communication

### Issues
- Use GitHub Issues for bug reports
- Use GitHub Discussions for questions
- Follow issue templates

### Community
- Join our Discord server
- Participate in discussions
- Share ideas and feedback

## Recognition

### Contributors
- All contributors are listed in [CONTRIBUTORS.md](CONTRIBUTORS.md)
- Significant contributions are highlighted in releases

### Hall of Fame
- Top contributors are featured in our documentation
- Special recognition for major features

## Questions?

If you have questions about contributing:
- Check our [FAQ](Documentation/FAQ.md)
- Open a GitHub Discussion
- Contact the maintainers

Thank you for contributing to EducationAI! 🚀 