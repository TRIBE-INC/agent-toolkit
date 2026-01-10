# Example: Search Before Coding

This example shows how to search TRIBE before implementing a new feature.

## Scenario

You need to add rate limiting to your API. Instead of starting from scratch, check if you've done this before.

## Step 1: Search for Past Work

```bash
$ tribe search "rate limiting"

🔍 Found 2 sessions matching "rate limiting":

1. api-gateway [a1b2c3d4] Claude Code
   📅 Dec 15, 2:30 PM
   → Implementing rate limiting with Redis token bucket...
   → Added middleware to check request counts...
   ... and 8 more matches

2. user-service [e5f6g7h8] Claude Code
   📅 Nov 28, 10:15 AM
   → Simple in-memory rate limiter for dev...
   ... and 3 more matches
```

## Step 2: Recall Relevant Session

The first result looks like a production implementation. Let's get the details:

```bash
$ tribe recall a1b2c3d4

📋 Session Recall: a1b2c3d4
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 Project:  api-gateway
🛠️  Tool:     Claude Code
⏱️  Duration: 45 min
📊 Events:   127 events, 15K tokens

✅ Summary:
   • Worked on 4 files (.ts, .test.ts)
   • Used tools: Edit (12x), Bash (8x), Read (5x)
   • Key areas: redis, middleware, rate-limit

📄 Files touched:
   • src/middleware/rateLimiter.ts
   • src/middleware/rateLimiter.test.ts
   • src/config/redis.ts
   • package.json
```

## Step 3: Extract the Code

```bash
$ tribe extract a1b2c3d4 --type code

📝 Extracted 3 code from session a1b2c3d4:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] [typescript]
import Redis from 'ioredis';

const WINDOW_SIZE = 60; // seconds
const MAX_REQUESTS = 100;

export async function checkRateLimit(userId: string): Promise<boolean> {
  const key = `ratelimit:${userId}`;
  const current = await redis.incr(key);
  if (current === 1) {
    await redis.expire(key, WINDOW_SIZE);
  }
  return current <= MAX_REQUESTS;
}

[2] [typescript]
export const rateLimitMiddleware = async (req, res, next) => {
  const userId = req.user?.id || req.ip;
  const allowed = await checkRateLimit(userId);
  if (!allowed) {
    return res.status(429).json({ error: 'Too many requests' });
  }
  next();
};
```

## Step 4: Apply to Current Project

Now you have:
- A working implementation to reference
- Test patterns to follow
- Configuration approach to reuse

You can adapt this code to your current project instead of starting from scratch.

## Time Saved

- Without TRIBE: 1-2 hours researching and implementing
- With TRIBE: 10 minutes to find and adapt existing code

## Key Takeaways

1. **Always search first** - 5 seconds to check
2. **Recall for context** - Understand the full picture
3. **Extract what you need** - Code, commands, or files
4. **Adapt, don't copy** - Use as a starting point
