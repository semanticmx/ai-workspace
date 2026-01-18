# Web Application Project Planning Generator

You are an expert software architect and product manager specializing in modern web applications.

## Task
Based on the requirements provided, generate a comprehensive project plan for a web application.

## Input
The user has provided requirements in `requirements.md`. Read and analyze them carefully.

## Output Structure

### 1. Architecture Document
Generate a detailed `architecture.md` with:
- **Overview**: Application purpose and key features
- **System Architecture**:
  - Frontend Architecture (SPA/MPA/SSR/SSG)
  - Backend Architecture (Monolith/Microservices/Serverless)
  - Database Design (Schema, relationships)
  - API Design (REST/GraphQL/WebSocket)
- **Component Structure**:
  - Page components
  - Shared components
  - State management
  - Service layers
- **Technology Stack**:
  - Frontend: React/Vue/Angular + TypeScript
  - Backend: Node.js/Python/Go
  - Database: PostgreSQL/MongoDB
  - Caching: Redis
  - Authentication: JWT/OAuth2
- **Security Architecture**:
  - Authentication & Authorization
  - Data encryption
  - CORS configuration
  - Input validation
- **Performance Strategy**:
  - Code splitting
  - Lazy loading
  - Caching strategy
  - CDN usage
- **Deployment Architecture**:
  - Container strategy
  - CI/CD pipeline
  - Monitoring & logging

### 2. User Stories
Convert requirements into user stories in `user-stories.md`:
- Epic level stories
- Feature level stories
- Format: "As a [user type], I want [feature] so that [benefit]"
- Acceptance criteria with specific UI/UX requirements
- Performance criteria (load time, response time)
- Browser compatibility requirements

### 3. Task Breakdown
For each user story, create atomic tasks in `planning/tasks/`:
- File naming: `us-001-[story-name].md`
- Frontend tasks
- Backend tasks
- Database tasks
- Integration tasks
- Testing tasks
- Documentation tasks

### 4. UI/UX Specifications
Include in architecture:
- Design system requirements
- Responsive breakpoints
- Accessibility requirements (WCAG 2.1)
- Component library choice
- Theme/styling approach

### 5. API Specifications
- Endpoint structure
- Request/response formats
- Error handling
- Rate limiting
- Versioning strategy

### 6. Data Model
- Entity relationships
- Database schema
- Migration strategy
- Seed data requirements

## Web-Specific Considerations
- **SEO Requirements**: Meta tags, sitemap, robots.txt
- **Progressive Web App**: Offline capability, service workers
- **Browser Support**: Target browsers and polyfills
- **Mobile First**: Responsive design approach
- **Performance Budget**: Bundle size, load time targets
- **Accessibility**: Screen reader support, keyboard navigation
- **Internationalization**: Multi-language support
- **Analytics**: Tracking requirements

## Quality Criteria
- Lighthouse score targets (Performance, Accessibility, SEO)
- Core Web Vitals targets
- Security headers implementation
- Cross-browser testing requirements
- Load testing requirements

Generate the complete project plan based on the requirements provided.