# Example: Continuing Previous Work

This example shows how to pick up where you left off on a project.

## Scenario

You worked on the authentication system yesterday but got interrupted. Now you need to continue.

## Step 1: Find Yesterday's Session

```bash
$ tribe query sessions --project auth-service --time-range 24h

📋 Found 3 sessions (showing 3):

1. auth-service [x1y2z3a4] Claude Code
   156 events · 2h 15m · 28K tokens
   Yesterday, 3:30 PM → 5:45 PM

2. auth-service [b5c6d7e8] Claude Code
   42 events · 25 min · 5K tokens
   Yesterday, 2:00 PM → 2:25 PM

3. auth-service [f9g0h1i2] Claude Code
   18 events · 10 min · 2K tokens
   Yesterday, 1:45 PM → 1:55 PM
```

## Step 2: Recall What You Did

```bash
$ tribe recall x1y2z3a4

📋 Session Recall: x1y2z3a4
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 Project:  auth-service
🛠️  Tool:     Claude Code
⏱️  Duration: 2h 15m
📊 Events:   156 events, 28K tokens

✅ Summary:
   • Worked on 8 files (.ts, .test.ts, .json)
   • Executed 12 shell commands
   • Used tools: Edit (45x), Bash (12x), Read (18x)
   • Key areas: jwt, oauth, refresh-token, security

📄 Files touched:
   • src/services/authService.ts
   • src/services/tokenService.ts
   • src/middleware/authMiddleware.ts
   • src/routes/auth.ts
   • tests/auth.test.ts
   • package.json

💻 Commands run:
   $ npm test -- --watch
   $ npm run dev
   $ curl -X POST localhost:3000/auth/login
```

## Step 3: See Exactly Where You Stopped

```bash
$ tribe extract x1y2z3a4 --type edits --limit 3

✏️ Extracted 3 edits from session x1y2z3a4:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] 📄 src/services/tokenService.ts
  - // TODO: Implement refresh token rotation
  + async rotateRefreshToken(oldToken: string): Promise<TokenPair> {
  +   const payload = this.verifyRefreshToken(oldToken);
  +   await this.revokeToken(oldToken);
  +   return this.generateTokenPair(payload.userId);
  + }

[2] 📄 src/routes/auth.ts
  - router.post('/refresh', refreshTokenHandler);
  + router.post('/refresh', validateRefreshToken, refreshTokenHandler);

[3] 📄 tests/auth.test.ts
  - // TODO: Add refresh token tests
  + describe('Token Refresh', () => {
  +   it('should rotate refresh tokens', async () => {
```

## Step 4: Continue Working

Now you know:
- You were implementing refresh token rotation
- The tokenService is partially done
- Tests are started but incomplete

You can continue exactly where you left off.

## Pro Tips

### Add Notes for Future Sessions

When stopping work, leave a TODO comment or note about next steps. TRIBE will capture it and make it searchable.

### Use Consistent Project Names

Keep project directories named consistently so `--project` filtering works well.

### Check Multiple Sessions

Sometimes work spans multiple sessions. Check a few to get the full picture.
