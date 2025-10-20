# Scripts

Utility scripts for managing the Automagik Roadmap.

## Initiative Management

### create-initiative-from-json.sh
Creates roadmap initiatives from JSON input with full automation.

**Usage:**
```bash
cat initiative.json | ./scripts/create-initiative-from-json.sh
```

**Example:**
```bash
echo '{"title":"Feature","project":"hive","quarter":"2026-q1","priority":"high","goals":["Goal 1"]}' | ./scripts/create-initiative-from-json.sh
```

See `example-initiative.json` for complete JSON template.

### export-to-csv.py
Exports roadmap initiatives to CSV format.

**Usage:**
```bash
export GITHUB_TOKEN=ghp_xxx
python3 scripts/export-to-csv.py
```

## Repository Analysis

### check-repo-activity.sh
Analyzes repository activity across **all branches** (not just main/dev).

**Usage:**
```bash
./scripts/check-repo-activity.sh owner/repo [days]
```

**Examples:**
```bash
# Check public repos
./scripts/check-repo-activity.sh namastexlabs/automagik-genie 7
./scripts/check-repo-activity.sh namastexlabs/automagik-forge 14

# Check private repos (requires gh auth with access)
./scripts/check-repo-activity.sh namastexlabs/private-repo 7
```

**Output:**
- Recent push events across all branches
- List of all branches
- Most active branches with latest commit dates

**Why use this?**
- Standard `gh` commands only check default branch (main/dev)
- Feature branches often contain active work not visible in main
- This script checks ALL branches to find actual activity

**Requirements:**
- GitHub CLI (`gh`) installed and authenticated
- Access to the repository (public or private with appropriate permissions)
