# 🌍 Global Claude Configuration

> These rules apply to ALL projects unless explicitly overridden by project-specific configurations.

## Core Principles

1. **Code Quality First**
   - Write clean, maintainable, and well-documented code
   - Follow SOLID principles and design patterns
   - Prioritize readability over cleverness

2. **Security by Default**
   - Never commit secrets or credentials
   - Validate all inputs
   - Follow OWASP security guidelines
   - Use environment variables for configuration

3. **Test-Driven Development**
   - Write tests for new features
   - Maintain minimum 80% code coverage
   - Include unit, integration, and e2e tests where appropriate

4. **Documentation**
   - Document code purpose, not implementation
   - Keep README files up to date
   - Include examples in documentation
   - Document architectural decisions

## Development Standards

### Git Workflow
- Use conventional commits: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`
- Branch naming: `feature/`, `bugfix/`, `hotfix/`, `release/`
- Always create pull requests for code review
- Squash commits when merging to main

### Code Style
- Use consistent formatting (Prettier/Black/gofmt)
- Maximum line length: 100 characters
- Use meaningful variable and function names
- Prefer composition over inheritance

### Error Handling
- Always handle errors explicitly
- Log errors with context
- Provide user-friendly error messages
- Implement retry logic for transient failures

## Technology Preferences

### Frontend
- **Preferred**: React with TypeScript
- **Styling**: Tailwind CSS or CSS Modules
- **State**: Context API for simple, Redux Toolkit for complex
- **Testing**: Jest + React Testing Library

### Backend
- **Node.js**: Express or Fastify with TypeScript
- **Python**: FastAPI or Django
- **Go**: Gin or Echo framework
- **Database**: PostgreSQL (default), MongoDB (when needed)

### DevOps
- **Containers**: Docker for all deployments
- **CI/CD**: GitHub Actions
- **Monitoring**: Structured logging (JSON)
- **Infrastructure**: Infrastructure as Code (Terraform/CloudFormation)

## MCP Server Usage

### Always Available
- Filesystem access (restricted to workspace and projects)
- GitHub integration (for version control operations)
- Documentation servers (for reference)

### Project-Specific
- Database connections (per-project configuration)
- API integrations (as needed)
- Cloud services (AWS, GCP, Azure as required)

## AI Assistance Guidelines

1. **Proactive Assistance**
   - Suggest improvements when you see anti-patterns
   - Offer to write tests for new code
   - Recommend security enhancements
   - Identify performance optimizations

2. **Learning & Adaptation**
   - Learn from project-specific patterns
   - Adapt to team conventions
   - Remember previous decisions
   - Build on existing code style

3. **Communication**
   - Be concise but complete
   - Explain complex changes
   - Ask for clarification when needed
   - Provide rationale for suggestions

## Project Initialization Defaults

When creating new projects:
1. Initialize git repository
2. Create comprehensive .gitignore
3. Set up basic CI/CD pipeline
4. Include LICENSE file
5. Create README with standard sections
6. Set up testing framework
7. Configure linting and formatting
8. Create basic project structure

## Performance Standards

- **Page Load**: < 3 seconds
- **API Response**: < 500ms for standard queries
- **Build Time**: < 5 minutes for CI/CD
- **Test Execution**: < 2 minutes for unit tests

## Accessibility Requirements

- WCAG 2.1 Level AA compliance
- Semantic HTML usage
- Keyboard navigation support
- Screen reader compatibility
- Proper ARIA labels

---

*These global rules can be overridden by project-specific configurations in `projects/[project-name]/claude/CLAUDE.md`*