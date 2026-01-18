# 🔧 Technology Stack Standards

## Frontend Stacks

### React TypeScript (Preferred)
```json
{
  "framework": "React 18+",
  "language": "TypeScript 5+",
  "build": "Vite",
  "styling": "Tailwind CSS",
  "state": "Zustand / Redux Toolkit",
  "routing": "React Router v6",
  "testing": "Vitest + React Testing Library",
  "components": "Radix UI / Shadcn"
}
```

### Next.js Full-Stack
```json
{
  "framework": "Next.js 14+",
  "language": "TypeScript",
  "styling": "Tailwind CSS + CSS Modules",
  "database": "Prisma + PostgreSQL",
  "auth": "NextAuth.js",
  "deployment": "Vercel / Docker"
}
```

### Vue Alternative
```json
{
  "framework": "Vue 3",
  "language": "TypeScript",
  "build": "Vite",
  "state": "Pinia",
  "ui": "Vuetify / Element Plus"
}
```

## Backend Stacks

### Node.js TypeScript
```json
{
  "runtime": "Node.js 20 LTS",
  "language": "TypeScript",
  "framework": "Express / Fastify",
  "orm": "Prisma / TypeORM",
  "validation": "Zod",
  "testing": "Jest / Vitest",
  "api": "REST / GraphQL (Apollo)"
}
```

### Python FastAPI
```json
{
  "version": "Python 3.11+",
  "framework": "FastAPI",
  "orm": "SQLAlchemy 2.0",
  "validation": "Pydantic v2",
  "testing": "Pytest",
  "async": "asyncio + aiohttp"
}
```

### Go Services
```json
{
  "version": "Go 1.21+",
  "framework": "Gin / Fiber",
  "database": "sqlx / gorm",
  "testing": "testify",
  "tools": "golangci-lint"
}
```

## Database Selection

### Primary Database
- **PostgreSQL 15+**: Default for relational data
- **Connections**: PgBouncer for pooling
- **Migrations**: Prisma / Alembic / golang-migrate

### Secondary Stores
- **Redis**: Caching, sessions, queues
- **MongoDB**: Document storage (when needed)
- **ElasticSearch**: Full-text search
- **S3-compatible**: Object storage

## DevOps & Infrastructure

### Containerization
```dockerfile
# Multi-stage builds
FROM node:20-alpine AS builder
# ... build steps
FROM node:20-alpine AS runtime
# ... runtime only
```

### CI/CD Pipeline
```yaml
# GitHub Actions
- Test (unit, integration)
- Lint & Format check
- Security scan
- Build & Push image
- Deploy to staging
- Smoke tests
- Deploy to production
```

### Monitoring Stack
- **Logs**: JSON structured logging
- **Metrics**: Prometheus + Grafana
- **Tracing**: OpenTelemetry
- **Errors**: Sentry

## Development Tools

### Required Tools
```bash
# Version managers
nvm / fnm          # Node.js
pyenv             # Python
g                 # Go versions

# Package managers
pnpm              # Preferred for Node.js
poetry            # Python projects
go mod            # Go modules

# Code quality
prettier          # Formatting
eslint            # JS/TS linting
black             # Python formatting
golangci-lint     # Go linting
```

### IDE Setup
```json
{
  "editor": "VSCode / Cursor",
  "extensions": [
    "Prettier",
    "ESLint",
    "TypeScript",
    "Tailwind IntelliSense",
    "GitLens",
    "Docker",
    "Error Lens"
  ]
}
```

## API Standards

### RESTful Design
```
GET    /api/v1/resources       # List
GET    /api/v1/resources/:id   # Get one
POST   /api/v1/resources       # Create
PUT    /api/v1/resources/:id   # Update
DELETE /api/v1/resources/:id   # Delete
```

### Response Format
```json
{
  "success": true,
  "data": {},
  "meta": {
    "timestamp": "2024-01-17T10:00:00Z",
    "version": "1.0.0"
  },
  "errors": []
}
```

### Error Format
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "User-friendly message",
    "details": {}
  }
}
```

## Security Requirements

### Authentication
- JWT with refresh tokens
- OAuth2 for social login
- MFA support
- Session management

### API Security
- Rate limiting
- CORS configuration
- Input validation
- SQL injection prevention
- XSS protection

## Performance Targets

### Frontend
- Lighthouse score > 90
- First Contentful Paint < 1.5s
- Time to Interactive < 3s
- Bundle size < 500KB (initial)

### Backend
- Response time p95 < 500ms
- Throughput > 1000 req/s
- Database queries < 100ms
- Memory usage < 512MB

## Testing Standards

### Coverage Requirements
- Unit tests: 80% minimum
- Integration tests: Critical paths
- E2E tests: User journeys

### Test Structure
```
tests/
├── unit/           # Isolated tests
├── integration/    # Component integration
├── e2e/           # End-to-end
└── fixtures/      # Test data
```

## Documentation Requirements

### Code Documentation
- JSDoc for public APIs
- README in each module
- Architecture Decision Records
- API documentation (OpenAPI/Swagger)

### Project Documentation
```
docs/
├── architecture/   # System design
├── api/           # API reference
├── guides/        # How-to guides
└── deployment/    # Deploy instructions
```

---

*Select appropriate stack based on project requirements. These are defaults that can be overridden.*