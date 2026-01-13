# Telemetry System Fixes - Epic

## Epic: Telemetry System Reliability & Quality

The TRIBE telemetry system has multiple reliability and quality issues discovered during integration testing. This epic tracks all fixes needed to make the system production-ready.

**Goal:** A session created in Claude Code appears in the API within 30 seconds, with correct metadata, and the system runs reliably without manual intervention.

---

## Issue 1: Collector runs multiple instances causing duplicate events

**Labels:** bug, reliability, P1

**Problem:**
The collector can be started multiple ways (LaunchAgent, `tribe enable`, manual binary) with no mutex or singleton check. This results in 2-4 collector processes running simultaneously, potentially causing:
- Duplicate event uploads
- Resource contention
- Inconsistent sync state

**Evidence:**
```
PID 41970: LaunchAgent collector (-interval 10s)
PID 41971: tribe enable collector (-interval 2s)
PID 48129: Dev collector (localhost:8080)
```

**Acceptance Criteria:**
- [ ] Collector uses PID file to ensure single instance
- [ ] `tribe enable` checks if collector already running
- [ ] Clear error message if already running
- [ ] LaunchAgent and manual start use same singleton logic

**Files to modify:**
- `cli/tutor/collector/main.go`
- `cli/sdk/cmd/tribe-new/main.go` (enable command)

---

## Issue 2: Log files grow unbounded - 219GB log caused disk full

**Labels:** bug, reliability, P0

**Problem:**
Collector log files have no size limits or rotation. A single log file grew to 219GB, filling the disk to 99% capacity.

**Evidence:**
```
/Users/almorris/.tribe/tutor/collector.log: 219GB
/Users/almorris/.tribe/logs/tutor-collector.log: 1.8GB
Disk: 881GB used of 926GB (99%)
```

**Acceptance Criteria:**
- [ ] Log files rotate at 100MB
- [ ] Keep last 5 rotated files
- [ ] Total log storage capped at 500MB
- [ ] Or: use system logrotate / newsyslog

**Files to modify:**
- `cli/tutor/collector/main.go`
- LaunchAgent plist (add log rotation)

---

## Issue 3: Session tool shows "Bash" instead of "Claude Code"

**Labels:** bug, data-quality, P2

**Problem:**
Session-level `tool` field is set based on the last event's tool, not the source client. Sessions with Bash tool calls show tool="Bash" instead of tool="Claude Code".

**Evidence:**
```json
// API returns:
{"conversation_id": "c5aa183a", "tool": "Bash"}

// But events show:
{"event_type": "user", "tool": "claude_code"}
{"event_type": "assistant", "tool": "Bash"}  // tool call
```

**Acceptance Criteria:**
- [ ] Session tool = client that created the session (claude_code, cursor)
- [ ] Tool calls (Bash, Read, Edit) don't override session tool
- [ ] Backfill existing sessions with correct tool

**Files to modify:**
- `_site/app/api/data/sessions/route.ts` (or wherever session aggregation happens)
- Database migration for backfill

---

## Issue 4: Session project path uses parent directory, not working directory

**Labels:** bug, data-quality, P2

**Problem:**
Sessions in subdirectories are grouped under parent folder. Working in `/TRIBE/0zen/agent-toolkit` shows as project `0zen` instead of `agent-toolkit`.

**Evidence:**
```
Working directory: /Users/almorris/TRIBE/0zen/agent-toolkit
API shows: {"project_path": "/Users/almorris/TRIBE/0zen"}
```

**Acceptance Criteria:**
- [ ] Session project_path = actual working directory from events
- [ ] Or: use git root if available
- [ ] Display shows leaf folder name, not full path

**Files to modify:**
- Collector event parsing
- Session aggregation logic

---

## Issue 5: Sync is too slow - batch mode takes hours for historical data

**Labels:** enhancement, performance, P2

**Problem:**
Collector syncs in batches (50 events every 10 seconds). For 83,000 historical events, this takes 4+ hours. New users wait hours before seeing their data.

**Evidence:**
```
Sync Status: 36,487 synced / 83,498 discovered (43.7% complete)
At 50 events/10s = 5 events/second = 4.6 hours for full sync
```

**Acceptance Criteria:**
- [ ] Historical sync uses larger batches (500-1000 events)
- [ ] Real-time sync uses small batches (current behavior)
- [ ] Initial sync completes in <30 minutes for typical user
- [ ] Progress indicator shows estimated time remaining

**Files to modify:**
- `cli/tutor/collector/main.go`

---

## Issue 6: Security filter blocks events silently - no visibility

**Labels:** enhancement, observability, P2

**Problem:**
Events containing secrets get security score 0/100 and are dropped. User has no visibility into what's being filtered or why.

**Evidence:**
```
[SECURITY SCORE] Score: 0/100
[SECURITY SCORE] Penalty: secret_keys (count: 49, per-item: 15, total: 735)
```

**Acceptance Criteria:**
- [ ] `tribe status` shows count of filtered events
- [ ] `tribe status --verbose` shows filter reasons
- [ ] Dashboard shows "X events filtered for security"
- [ ] Consider: redact instead of drop?

**Files to modify:**
- `cli/tutor/collector/security.go`
- `cli/sdk/cmd/tribe-new/main.go` (status command)

---

## Issue 7: No integration test for end-to-end flow

**Labels:** enhancement, testing, P1

**Problem:**
No automated test verifies the full flow: event created → collector picks up → API returns session. Each component tested in isolation, integration breaks silently.

**Acceptance Criteria:**
- [ ] Integration test: create event file, verify in API within 30s
- [ ] Test runs in CI on every PR
- [ ] Test covers: event capture, upload, session creation, search
- [ ] Failure alerts to Slack/email

**Files to create:**
- `cli/tutor/integration_test.go`
- CI workflow for integration tests

---

## Issue 8: `tribe status` shows "Not running" when collector is running

**Labels:** bug, UX, P3

**Problem:**
`tribe status` shows "Telemetry Status: Not running" even when LaunchAgent collector is active. Misleading for users.

**Evidence:**
```
$ tribe status
📊 Telemetry Status: Not running

$ pgrep -f tutor-collector
41970  # It IS running
```

**Acceptance Criteria:**
- [ ] `tribe status` checks for running collector process
- [ ] Shows PID if running
- [ ] Distinguishes LaunchAgent vs manual start

**Files to modify:**
- `cli/sdk/cmd/tribe-new/main.go` (status command)

---

## Issue 9: Multiple collector binaries in different locations

**Labels:** tech-debt, P3

**Problem:**
Collector binary exists in multiple locations with different versions:
- `~/.tribe/bin/tutor-collector` (installed)
- `~/TRIBE/0zen/tutor/bin/tutor-collector` (dev)

Dev binary was accidentally started pointing to localhost.

**Acceptance Criteria:**
- [ ] Single source of truth for collector binary
- [ ] Dev builds clearly marked (version includes -dev)
- [ ] `tribe enable` only uses installed binary

**Files to modify:**
- Build scripts
- `cli/sdk/cmd/tribe-new/main.go`

---

## Issue 10: Session count mismatch - API shows 14, local has 3627 files

**Labels:** bug, data-quality, P2

**Problem:**
Massive discrepancy between local log files (3,627) and API sessions (14). Even accounting for sync progress, the ratio seems wrong.

**Evidence:**
```
Local log files: 3,627
API sessions: 14
Sync: 43.7% complete
```

**Acceptance Criteria:**
- [ ] Investigate: are log files 1:1 with sessions?
- [ ] Document expected ratio
- [ ] Add metric: local files vs synced sessions
- [ ] Alert if ratio is abnormal

**Files to investigate:**
- Collector file discovery logic
- Session deduplication logic

---

## Summary

| Issue | Priority | Type | Effort |
|-------|----------|------|--------|
| #2 Log rotation | P0 | Bug | Small |
| #1 Singleton collector | P1 | Bug | Medium |
| #7 Integration test | P1 | Enhancement | Medium |
| #3 Tool labeling | P2 | Bug | Small |
| #4 Project path | P2 | Bug | Small |
| #5 Sync speed | P2 | Enhancement | Medium |
| #6 Security visibility | P2 | Enhancement | Small |
| #10 Session count | P2 | Bug | Medium |
| #8 Status accuracy | P3 | Bug | Small |
| #9 Binary locations | P3 | Tech debt | Small |
