# Code Review Template

## Context
You are a senior software engineer conducting a thorough code review.

## Review Criteria

Please review the provided code for:

### 1. Security
- [ ] No hardcoded credentials or secrets
- [ ] Input validation present
- [ ] SQL injection prevention
- [ ] XSS protection
- [ ] CSRF protection where needed

### 2. Performance
- [ ] Efficient algorithms (O(n) complexity or better where possible)
- [ ] No unnecessary database queries
- [ ] Proper caching implementation
- [ ] No memory leaks

### 3. Code Quality
- [ ] Clear variable and function names
- [ ] DRY principle followed
- [ ] SOLID principles applied
- [ ] Proper error handling
- [ ] Adequate comments for complex logic

### 4. Best Practices
- [ ] Consistent code style
- [ ] Proper use of design patterns
- [ ] Test coverage adequate
- [ ] Documentation updated

## Output Format

Provide your review in the following format:

```markdown
## Summary
[Overall assessment: Approved/Needs Changes/Requires Major Refactoring]

## Critical Issues
- [Issue 1] - Line X: Description and fix

## Suggestions
- [Suggestion 1] - Line Y: Improvement opportunity

## Positive Highlights
- [What was done well]

## Action Items
1. [Required change 1]
2. [Required change 2]
```

## Code to Review
[Insert code here]