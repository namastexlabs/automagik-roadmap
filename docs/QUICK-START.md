# Quick Start Guide

Two ways to sync initiatives to the project board:

## Option 1: Manual Sync (Zero Setup Required) ⭐

**Best for**: Template users, quick setup, no secrets needed

Just run this after creating an issue:

```bash
./scripts/sync-issue-to-project.sh 8
```

That's it! The script will:
- Parse the issue body
- Add to project board
- Set all custom fields
- Apply labels

**Requirements**: Just `gh` CLI installed and authenticated

---

## Option 2: Automated Sync (One-Time Setup)

**Best for**: Active development, frequent initiatives

The workflow automatically syncs when you create issues via the template, but requires one-time GitHub App setup (5 min).

See: [docs/setup-github-app.md](./setup-github-app.md)

---

## Creating Initiatives

1. Go to: https://github.com/namastexlabs/automagik-roadmap/issues/new/choose
2. Select "🎯 Roadmap Initiative"
3. Fill the form
4. Submit

**Then**:
- If automated: Just wait (fields auto-populate)
- If manual: Run `./scripts/sync-issue-to-project.sh <issue-number>`

---

## For Template Users

If you're using this repo as a template:

1. **Clone it**: Use "Use this template" button
2. **Create your project board**: GitHub Projects (organization or repo-level)
3. **Update the script**: Edit `scripts/sync-issue-to-project.sh`:
   - Change `ORG` and `REPO` to yours
   - Update `PROJECT_NUMBER` and `PROJECT_ID`
   - Get field IDs for your project (see below)
4. **Manual sync only**: Just use the script, no GitHub App needed!

### Getting Your Field IDs

```bash
gh api graphql -f query='
query {
  organization(login: "YOUR_ORG") {
    projectV2(number: YOUR_PROJECT_NUMBER) {
      id
      fields(first: 20) {
        nodes {
          ... on ProjectV2SingleSelectField {
            id
            name
            options { id name }
          }
          ... on ProjectV2Field {
            id
            name
          }
        }
      }
    }
  }
}'
```

Copy the IDs into the script's dictionaries.

---

## Comparison

| Feature | Manual Script | Automated |
|---------|--------------|-----------|
| Setup Time | 0 seconds | 5 minutes |
| Requirements | Just `gh` CLI | GitHub App + secrets |
| Template-Friendly | ✅ Yes | ❌ No (secrets don't copy) |
| Speed | Run when needed | Instant |
| Best For | Template users | Active repos |

**Recommendation**: Start with manual script, add automation later if needed!
