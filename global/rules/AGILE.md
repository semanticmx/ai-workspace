# 📋 Agile Development Standards

## Methodology
We follow **Scrum** with 2-week sprints, adapted for AI-assisted development.

## Sprint Structure

### Sprint Planning
- **Duration**: 2 hours max
- **Output**: Sprint backlog with estimated story points
- **AI Role**: Help break down stories, estimate complexity, identify dependencies

### Daily Standups
- **Format**: Written updates in `todos/active/daily-standup.md`
- **Questions**:
  1. What did I complete yesterday?
  2. What will I work on today?
  3. Are there any blockers?
- **AI Role**: Generate standup summary, identify patterns, suggest unblocking strategies

### Sprint Review
- **Duration**: 1 hour
- **Focus**: Demo completed features
- **AI Role**: Generate demo scripts, create presentation materials

### Sprint Retrospective
- **Duration**: 1 hour
- **Output**: `projects/[name]/retrospectives/sprint-[n].md`
- **AI Role**: Analyze sprint metrics, identify improvement areas

## User Stories

### Format
```
As a [type of user]
I want [goal/desire]
So that [benefit/value]
```

### Acceptance Criteria
- Must be specific and measurable
- Include happy path and edge cases
- Define non-functional requirements

### Definition of Done
- [ ] Code complete and follows standards
- [ ] Unit tests written and passing
- [ ] Integration tests passing
- [ ] Code reviewed
- [ ] Documentation updated
- [ ] Deployed to staging
- [ ] Product owner approved

## Story Points

| Points | Complexity | Time Estimate | Example |
|--------|-----------|---------------|---------|
| 1 | Trivial | < 2 hours | Fix typo, update config |
| 2 | Simple | 2-4 hours | Add form validation |
| 3 | Medium | 4-8 hours | Create CRUD endpoint |
| 5 | Complex | 1-2 days | Implement auth system |
| 8 | Very Complex | 2-3 days | Design new architecture |
| 13 | Epic | 3-5 days | Major feature |

## Backlog Management

### Priority Levels
1. **🔴 Critical**: Blocking issues, security fixes
2. **🟠 High**: Core features, important bugs
3. **🟡 Medium**: Nice-to-have features, improvements
4. **🟢 Low**: Technical debt, optimizations

### Backlog Grooming
- Weekly session (1 hour)
- Refine top 10 items
- Split large stories
- Remove outdated items

## Velocity Tracking

Track in `projects/[name]/metrics/velocity.md`:
- Story points completed per sprint
- Bugs introduced vs fixed
- Technical debt ratio
- Test coverage trend

## Communication

### Channels
- **Planning**: `projects/[name]/planning/`
- **Daily Updates**: `todos/active/`
- **Blockers**: `projects/[name]/issues/`
- **Decisions**: `projects/[name]/decisions/`

### Documentation
- All decisions in ADR format
- Sprint goals in planning docs
- Retrospective actions tracked

## Tools Integration

### GitHub Projects
- Automated project boards
- Issue templates
- PR templates
- Milestone tracking

### Claude Integration
```bash
# Sprint planning
claude-code "Create sprint plan from backlog"

# Daily standup
claude-code "Generate standup report"

# Story refinement
claude-code "Break down user story: [story]"

# Retrospective
claude-code "Analyze sprint metrics and suggest improvements"
```

## Metrics

### Sprint Metrics
- Velocity (story points)
- Commitment vs Delivered
- Defect Rate
- Cycle Time

### Team Health
- Retrospective action completion
- Blocker resolution time
- Knowledge sharing sessions
- Documentation quality

## Anti-Patterns to Avoid

- ❌ Changing sprint scope mid-sprint
- ❌ Skipping retrospectives
- ❌ Not updating documentation
- ❌ Working on unplanned items
- ❌ Ignoring technical debt

---

*These Agile practices should be adapted to fit project-specific needs*