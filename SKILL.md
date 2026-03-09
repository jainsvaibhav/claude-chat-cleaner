---
name: chat-cleanup
description: Clean up unnecessary Claude Code chat files (.jsonl) across projects. Use when the user wants to delete rubbish/empty/failed chats, free up space, or tidy their Claude conversation history. Works locally and on remote hosts via SSH.
user_invocable: true
---

# Claude Chat Cleanup Skill

Clean up unnecessary Claude Code chat history files across all projects.

## Overview

Claude Code stores conversation history as `.jsonl` files in `~/.claude/projects/<project>/`. Over time, these accumulate empty, failed, interrupted, and trivial sessions that waste space. This skill uses the `claude-chat-cleaner` CLI tool to analyze and clean them up.

## Tool Location

The cleanup script is installed at: `~/.claude/skills/chat-cleanup/claude-chat-cleaner`

## Workflow

### Step 1: Analyze

Always start with a dry-run to show the user what would be deleted:

```bash
~/.claude/skills/chat-cleanup/claude-chat-cleaner --analyze
```

This will show a per-project breakdown of rubbish vs. useful chats with content previews.

### Step 2: Confirm with User

Present the summary table and **always ask before deleting**. Never auto-delete.

### Step 3: Delete

Once the user confirms:

```bash
~/.claude/skills/chat-cleanup/claude-chat-cleaner --delete
```

### Remote Hosts

To clean up a remote machine via SSH:

```bash
# First, copy the script to the remote host
scp ~/.claude/skills/chat-cleanup/claude-chat-cleaner <hostname>:~/claude-chat-cleaner

# Then run remotely
ssh <hostname> "python3 ~/claude-chat-cleaner --analyze"
ssh <hostname> "python3 ~/claude-chat-cleaner --delete"
```

### Options

```
--analyze           Show what would be deleted (default, dry-run)
--delete            Actually delete rubbish files
--project NAME      Only process a specific project (substring match)
--min-size SIZE     Only consider files under SIZE bytes (default: all files)
--json              Output results as JSON for programmatic use
--claude-dir PATH   Custom path to .claude directory (default: ~/.claude)
```

## Classification Rules

A chat is classified as **rubbish** if ANY of these are true:
- No user or assistant messages at all (empty/metadata-only)
- Only a single trivial user message (under 50 chars, no real content)
- First two user messages are all init/error/interrupted (failed session)

Everything else is classified as **keep**.

## Important

- Always show results before deleting — never skip the confirmation step
- The tool only deletes top-level `.jsonl` files in project directories
- Memory files, settings, and skill files are never touched
- The `--analyze` mode makes zero changes — completely safe to run
