# 🔄 Handoff: Cross-Repo Issue Linking Implementation

**Date:** 2025-10-09
**Status:** Workflow deployed, awaiting secrets configuration
**Next Step:** Copy GitHub App secrets to genie repo and test

---

## 🎯 What We Built

A complete system for linking project repository issues to strategic roadmap initiatives using GitHub's native sub-issue functionality.

### Implemented Components

1. **✅ Unified Label Taxonomy** (53 labels)
   - Deployed to: `automagik-genie`
   - File: `.github/labels.yml`
   - Workflow: `.github/workflows/label-sync.yml`
   - Status: ✅ Live and working

2. **✅ Issue Templates** (3 templates)
   - Deployed to: `automagik-genie`
   - Files: `.github/ISSUE_TEMPLATE/`
     - `bug-report.yml` - Community bugs
     - `feature-request.yml` - Feature requests
     - `planned-feature.yml` - Roadmap-linked work
   - Status: ✅ Live and working

3. **✅ Roadmap Linking Workflow**
   - Deployed to: `automagik-genie`
   - File: `.github/workflows/link-to-roadmap.yml`
   - Status: ⚠️ Deployed but needs secrets

4. **✅ Documentation** (3 guides)
   - `docs/project-label-guide.md` - Complete label taxonomy
   - `docs/label-rollout-guide.md` - Deployment procedures
   - `docs/templates/issue-templates/` - Templates + README

---

## 🚧 Current Blocker: Missing Secrets

### The Problem

The roadmap linking workflow in `automagik-genie` needs to:
1. Read issues from `automagik-roadmap` (different repo)
2. Create sub-issue relationships via GraphQL
3. These operations require cross-repo permissions

**Default `GITHUB_TOKEN` only has access to the current repo.**

### The Solution

Copy GitHub App secrets from `automagik-roadmap` to `automagik-genie`:

**Required Secrets:**
- `PROJECT_APP_ID` - GitHub App ID
- `PROJECT_APP_PRIVATE_KEY` - GitHub App private key

**These secrets are already in `automagik-roadmap` and working** (used in `.github/workflows/sync-to-project.yml`).

### How to Copy Secrets

```bash
# 1. Get secrets from roadmap repo (requires admin access)
gh secret list --repo namastexlabs/automagik-roadmap

# 2. Set secrets in genie repo
gh secret set PROJECT_APP_ID --repo namastexlabs/automagik-genie
# (paste value when prompted)

gh secret set PROJECT_APP_PRIVATE_KEY --repo namastexlabs/automagik-genie
# (paste value when prompted)
```

**Note:** You'll need the actual secret values. If you don't have them, you can:
- Get them from the GitHub App settings
- Or ask the person who originally set them up

---

## 🧪 Test Issue Ready

**Test Issue:** `automagik-genie#18`
- URL: https://github.com/namastexlabs/automagik-genie/issues/18
- Links to: `automagik-roadmap#32`
- Has label: `planned-feature`
- Workflow: ❌ Failed due to missing secrets

**Once secrets are added:**
1. Edit issue #18 (trigger workflow again)
2. Workflow should:
   - Parse initiative number: 32
   - Validate initiative exists
   - Create sub-issue link
   - Add labels: `roadmap-linked`, `initiative-32`
   - Comment with confirmation

---

## 📋 Real-World Use Case: Phase Issues

**Parent Initiative:** `automagik-roadmap#32` - Event Fabric Foundation

**Children (should be linked):**
- `#33` - [Phase 1A] Schema Foundation
- `#34` - [Phase 1B] Ingest Unification
- `#35` - [Phase 1C] Naming Neutralization
- `#36` - [Phase 1D] Raw Payload Capture

**Current State:**
- These issues exist but are **NOT linked** yet
- Need to either:
  - Add `planned-feature` label + initiative number to each
  - Or manually link via GraphQL (after secrets are set)

---

## 🔍 How It Works

### Native GitHub Sub-Issues

GitHub has **native parent/child relationships** for issues:

**GraphQL Fields:**
- `parent` - Returns parent Issue (if this is a sub-issue)
- `subIssues` - Returns list of child Issues
- `subIssuesSummary` - Summary stats

**GraphQL Mutation:**
```graphql
mutation {
  addSubIssue(input: {
    issueId: "parent_node_id"      # Initiative in roadmap
    subIssueId: "child_node_id"     # Issue in project repo
  }) {
    issue { title number }
    subIssue { title number }
  }
}
```

**Must include header:** `GraphQL-Features: sub_issues`

### Workflow Flow

```
1. User creates issue with Planned Feature template
   ↓
2. Fills "Roadmap Initiative Number" field (e.g., "32")
   ↓
3. Issue created with label: planned-feature
   ↓
4. Workflow triggers (on issues.opened/edited)
   ↓
5. Parse initiative number from body: "32"
   ↓
6. Validate initiative exists in automagik-roadmap
   ↓
7. Get node IDs for both issues
   ↓
8. Call addSubIssue GraphQL mutation
   ↓
9. Add labels: roadmap-linked, initiative-32
   ↓
10. Comment with confirmation
```

---

## 📁 File Locations

### Genie Repo (automagik-genie)

```
.github/
├── labels.yml                           # 53 labels
├── ISSUE_TEMPLATE/
│   ├── bug-report.yml                   # Community bugs
│   ├── feature-request.yml              # Feature requests
│   ├── planned-feature.yml              # Roadmap-linked (triggers workflow)
│   └── config.yml                       # Template config
└── workflows/
    ├── label-sync.yml                   # Syncs labels
    └── link-to-roadmap.yml              # ⚠️ Needs secrets

```

### Roadmap Repo (automagik-roadmap)

```
docs/
├── project-label-guide.md               # Complete label guide
├── label-rollout-guide.md               # Deployment guide
└── templates/
    ├── labels.yml                       # Base template for labels
    └── issue-templates/
        ├── bug-report.yml               # Template files
        ├── feature-request.yml
        ├── planned-feature.yml
        ├── config.yml
        └── README.md                    # Usage guide

.github/
└── workflows/
    └── link-to-roadmap.yml              # Also created (for roadmap issues)
```

---

## ✅ What Works Now

### Labels (Fully Working)
```bash
# Genie has 53 labels deployed
gh label list --repo namastexlabs/automagik-genie | wc -l
# Output: 53

# Categories working:
- type:* (7 labels)
- priority:* (4 labels)
- area:* (18 labels - 15 base + 3 genie-specific)
- roadmap linking (3 labels)
- release:* (4 labels)
- status:* (4 labels)
- community (4 labels)
```

### Templates (Fully Working)
Visit: https://github.com/namastexlabs/automagik-genie/issues/new/choose

You'll see:
- 🐛 Bug Report
- ✨ Feature Request
- 🎯 Planned Feature

All templates work and apply correct labels.

---

## ❌ What Doesn't Work Yet

### Roadmap Linking Workflow

**Error:**
```
Initiative #32 not found in automagik-roadmap: Not Found
```

**Cause:** Missing secrets for cross-repo access

**Fix:** Copy `PROJECT_APP_ID` and `PROJECT_APP_PRIVATE_KEY` to genie repo

---

## 🚀 Next Steps

### 1. Copy Secrets (Immediate)
```bash
gh secret set PROJECT_APP_ID --repo namastexlabs/automagik-genie
gh secret set PROJECT_APP_PRIVATE_KEY --repo namastexlabs/automagik-genie
```

### 2. Test Workflow (After secrets)
```bash
# Edit test issue to retrigger workflow
gh issue edit 18 --repo namastexlabs/automagik-genie --add-label "test-edit"

# Watch workflow
gh run watch --repo namastexlabs/automagik-genie

# Verify link created
gh api graphql -H "GraphQL-Features: sub_issues" -f query='
query {
  repository(owner: "namastexlabs", name: "automagik-genie") {
    issue(number: 18) {
      parent { number title }
    }
  }
}'
```

### 3. Link Phase Issues (After validation)

**Option A: Via Workflow**
```bash
# Add label to each Phase issue
for issue in 33 34 35 36; do
  gh issue edit $issue --repo namastexlabs/automagik-roadmap \
    --add-label "planned-feature"

  # Add initiative number to body
  # (requires manual edit to add "### 🔗 Roadmap Initiative Number\n32")
done
```

**Option B: Manual GraphQL**
```bash
# Get node IDs
PARENT=$(gh api repos/namastexlabs/automagik-roadmap/issues/32 --jq '.node_id')

for issue in 33 34 35 36; do
  CHILD=$(gh api repos/namastexlabs/automagik-roadmap/issues/$issue --jq '.node_id')

  gh api graphql -H "GraphQL-Features: sub_issues" -f query="
  mutation {
    addSubIssue(input: {issueId: \"$PARENT\", subIssueId: \"$CHILD\"}) {
      issue { number }
      subIssue { number }
    }
  }"
done
```

### 4. Roll Out to Other Repos

Once validated in genie:

**Priority order:**
1. ✅ genie (done, needs secrets)
2. omni (high activity)
3. hive
4. spark
5. forge
6. tools

**For each repo:**
```bash
cd /path/to/automagik-{repo}

# 1. Copy labels
cp ../automagik-roadmap/docs/templates/labels.yml .github/

# 2. Customize repo-specific labels (see label-rollout-guide.md)

# 3. Copy templates
cp ../automagik-roadmap/docs/templates/issue-templates/*.yml .github/ISSUE_TEMPLATE/

# 4. Customize area checkboxes

# 5. Copy workflows
cp ../automagik-genie/.github/workflows/label-sync.yml .github/workflows/
cp ../automagik-genie/.github/workflows/link-to-roadmap.yml .github/workflows/

# 6. Commit and push

# 7. Add secrets
gh secret set PROJECT_APP_ID --repo namastexlabs/automagik-{repo}
gh secret set PROJECT_APP_PRIVATE_KEY --repo namastexlabs/automagik-{repo}
```

---

## 📊 Success Metrics

After secrets are added and workflow works:

✅ **Workflow Success:**
- Issue #18 has parent: roadmap#32
- Labels added: `roadmap-linked`, `initiative-32`
- Comment posted with confirmation

✅ **GraphQL Query Works:**
```graphql
query {
  repository(owner: "namastexlabs", name: "automagik-roadmap") {
    issue(number: 32) {
      subIssues(first: 10) {
        totalCount
        nodes { number title repository { name } }
      }
    }
  }
}
```

Should show: 1+ sub-issues (genie#18, plus Phase issues if linked)

---

## 🐛 Troubleshooting

### Workflow Still Fails After Adding Secrets

**Check secrets exist:**
```bash
gh secret list --repo namastexlabs/automagik-genie
```

**Check workflow logs:**
```bash
gh run list --repo namastexlabs/automagik-genie --workflow=link-to-roadmap.yml --limit 1
gh run view {run-id} --repo namastexlabs/automagik-genie --log
```

### Labels Not Creating Dynamic `initiative-{number}`

Labels are created by the workflow, not predefined. After successful linking, check:
```bash
gh label list --repo namastexlabs/automagik-genie | grep initiative
```

### Sub-Issue Link Not Created

**Verify GraphQL header:**
Workflow must include: `'GraphQL-Features': 'sub_issues'`

**Check permissions:**
GitHub App must have:
- Issues: Read & Write (for both repos)
- Metadata: Read

---

## 📚 Key Documentation

**In Roadmap Repo:**
- [Project Label Guide](docs/project-label-guide.md) - Complete taxonomy
- [Label Rollout Guide](docs/label-rollout-guide.md) - Step-by-step deployment
- [Cross-Repo References](docs/cross-repo-references.md) - Existing linking patterns
- [Issue Template README](docs/templates/issue-templates/README.md) - Template usage

**Reference Implementation:**
- Genie repo: https://github.com/namastexlabs/automagik-genie
- Test issue: https://github.com/namastexlabs/automagik-genie/issues/18
- Parent initiative: https://github.com/namastexlabs/automagik-roadmap/issues/32

---

## 💡 Design Decisions Made

1. **Priority:** Default to `medium`, adjust during triage
2. **Area checkboxes:** Informational only (no auto-labeling)
3. **Blank issues:** Enabled (allows quick notes)
4. **Impact field:** Informational (doesn't auto-convert to priority)
5. **Template naming:** "Planned Feature" (not "Roadmap Work Item")
6. **Labels as visual indicators:** `roadmap-linked` and `initiative-{number}` help filtering, but real relationship is in GraphQL

---

## 🎓 Key Learnings

1. **GitHub has native sub-issues** - parent/subIssues fields in GraphQL
2. **Sub-issues work cross-repo** - Can link genie issues to roadmap issues
3. **Requires GraphQL-Features header** - Must include `sub_issues` feature flag
4. **GitHub App needed for cross-repo** - GITHUB_TOKEN insufficient
5. **EndBug/label-sync works** - micnncim/action-label-syncer doesn't persist labels
6. **Explicit permissions required** - Must add `permissions:` block to workflows

---

## 🤝 Collaboration Points

**Who can help:**
- **Secrets:** Anyone with admin access to both repos can copy secrets
- **Testing:** Anyone can trigger workflow by editing issue #18
- **Rollout:** Team can deploy to other repos using rollout guide

**Discord:** https://discord.gg/xcW8c7fF3R

---

## 📝 Session Summary

**What we accomplished:**
- Designed and implemented unified label taxonomy (53 labels)
- Created 3 issue templates (bug, feature request, planned feature)
- Built roadmap linking workflow with GraphQL sub-issue support
- Deployed to genie repo (labels, templates, workflow)
- Documented everything comprehensively
- Identified blocker (missing secrets) and solution

**Time invested:** ~4 hours of collaborative work

**Ready to proceed:** ✅ Yes, just need secrets copied

---

*Last updated: 2025-10-09 18:00 UTC*
