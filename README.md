# claude-chat-cleaner

A [Claude Code](https://code.claude.com) plugin and CLI tool to clean up unnecessary conversation history files.

Claude Code stores conversations as `.jsonl` files in `~/.claude/projects/`. Over time, these accumulate empty, failed, interrupted, and trivial sessions that waste disk space. This tool analyzes and cleans them up.

## What it does

- Scans all Claude Code project directories for `.jsonl` chat files
- Classifies each chat as **rubbish** or **useful** based on content analysis
- Shows a per-project breakdown with content previews before deleting anything
- Safe by default — always dry-run first, delete only when you confirm

### Classification rules

A chat is classified as **rubbish** if ANY of these are true:

| Rule | Example |
|------|---------|
| No user or assistant messages | Empty sessions, metadata-only files |
| Single trivial message (< 50 chars) | Typos, accidental invocations like `:q` |
| First messages are all init/error/interrupted | Failed sessions, API errors, user interrupts |

Everything else is classified as **keep**.

## Installation

### As a Claude Code plugin (recommended)

Plugins get automatic updates when new versions are released.

**Option A — from the marketplace:**
```
/plugin marketplace add jainsvaibhav/claude-chat-cleaner
/plugin install chat-cleaner@claude-chat-cleaner
```

**Option B — from local directory:**
```bash
git clone https://github.com/jainsvaibhav/claude-chat-cleaner.git
claude --plugin-dir ./claude-chat-cleaner
```

Then in Claude Code:
```
/chat-cleaner:chat-cleanup
```

### As a standalone skill

If you prefer short skill names (`/chat-cleanup` instead of `/chat-cleaner:chat-cleanup`):

```bash
git clone https://github.com/jainsvaibhav/claude-chat-cleaner.git
cd claude-chat-cleaner
./install.sh
```

Then in Claude Code:
```
/chat-cleanup
```

### Standalone CLI only

If you just want the command-line tool without Claude Code integration:

```bash
curl -o claude-chat-cleaner https://raw.githubusercontent.com/jainsvaibhav/claude-chat-cleaner/main/claude-chat-cleaner
chmod +x claude-chat-cleaner
sudo mv claude-chat-cleaner /usr/local/bin/
```

### Remote machines

```bash
scp claude-chat-cleaner remote-host:~/
ssh remote-host "python3 ~/claude-chat-cleaner --analyze"
ssh remote-host "python3 ~/claude-chat-cleaner --delete"
```

## Usage

### CLI

```bash
# Dry-run — see what would be deleted (default)
claude-chat-cleaner --analyze

# Actually delete rubbish files
claude-chat-cleaner --delete

# Filter to a specific project
claude-chat-cleaner --analyze --project my-project

# JSON output for scripting
claude-chat-cleaner --analyze --json

# Custom .claude directory
claude-chat-cleaner --analyze --claude-dir /path/to/.claude
```

### Claude Code (plugin)

```
/chat-cleaner:chat-cleanup
```

### Claude Code (standalone skill)

```
/chat-cleanup
```

Claude will:
1. Run `--analyze` to scan all projects
2. Present a summary table of rubbish vs. useful chats
3. Ask for your confirmation before deleting

### Example output

```
## -Volumes-workplace-my-project (15 chats)
  RUBBISH (6):
      3K  a1b2c3d4...  — Empty — no conversation content
     12K  e5f6a7b8...  — Failed/interrupted session
      1K  c9d0e1f2...  — Trivial — ':q'

  KEEP (9):
    120K  f3a4b5c6...  — 5u/12a — implement the new authentication flow for...
     45K  d7e8f9a0...  — 3u/8a — debug the failing integration test in...

==================================================
TOTAL: 6 rubbish (22K), 9 keep
Run with --delete to remove rubbish files.
```

## Options

| Flag | Description |
|------|-------------|
| `--analyze` | Show what would be deleted (default, dry-run) |
| `--delete` | Actually delete rubbish files |
| `--project NAME` | Only process projects matching this substring |
| `--min-size SIZE` | Only consider files under SIZE bytes |
| `--json` | Output results as JSON for programmatic use |
| `--claude-dir PATH` | Custom path to `.claude` directory (default: `~/.claude`) |

## Requirements

- Python 3.6+
- No external dependencies (standard library only)

## Uninstall

**Plugin:**
```
/plugin uninstall chat-cleaner
```

**Standalone skill:**
```bash
rm -rf ~/.claude/skills/chat-cleanup
```

## License

MIT
