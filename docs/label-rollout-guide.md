# 🚀 Label Taxonomy Rollout Guide

Step-by-step guide for implementing unified label taxonomy across Automagik project repositories.

---

## Overview

This guide walks through deploying the unified label taxonomy to all Automagik project repos (omni, hive, spark, forge, tools).

**What Gets Deployed:**
- `.github/labels.yml` - Label definitions (53 base + repo-specific)
- `.github/workflows/label-sync.yml` - Automatic sync workflow
- Repo-specific area labels (2-4 per repo)

**Deployment Time:** ~15 minutes per repo

---

## Prerequisites

**Required:**
- GitHub CLI (`gh`) authenticated with org access
- Write permissions to target repository
- Access to automagik-roadmap repo (for template files)

**Check Prerequisites:**
```bash
# Verify gh CLI
gh auth status

# Verify repo access
gh repo view namastexlabs/automagik-{repo} --json name
```

---

## Deployment Steps

### Step 1: Prepare Label Definitions

**1.1. Copy Base Template**
```bash
cd /path/to/automagik-{repo}
cp /path/to/automagik-roadmap/docs/templates/labels.yml .github/labels.yml
```

**1.2. Add Repo-Specific Labels**

Edit `.github/labels.yml` and add repo-specific areas at the end of the "Area Dimension" section:

**For Omni:**
```yaml
# Omni-specific areas
- name: area:channels
  color: '006B75'
  description: 'Channels - Channel integrations (Slack, WhatsApp, etc.)'

- name: area:evolution
  color: '006B75'
  description: 'Evolution - Evolution API integration'
```

**For Hive:**
```yaml
# Hive-specific areas
- name: area:orchestration
  color: '006B75'
  description: 'Orchestration - Multi-agent coordination'

- name: area:swarm
  color: '006B75'
  description: 'Swarm - Swarm intelligence features'
```

**For Spark:**
```yaml
# Spark-specific areas
- name: area:cron
  color: '006B75'
  description: 'Cron - Scheduled task management'

- name: area:triggers
  color: '006B75'
  description: 'Triggers - Event-based automation'
```

**For Forge:**
```yaml
# Forge-specific areas
- name: area:orchestration
  color: '006B75'
  description: 'Orchestration - Development workflow coordination'

- name: area:scaffolding
  color: '006B75'
  description: 'Scaffolding - Project generation and templates'
```

**For Tools:**
```yaml
# Tools-specific areas
- name: area:marketplace
  color: '006B75'
  description: 'Marketplace - Tool discovery and publishing'

- name: area:builder
  color: '006B75'
  description: 'Builder - Tool creation and development'
```

---

### Step 2: Deploy Sync Workflow

**2.1. Create Workflow File**
```bash
mkdir -p .github/workflows
```

**2.2. Add Workflow Definition**

Create `.github/workflows/label-sync.yml`:

```yaml
name: Sync Labels
on:
  push:
    branches:
      - main
    paths:
      - '.github/labels.yml'
  workflow_dispatch:

jobs:
  label-sync:
    runs-on: ubuntu-latest
    permissions:
      issues: write
      contents: read
    steps:
      - uses: actions/checkout@v4

      - name: Sync labels
        uses: EndBug/label-sync@v2
        with:
          config-file: .github/labels.yml
          token: ${{ secrets.GITHUB_TOKEN }}
          delete-other-labels: false  # Keep existing labels
```

**Key Points:**
- ⚠️ **MUST include** `permissions:` block for workflow to write labels
- ⚠️ **Use EndBug/label-sync@v2** (not micnncim/action-label-syncer - doesn't persist)
- ✅ `delete-other-labels: false` prevents deleting existing labels

---

### Step 3: Commit and Deploy

**3.1. Review Changes**
```bash
git status
git diff .github/labels.yml
git diff .github/workflows/label-sync.yml
```

**3.2. Commit Files**
```bash
git add .github/labels.yml .github/workflows/label-sync.yml

git commit -m "feat: add unified label taxonomy and sync workflow

- Add comprehensive label taxonomy (53 base + repo-specific)
- Include 7 dimensions: type, priority, area, roadmap, release, status, community, admin
- Add {repo}-specific labels: {list specific labels}
- Add label-sync workflow for automatic synchronization
- Enable roadmap initiative linking with planned-feature labels

Co-authored-by: Automagik Genie 🧞 <genie@namastex.ai>"
```

**3.3. Push to Trigger Workflow**
```bash
git push origin main
```

---

### Step 4: Verify Deployment

**4.1. Monitor Workflow**
```bash
# Check workflow status
gh run list --workflow=label-sync.yml --limit 1

# View workflow logs
gh run view {run-id} --log
```

**4.2. Verify Labels Created**
```bash
# Count total labels
gh api repos/namastexlabs/automagik-{repo}/labels --paginate | jq -r '.[].name' | wc -l

# Should show ~53-57 labels (53 base + repo-specific)
```

**4.3. Spot Check Key Labels**
```bash
# Check type labels
gh api repos/namastexlabs/automagik-{repo}/labels --paginate | jq -r '.[].name' | grep "^type:"

# Check roadmap labels
gh api repos/namastexlabs/automagik-{repo}/labels --paginate | jq -r '.[].name' | grep -E "(planned|roadmap)"

# Check repo-specific labels
gh api repos/namastexlabs/automagik-{repo}/labels --paginate | jq -r '.[].name' | grep -E "{repo-specific-pattern}"
```

**Expected Output:**
```
type:bug
type:debt
type:docs
type:enhancement
type:feature
type:research
type:testing

planned-feature
roadmap-linked
closed-initiative-work

area:{repo-specific}
```

---

### Step 5: Clean Up Duplicates (If Needed)

**5.1. Identify Duplicates**
```bash
gh api repos/namastexlabs/automagik-{repo}/labels --paginate | jq -r '.[].name' | sort | uniq -d
```

**Common duplicates:**
- `good first issue` (old, with space) vs `good-first-issue` (new, with hyphen)
- `help wanted` (old) vs `help-wanted` (new)

**5.2. Delete Old Labels**
```bash
# Delete old label (with space)
gh label delete "good first issue" --repo namastexlabs/automagik-{repo} --yes
gh label delete "help wanted" --repo namastexlabs/automagik-{repo} --yes
```

---

## Troubleshooting

### Issue: Workflow Completes but Labels Not Created

**Symptom:** Workflow shows success but `gh label list` shows only 9 default labels

**Cause:** Missing `permissions:` block in workflow

**Fix:**
```yaml
jobs:
  label-sync:
    permissions:      # ← ADD THIS
      issues: write   # ← REQUIRED
      contents: read
```

Re-run workflow after fixing.

---

### Issue: "Label Already Exists" Errors

**Symptom:** Workflow fails with label collision errors

**Cause:** Label already exists with different color/description

**Fix:** EndBug/label-sync should update existing labels. If errors persist:

```bash
# Delete conflicting label
gh label delete "{label-name}" --repo namastexlabs/automagik-{repo} --yes

# Re-run workflow
gh workflow run label-sync.yml
```

---

### Issue: Repo-Specific Labels Not Created

**Symptom:** Base labels created but repo-specific missing

**Cause:** Syntax error in `.github/labels.yml`

**Fix:**
```bash
# Validate YAML syntax
yamllint .github/labels.yml

# Check workflow logs for errors
gh run view {run-id} --log | grep -i error
```

---

## Rollout Checklist

Use this checklist for each repository:

### Pre-Deployment
- [ ] Authenticate with `gh auth status`
- [ ] Clone/update repository
- [ ] Create feature branch (optional)

### Deployment
- [ ] Copy base `labels.yml` template
- [ ] Add repo-specific area labels
- [ ] Create `label-sync.yml` workflow
- [ ] Review changes with `git diff`
- [ ] Commit with descriptive message
- [ ] Push to main branch

### Verification
- [ ] Workflow runs successfully
- [ ] Label count ~53-57
- [ ] Type labels present (7)
- [ ] Roadmap labels present (3)
- [ ] Repo-specific labels present (2-4)
- [ ] No duplicate labels

### Cleanup
- [ ] Delete duplicate labels if needed
- [ ] Test label application on test issue
- [ ] Update rollout status table

---

## Rollout Order

**Recommended order:**

1. ✅ **Genie** (Complete - reference implementation)
2. ⏳ **Omni** (Next - high activity)
3. ⏳ **Hive** (After Omni)
4. ⏳ **Spark** (After Hive)
5. ⏳ **Forge** (After Spark)
6. ⏳ **Tools** (Last - lower activity)

**Rationale:** Deploy to high-activity repos first to get early feedback, then roll out to others.

---

## Testing After Deployment

**1. Create Test Issue**
```bash
echo "Test issue for label validation" | gh issue create \
  --repo namastexlabs/automagik-{repo} \
  --title "Test: Label Taxonomy" \
  --label "type:feature,priority:low,area:testing" \
  --body-file -
```

**2. Verify Labels Applied**
```bash
gh issue view {issue-number} --repo namastexlabs/automagik-{repo} --json labels
```

**3. Test Roadmap Linking** (Manual)
- Create issue with `planned-feature` label
- Add initiative number in body
- Verify workflow creates sub-issue link
- Check `roadmap-linked` and `initiative-{number}` labels added

**4. Close Test Issue**
```bash
gh issue close {issue-number} --repo namastexlabs/automagik-{repo}
```

---

## Next Steps After Rollout

**1. Issue Templates**
- Create 3 templates: Bug Report, Feature Request, Planned Feature
- See [template guide](issue-template-guide.md) (pending)

**2. Roadmap Linking Workflow**
- Implement sub-issue automation
- See [roadmap linking guide](roadmap-linking-guide.md) (pending)

**3. Documentation**
- Update repo README with label usage
- Link to [Project Label Guide](project-label-guide.md)

---

## Quick Reference

### Essential Commands

```bash
# Trigger workflow manually
gh workflow run label-sync.yml

# Check workflow status
gh run list --workflow=label-sync.yml --limit 1

# Count labels
gh label list | wc -l

# List labels by category
gh label list | grep "^type:"
gh label list | grep "^area:"
gh label list | grep "^priority:"

# Delete label
gh label delete "{label-name}" --yes

# Create test issue
gh issue create --label "type:feature"
```

### File Locations

```
.github/
├── labels.yml                    # Label definitions
└── workflows/
    └── label-sync.yml           # Sync workflow
```

---

## Support

**Issues:** Open issue in [automagik-roadmap](https://github.com/namastexlabs/automagik-roadmap/issues)

**Documentation:** [Project Label Guide](project-label-guide.md)

**Examples:** See [automagik-genie](https://github.com/namastexlabs/automagik-genie) for reference implementation

---

*Last updated: 2025-10-09*
