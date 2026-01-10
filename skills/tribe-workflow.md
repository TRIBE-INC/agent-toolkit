---
name: tribe-workflow
description: Complete workflow for using TRIBE as tribal knowledge. Use at the start of any coding task to leverage past work and avoid reinventing solutions.
---

# TRIBE Workflow Skill

A complete workflow for leveraging your team's collective coding knowledge.

## The TRIBE Workflow

### Before You Code: Search

**Always check if similar work exists before implementing.**

```bash
tribe search "<what you're building>"
```

This takes 5 seconds and can save hours of reinventing solutions.

### During Development: Capture

TRIBE automatically captures your session. No action needed.

Just work normally - your patterns, solutions, and approaches are being recorded for future reference.

### After Completion: Available

Your work is now searchable by you and your team.

Future sessions can find and build on what you've done.

## Workflow Checklist

### Starting a New Task

1. [ ] **Identify keywords** - What are you building? (auth, API, form, etc.)
2. [ ] **Search TRIBE** - `tribe search "<keywords>"`
3. [ ] **Review matches** - Do any results look relevant?
4. [ ] **Recall context** - `tribe recall <id>` for relevant sessions
5. [ ] **Extract if needed** - Pull code, commands, or patterns
6. [ ] **Begin work** - Build on past knowledge or start fresh

### Common Searches

```bash
# Before adding authentication
tribe search "authentication login JWT"

# Before setting up a database
tribe search "PostgreSQL prisma migration"

# Before adding an API endpoint
tribe search "REST API endpoint validation"

# Before adding tests
tribe search "testing jest mock"

# Before containerizing
tribe search "Docker dockerfile compose"
```

## Integration Points

### Project Startup

When starting work on any project:

```bash
# See recent sessions for this project
tribe query sessions --project $(basename $PWD) --limit 5

# Search for relevant patterns
tribe search "$(basename $PWD)"
```

### Problem Solving

When stuck on a problem:

```bash
# Search for similar issues
tribe search "error message or symptom"

# Look for debugging sessions
tribe search "debug fix <component>"
```

### Code Review

When reviewing code:

```bash
# Find when this was implemented
tribe search "<function or feature name>"

# Understand the context
tribe recall <session-id>
```

## Building Tribal Knowledge

### Good Session Habits

1. **Descriptive commits** - They become searchable
2. **Clear task descriptions** - Context for future searches
3. **Document decisions** - Why, not just what

### Team Benefits

- New team members can search for how things were done
- Patterns become discoverable
- Less "how did we do X?" questions
- Onboarding becomes self-service

## Quick Reference

| Command | Purpose |
|---------|---------|
| `tribe search "query"` | Find past sessions |
| `tribe recall <id>` | Get session summary |
| `tribe extract <id> --type code` | Pull code snippets |
| `tribe extract <id> --type commands` | Pull shell commands |
| `tribe query sessions` | List recent sessions |
| `tribe query sessions --project X` | Filter by project |
