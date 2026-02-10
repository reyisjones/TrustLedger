# Contributing to TrustLedger

Thank you for your interest in contributing to TrustLedger! This document provides guidelines and information for contributors.

## Code of Conduct

This project follows a code of conduct to ensure a welcoming environment for all contributors. Please read and adhere to our [Code of Conduct](CODE_OF_CONDUCT.md).

## How to Contribute

### 1. Reporting Issues

- Use GitHub Issues to report bugs or request features
- Provide detailed information including steps to reproduce
- Include relevant environment details (OS, Node version, etc.)

### 2. Contributing Code

#### Development Setup
```bash
git clone https://github.com/reyisjones/TrustLedger.git
cd TrustLedger
# Follow setup instructions in README.md
```

#### Development Workflow
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Update documentation if needed
7. Commit with clear, descriptive messages
8. Push to your fork
9. Create a Pull Request

#### Commit Message Guidelines
```
type(scope): description

[optional body]

[optional footer]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance

### 3. Smart Contract Development

#### Requirements
- All contracts must be upgradeable (UUPS pattern)
- Include comprehensive tests (aim for 100% coverage)
- Add formal verification specs for critical contracts
- Follow Solidity security best practices

#### Testing
```bash
cd contracts/evm
forge test
```

#### Formal Verification
```bash
certora run --spec certora/Contract.spec
```

### 4. API Development

#### Guidelines
- Use RESTful conventions
- Include OpenAPI/Swagger documentation
- Add comprehensive error handling
- Include rate limiting for public endpoints

#### Testing
```bash
cd services/api-gateway
npm test
```

### 5. Documentation

- Update README.md for significant changes
- Add code comments for complex logic
- Update API documentation for endpoint changes
- Include examples for new features

## Grant Program

TrustLedger operates a grant program to support community development:

### Grant Categories
- **Core Development**: Smart contract improvements, security enhancements
- **Integration**: Third-party service integrations, API clients
- **Documentation**: Tutorials, guides, translations
- **Research**: Formal verification, security analysis, performance optimization

### Application Process
1. Submit proposal via GitHub Issue with label `grant-proposal`
2. Include detailed scope, timeline, and budget
3. Community discussion and maintainer review
4. Approval and funding allocation

### Grant Milestones
- 25% on proposal acceptance
- 50% on midpoint completion
- 25% on final delivery and testing

## Community Modules

### Module Requirements
- Must follow TrustLedger architectural patterns
- Include comprehensive tests
- Provide clear documentation
- Compatible with current contract versions
- No conflicts with core functionality

### Module Registry
Community modules are listed in the [Module Registry](docs/modules/README.md).

### Publishing a Module
1. Develop and test your module
2. Create a pull request to add to module registry
3. Include installation and usage instructions
4. Maintain compatibility with TrustLedger releases

## Security

### Reporting Security Issues
- **DO NOT** create public GitHub issues for security vulnerabilities
- Email security@trustledger.org with details
- Allow 90 days for fix before public disclosure

### Security Best Practices
- Never commit private keys or secrets
- Use environment variables for configuration
- Follow principle of least privilege
- Regular dependency updates

## Recognition

Contributors are recognized through:
- GitHub contributor statistics
- Mention in release notes
- TrustLedger contributor program
- Grant program participation

## Getting Help

- **Documentation**: Check [docs/](docs/) directory
- **Discussions**: Use GitHub Discussions for questions
- **Discord**: Join our community Discord
- **Issues**: Search existing issues before creating new ones

## License

By contributing to TrustLedger, you agree that your contributions will be licensed under the same license as the project (Apache 2.0).