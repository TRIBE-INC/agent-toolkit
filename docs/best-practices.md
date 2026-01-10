# TRIBE Best Practices

Tips for building and leveraging tribal knowledge effectively.

## Before You Code

### Always Search First

Before implementing anything non-trivial, take 5 seconds to search:

```bash
tribe search "<what you're building>"
```

This simple habit can save hours of work.

### Use Specific Search Terms

**Good searches:**
```bash
tribe search "JWT refresh token rotation"
tribe search "PostgreSQL connection pooling"
tribe search "React form validation yup"
```

**Less effective:**
```bash
tribe search "auth"        # Too broad
tribe search "fix bug"     # Not specific
tribe search "error"       # Too generic
```

### Try Multiple Queries

If first search doesn't find what you need:

```bash
tribe search "rate limiting"
tribe search "throttling requests"
tribe search "request limit middleware"
```

## During Development

### Let TRIBE Capture Everything

TRIBE works automatically. Just:
- Keep `tribe enable` running
- Work normally in Claude Code
- Your sessions are captured

### Document Decisions in Code

Comments and commit messages become searchable:

```typescript
// Using token bucket algorithm because sliding window
// had memory issues at scale (see session abc123)
```

### Create Meaningful Commits

```bash
# Good - searchable
git commit -m "Add JWT refresh token rotation with Redis"

# Less useful
git commit -m "fix auth"
```

## After Completing Work

### Review What TRIBE Captured

```bash
tribe recall <session-id>
```

Verify key files and decisions were captured.

### Tag Important Sessions

Add a comment in your code referencing the session:

```typescript
// Implementation details: tribe recall abc12345
```

## Team Practices

### Onboard with TRIBE

New team members can self-serve:

```bash
# "How do we do auth?"
tribe search "authentication"

# "What's our API pattern?"
tribe search "API endpoint controller"
```

### Share Session References

In PRs and documentation:

> For implementation context, see `tribe recall xyz789`

### Build Common Patterns

Frequently used patterns become easily discoverable:

```bash
tribe search "error handling pattern"
tribe search "logging setup"
tribe search "database migration"
```

## Search Strategies

### By Technology

```bash
tribe search "Redis caching"
tribe search "PostgreSQL query"
tribe search "Docker compose"
```

### By Pattern

```bash
tribe search "middleware pattern"
tribe search "repository pattern"
tribe search "factory pattern"
```

### By Problem

```bash
tribe search "memory leak"
tribe search "performance optimization"
tribe search "race condition"
```

### By Feature

```bash
tribe search "user registration"
tribe search "payment processing"
tribe search "file upload"
```

## Organizing Work

### Consistent Project Names

Keep directory names consistent:

```
~/projects/my-app/       # Always "my-app"
~/projects/my-app-v2/    # Not this
```

This makes `--project` filtering reliable.

### Session Boundaries

Long sessions get harder to navigate. Consider:
- Natural breaks when switching tasks
- Committing frequently
- Starting fresh sessions for new features

## Troubleshooting

### "No results found"

1. Try broader search terms
2. Check time range: `--time-range all`
3. Verify collector is running: `tribe status`

### Session Not Captured

1. Was collector running? `tribe status`
2. Check auth: `tribe login`
3. Wait a few minutes for sync

### Sensitive Data

TRIBE captures code and commands. Be mindful of:
- API keys (use environment variables)
- Credentials (never hardcode)
- Sensitive customer data

## Quick Reference

| Action | Command |
|--------|---------|
| Search | `tribe search "query"` |
| Recall | `tribe recall <id>` |
| Extract code | `tribe extract <id> --type code` |
| List sessions | `tribe query sessions` |
| Check status | `tribe status` |
