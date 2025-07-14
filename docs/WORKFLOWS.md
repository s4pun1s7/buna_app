# CI/CD Workflow Configuration

This document describes the clean CI/CD workflow configuration set up for the Buna Festival App using GitHub Actions.

## Overview

The workflow configuration has been completely cleared and set up cleanly with proper versions:
- **Flutter Version**: 3.24.5 (latest stable)
- **GitHub Actions**: Latest versions (v4 for most actions)
- **Java Version**: 17 (required for modern Android builds)
- **Code Quality**: Comprehensive linting, formatting, and security scanning

## Workflow Files

### 1. CI Workflow (`.github/workflows/ci.yml`)
**Triggers**: Push and PR to `main` and `develop` branches

**Jobs**:
- **Test**: Runs unit tests, formatting checks, and code analysis
- **Integration Test**: Runs integration tests
- **Build Android**: Builds APK and App Bundle for Android
- **Build iOS**: Builds iOS app (no code signing)
- **Build Web**: Builds web version

**Features**:
- Flutter caching for faster builds
- Parallel job execution
- Artifact uploads for builds
- Code coverage reporting with Codecov

### 2. Release Workflow (`.github/workflows/release.yml`)
**Triggers**: Git tags matching `v*.*.*` pattern

**Jobs**:
- **Release**: Creates GitHub release with APK and App Bundle
- **Deploy Web**: Deploys web build to GitHub Pages

**Features**:
- Automated release creation
- Asset uploading
- GitHub Pages deployment
- Release notes generation

### 3. Code Quality Workflow (`.github/workflows/code_quality.yml`)
**Triggers**: Push and PR to `main` and `develop` branches

**Jobs**:
- **Code Quality Checks**: Formatting, analysis, dependency audits
- **Performance Tests**: Performance regression testing

**Features**:
- Strict formatting enforcement
- Security audits
- Dependency health checks
- Performance monitoring

### 4. Security Workflow (`.github/workflows/security.yml`)
**Triggers**: Push, PR, and weekly schedule

**Jobs**:
- **Security Scan**: Dependency vulnerability scanning
- **Dependency Review**: PR dependency review
- **CodeQL**: Static code analysis

**Features**:
- Scheduled security scans
- Dependency vulnerability detection
- Static code analysis with CodeQL
- Security report generation

## Dependency Management

### Dependabot Configuration (`.github/dependabot.yml`)
- **Pub packages**: Weekly updates on Mondays
- **GitHub Actions**: Weekly updates on Mondays
- Automatic PR creation with proper labels
- Code owner assignments

## Project Management

### Issue Templates
- **Bug Report**: Structured bug reporting with device info and reproduction steps
- **Feature Request**: Structured feature requests with priority levels

### Pull Request Template
- Comprehensive checklist for code changes
- Testing requirements
- Documentation requirements
- Breaking change notifications

### Code Owners (`.github/CODEOWNERS`)
- Global ownership by `@s4pun1s7`
- Specific ownership for platform directories
- Workflow configuration protection

## Version Strategy

### Flutter Version
- **Production**: 3.24.5 (latest stable)
- **SDK Compatibility**: >=3.8.0 <4.0.0
- **Rationale**: Latest stable version with good ecosystem support

### Action Versions
- **checkout**: v4 (latest)
- **setup-java**: v4 (latest)
- **subosito/flutter-action**: v2 (latest Flutter-specific)
- **upload-artifact**: v4 (latest)
- **codecov-action**: v4 (latest)

## Security Considerations

### Secrets Used
- `GITHUB_TOKEN`: Automatic token for releases and deployments
- No additional secrets required for basic functionality

### Security Features
- CodeQL static analysis
- Dependency vulnerability scanning
- Automated dependency updates
- Secure artifact handling

## Build Matrix

### Platforms Supported
- **Android**: APK and App Bundle builds
- **iOS**: Build verification (no code signing)
- **Web**: Full web deployment

### Build Optimization
- **Caching**: Flutter SDK and dependencies
- **Parallel Jobs**: Multiple builds run simultaneously
- **Artifact Management**: Structured artifact storage

## Testing Strategy

### Test Types
- **Unit Tests**: Core functionality testing
- **Integration Tests**: End-to-end testing
- **Performance Tests**: Regression detection
- **Security Tests**: Vulnerability scanning

### Coverage
- Code coverage reporting
- Coverage thresholds (configurable)
- Codecov integration

## Deployment

### GitHub Pages
- Automatic web deployment on releases
- Proper base-href configuration
- Static asset optimization

### Release Management
- Semantic versioning with git tags
- Automated release notes
- Asset bundling and upload

## Monitoring and Alerts

### Workflow Monitoring
- Job status notifications
- Failure alerts via GitHub
- Performance metrics tracking

### Dependency Monitoring
- Weekly dependency scans
- Vulnerability alerts
- Update notifications

## Usage Instructions

### First-time Setup
1. Ensure repository has proper permissions for GitHub Actions
2. Configure any required secrets (none needed for basic setup)
3. Push to `main` or `develop` branch to trigger first CI run
4. Monitor Actions tab for workflow execution

### Creating Releases
1. Create and push a git tag: `git tag v1.0.0 && git push origin v1.0.0`
2. Release workflow will automatically create GitHub release
3. Web deployment will occur if tag is on main branch

### Maintaining Workflows
- Dependabot will automatically update action versions
- Review and merge Dependabot PRs regularly
- Monitor workflow runs for any failures

## Best Practices

### Branch Protection
- Require CI checks to pass before merging
- Require PR reviews
- Ensure branch is up to date

### Development Workflow
- Create feature branches from `develop`
- Open PRs to `develop` for features
- Merge to `main` for releases
- Use semantic versioning for tags

### Monitoring
- Regularly check Actions tab for failures
- Review security scan results
- Monitor dependency updates

## Troubleshooting

### Common Issues
- **Flutter version conflicts**: Ensure pubspec.yaml SDK version is compatible
- **Build failures**: Check for missing dependencies or configuration
- **Security alerts**: Review and update vulnerable dependencies
- **Permission errors**: Ensure repository has proper Actions permissions

### Support
- Check GitHub Actions documentation
- Review workflow logs for detailed error messages
- Consult Flutter documentation for platform-specific issues

## Future Enhancements

### Potential Additions
- Fastlane integration for mobile deployment
- Performance benchmarking
- Automated screenshot testing
- Multi-environment deployments
- Advanced security scanning tools

This configuration provides a solid foundation for modern Flutter app development with comprehensive CI/CD, security, and quality assurance.