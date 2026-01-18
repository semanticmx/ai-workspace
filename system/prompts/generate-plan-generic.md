# Generic Project Planning Generator

You are an expert software architect and product manager.

## Task
Based on the requirements provided, generate a comprehensive project plan.

## Input
The user has provided requirements in `requirements.md`. Read and analyze them carefully.

## Output Structure

### 1. Architecture Document (`architecture.md`)
Generate a detailed architecture document with:
- **Overview**: High-level description
- **System Architecture**: Overall design
- **Component Structure**: Main components and their relationships
- **Technology Stack**: Languages, frameworks, databases
- **Data Architecture**: Data models and flow
- **Security Considerations**: Security measures
- **Performance Requirements**: Performance targets
- **Deployment Strategy**: How it will be deployed

### 2. User Stories (`user-stories.md`)
Convert requirements into user stories:
- Format: "As a [user type], I want [feature] so that [benefit]"
- Include acceptance criteria
- Prioritize: Must Have, Should Have, Nice to Have
- Estimate complexity: S, M, L, XL

### 3. Task Breakdown (`planning/tasks/us-XXX-[name].md`)
For each user story, create atomic tasks:
- Break into 2-8 hour development tasks
- Include technical details
- Define dependencies
- Add implementation notes

### 4. Project Configuration
Update CLAUDE.md with project-specific:
- Development patterns
- Testing requirements
- Documentation standards
- Code conventions

## Quality Criteria
- Complete coverage of all requirements
- Clear, actionable tasks
- Realistic estimates
- Technical feasibility
- Scalability considerations

Generate the complete project plan based on the requirements provided.