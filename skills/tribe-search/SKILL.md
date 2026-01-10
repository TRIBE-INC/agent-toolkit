---
name: tribe-search
description: Search TRIBE for relevant past sessions before solving problems. Use when starting new features, debugging issues, or implementing patterns you might have done before.
---

# TRIBE Search Skill

Before implementing solutions, check if similar work has been done before.

## When to Use

- Starting a new feature that might have patterns from past work
- Debugging an issue you might have solved before
- Implementing authentication, API endpoints, or common patterns
- Looking for "how did I do X last time?"

## Workflow

### 1. Identify Search Terms

Think about what you're trying to accomplish. Extract key technical terms:

- Technology/framework names (React, PostgreSQL, Docker)
- Pattern names (authentication, middleware, webhook)
- Problem descriptions (rate limiting, caching, validation)

### 2. Run Search

```bash
tribe search "<your query>"
```

**Examples:**
```bash
tribe search "JWT authentication"
tribe search "Docker compose postgres"
tribe search "rate limiting middleware"
tribe search "file upload S3"
```

### 3. Review Results

Results show:
- Project name and session ID
- Timestamp
- Matching snippets

### 4. Get Full Context

If a result looks relevant, recall the full session:

```bash
tribe recall <session-id>
```

### 5. Extract Specific Content

Pull out exactly what you need:

```bash
# Get the code
tribe extract <session-id> --type code

# Get shell commands
tribe extract <session-id> --type commands

# Get files touched
tribe extract <session-id> --type files
```

## Tips

- **Be specific**: "React form validation" > "validation"
- **Try variations**: "auth", "authentication", "login"
- **Filter by project**: `--project myapp`
- **Filter by time**: `--time-range 30d`

## Example Session

```
User: "Add rate limiting to the API"

Claude: Let me check if we've implemented rate limiting before.

$ tribe search "rate limiting"

Found 2 sessions:
1. api-server [abc123] - Rate limiting with Redis
   → Implemented token bucket algorithm with redis...

Let me recall that session for context:

$ tribe recall abc123

Now I can see we used a token bucket approach with Redis.
Let me apply a similar pattern here...
```
