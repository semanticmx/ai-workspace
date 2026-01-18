# Knowledge Directory

Central repository for research, code snippets, and resources.

## Structure

- **research/** - Research notes, findings, and explorations
- **snippets/** - Reusable code snippets and examples
- **resources/** - Links, tools, libraries, and external resources

## Organization Tips

### Research
Organize by topic or technology:
- `machine-learning/`
- `web-development/`
- `cloud-architecture/`

### Snippets
Organize by language or purpose:
- `python/`
- `javascript/`
- `bash/`
- `algorithms/`

### Resources
Categorize by type:
- `tools.md` - Development tools
- `libraries.md` - Useful libraries
- `learning.md` - Learning resources
- `apis.md` - API references

## File Examples

### Research Note (research/topic.md)
```markdown
# Research: [Topic]
Date: 2024-01-17

## Summary
Key findings and insights

## Sources
- [Article 1](link)
- [Paper 2](link)

## Key Points
1. Important finding 1
2. Important finding 2

## Applications
How this applies to current projects

## Further Questions
- Question 1
- Question 2
```

### Code Snippet (snippets/python/async-example.py)
```python
# Async HTTP Request Example
# Use case: Fetching multiple URLs concurrently

import asyncio
import aiohttp

async def fetch(session, url):
    async with session.get(url) as response:
        return await response.text()

async def main():
    urls = ['http://example.com', 'http://example.org']
    async with aiohttp.ClientSession() as session:
        results = await asyncio.gather(*[fetch(session, url) for url in urls])
    return results
```

### Resources List (resources/tools.md)
```markdown
# Development Tools

## Editors
- VSCode - Primary code editor
- Neovim - Terminal editor

## Version Control
- Git - Version control
- GitHub CLI - Command line interface

## AI Tools
- Claude - AI assistant
- GitHub Copilot - Code completion
```