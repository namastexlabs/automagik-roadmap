# Project Board Automation Guide

**Purpose:** Automatically populate GitHub Project Board fields when issues are created with `planned-feature` label.

**Project:** [Automagik Roadmap Project #9](https://github.com/orgs/namastexlabs/projects/9)

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Current State](#current-state)
3. [How It Works](#how-it-works)
4. [Fields That Auto-Populate](#fields-that-auto-populate)
5. [Implementation Checklist](#implementation-checklist)
6. [Workflow Code Snippets](#workflow-code-snippets)
7. [Field IDs Reference](#field-ids-reference)
8. [Troubleshooting](#troubleshooting)

---

## Overview

### What Gets Automated

When an issue is created with the `planned-feature` label, the `link-to-roadmap.yml` workflow:

1. ✅ Links issue to roadmap initiative (sub-issue relationship)
2. ✅ Adds labels (`roadmap-linked`, `initiative-{number}`)
3. ✅ Adds issue to Project Board #9
4. ✅ Populates project board fields:
   - **Stage** → Based on parent initiative stage
   - **Status** → "Todo" (default)
   - **Project** → Repo name (auto-detected)
   - **ETA** → Quarter (from body or default)
   - **Expected Results** → Acceptance criteria summary
   - **Priority** → From issue labels

### Why This Matters

- **Saves time:** No manual field population
- **Consistency:** All issues follow same pattern
- **Visibility:** Issues immediately appear in correct project view
- **Tracking:** Full metadata for reporting and planning

---

## Current State

### ✅ Working Repos (Fields Auto-Populate)

- **genie** - Fully working (tested with #27-31)
- **omni** - Fully working (tested with #35-36)
- **hive** - Partially working (workflow exists, fields need manual update)
- **tools** - Partially working (workflow exists, fields need manual update)

### ❌ Broken Repos (Manual Population Needed)

- **spark** - Workflows on `dev` branch (not `main`)
- **forge** - Recently enabled issues, workflows need deployment

### 🔧 Issues in All Repos

1. **Wrong Field IDs** - Old Status field ID doesn't exist
2. **Missing ETA** - No ETA field population
3. **Missing Expected Results** - No acceptance criteria extraction

---

## How It Works

### Trigger Flow

```
Issue Created with "planned-feature" label
    ↓
link-to-roadmap.yml workflow triggers
    ↓
1. Parse initiative number from issue body
2. Validate initiative exists in roadmap
3. Create sub-issue relationship (GraphQL)
4. Add labels (roadmap-linked, initiative-{number})
5. Add issue to project board
6. Populate project board fields
7. Comment on issue with confirmation
```

### Template Structure

Issues must use this template format for auto-population:

```markdown
### 🔗 Roadmap Initiative: [#29](https://github.com/namastexlabs/automagik-roadmap/issues/29)

### 📋 Work Type: `Feature Implementation`

### 📄 Description
[Description here]

### ✅ Acceptance Criteria

**Category 1:**
- [ ] Item 1
- [ ] Item 2

**Category 2:**
- [ ] Item 3

### 🧩 Dependencies
...
```

**Key Points:**
- Initiative number must be in first section
- Acceptance Criteria must have `**Category:**` headers
- Work Type determines if it's a planned feature

---

## Fields That Auto-Populate

| Field | Source | How It's Set |
|-------|--------|--------------|
| **Title** | Issue title | Automatic (GitHub) |
| **Stage** | Parent initiative stage | Workflow reads initiative state → maps to stage |
| **Status** | Default "Todo" | Hardcoded in workflow |
| **Project** | Repository name | Extracted from `context.repo.repo` |
| **Priority** | Issue labels | Parsed from `priority:high`, `priority:medium`, etc. |
| **ETA** | Issue body or default | Parsed from body or defaults to current quarter |
| **Expected Results** | Acceptance Criteria | Extracted category headers, joined with commas |
| **Parent Issue** | Sub-issue link | Created via GraphQL `addSubIssue` mutation |

### Fields NOT Auto-Populated

- **Owner** - Manual entry (text field)
- **Target Date** - Manual entry (date field)
- **Assignees** - Set via GitHub (not project field)
- **Milestone** - Set via GitHub (not project field)

---

## Implementation Checklist

### Phase 1: Fix Existing Workflows (All Repos)

- [ ] **Update field IDs** (Status field ID is wrong)
- [ ] **Fix stage option ID** (Executing option ID is wrong)
- [ ] **Add ETA field population**
- [ ] **Add Expected Results extraction**
- [ ] **Test with sample issue**

### Phase 2: Deploy to Broken Repos

- [ ] **Spark:** Merge workflows from `dev` to `main` branch
- [ ] **Forge:** Deploy complete workflow infrastructure
- [ ] **Verify:** Test in each repo with sample issue

### Phase 3: Validation

- [ ] **All 6 repos** have working workflows
- [ ] **All fields** populate correctly
- [ ] **No manual intervention** needed
- [ ] **Documentation** updated

---

## Workflow Code Snippets

### Current Workflow Structure

```yaml
name: Link to Roadmap Initiative
on:
  issues:
    types: [opened, edited]

jobs:
  link-to-initiative:
    runs-on: ubuntu-latest
    if: contains(github.event.issue.labels.*.name, 'planned-feature')
    steps:
      # 1. Generate GitHub App token
      # 2. Parse initiative number
      # 3. Validate initiative exists
      # 4. Create sub-issue link
      # 5. Add labels
      # 6. Add to project board
      # 7. Set project board fields  ← NEEDS FIXING
      # 8. Comment on issue
```

### Step 7: Set Project Board Fields (FIXED VERSION)

Replace the entire "Set project board fields" step with this:

```yaml
- name: Set project board fields
  uses: actions/github-script@v7
  with:
    github-token: ${{ steps.generate-token.outputs.token }}
    script: |
      const projectId = 'PVT_kwDOBvG2684BE-4E';
      const itemId = '${{ steps.add-to-board.outputs.project_item_id }}';

      if (!itemId || itemId === '') {
        console.log('Skipping field updates - item not in project');
        return;
      }

      // ============================================
      // FIELD IDs (DO NOT CHANGE - These are correct)
      // ============================================
      const FIELDS = {
        stage: 'PVTSSF_lADOBvG2684BE-4Ezg2c_hc',
        status: 'PVTSSF_lADOBvG2684BE-4Ezg2c5dY',
        project: 'PVTSSF_lADOBvG2684BE-4Ezg2c_ec',
        eta: 'PVTSSF_lADOBvG2684BE-4Ezg2dPxc',
        expectedResults: 'PVTF_lADOBvG2684BE-4Ezg2c8aE',
        priority: 'PVTSSF_lADOBvG2684BE-4Ezg2c_kA'
      };

      // ============================================
      // STAGE OPTIONS (Based on initiative stage)
      // ============================================
      const STAGE_OPTIONS = {
        'open': '073f61b0',      // Executing (for open initiatives)
        'closed': '3d0b8ddd'     // Shipped (for closed initiatives)
      };

      // ============================================
      // STATUS OPTIONS
      // ============================================
      const STATUS_OPTIONS = {
        todo: 'f75ad846',
        in_progress: '47fc9ee4',
        done: '98236657'
      };

      // ============================================
      // PROJECT OPTIONS (Repo name mapping)
      // ============================================
      const PROJECT_OPTIONS = {
        'automagik-omni': '9c171c42',
        'automagik-hive': 'a28ceeff',
        'automagik-spark': '0a588179',
        'automagik-forge': '2a9e974c',
        'automagik-genie': '93d4bd3c',
        'automagik-tools': 'f00fd26a'
      };

      // ============================================
      // ETA OPTIONS (Quarter mapping)
      // ============================================
      const ETA_OPTIONS = {
        '2025-Q4': 'a35fa4f5',
        '2026-Q1': 'a0cccfe6',
        '2026-Q2': 'cf1026cb',
        '2026-Q3': '3c402b09',
        '2026-Q4': 'ec810765',
        'backlog': '88ae1263'
      };

      // ============================================
      // PRIORITY OPTIONS
      // ============================================
      const PRIORITY_OPTIONS = {
        critical: '700a2c58',
        high: 'd7a47ff6',
        medium: '79c50f9e',
        low: 'c7f229a8'
      };

      // ============================================
      // 1. SET STAGE (Based on initiative state)
      // ============================================
      const initiativeState = '${{ steps.validate.outputs.initiative_state }}';
      const stageOption = STAGE_OPTIONS[initiativeState] || STAGE_OPTIONS['open'];

      try {
        await github.graphql(`
          mutation {
            updateProjectV2ItemFieldValue(input: {
              projectId: "${projectId}"
              itemId: "${itemId}"
              fieldId: "${FIELDS.stage}"
              value: { singleSelectOptionId: "${stageOption}" }
            }) {
              projectV2Item { id }
            }
          }
        `);
        console.log('✓ Set Stage to', initiativeState === 'closed' ? 'Shipped' : 'Executing');
      } catch (error) {
        console.log('Warning: Could not set Stage:', error.message);
      }

      // ============================================
      // 2. SET STATUS (Default: Todo)
      // ============================================
      try {
        await github.graphql(`
          mutation {
            updateProjectV2ItemFieldValue(input: {
              projectId: "${projectId}"
              itemId: "${itemId}"
              fieldId: "${FIELDS.status}"
              value: { singleSelectOptionId: "${STATUS_OPTIONS.todo}" }
            }) {
              projectV2Item { id }
            }
          }
        `);
        console.log('✓ Set Status to Todo');
      } catch (error) {
        console.log('Warning: Could not set Status:', error.message);
      }

      // ============================================
      // 3. SET PROJECT (From repo name)
      // ============================================
      const repoFullName = context.repo.owner + '/' + context.repo.repo;
      const projectOption = PROJECT_OPTIONS[context.repo.repo];

      if (projectOption) {
        try {
          await github.graphql(`
            mutation {
              updateProjectV2ItemFieldValue(input: {
                projectId: "${projectId}"
                itemId: "${itemId}"
                fieldId: "${FIELDS.project}"
                value: { singleSelectOptionId: "${projectOption}" }
              }) {
                projectV2Item { id }
              }
            }
          `);
          console.log('✓ Set Project to', context.repo.repo.replace('automagik-', ''));
        } catch (error) {
          console.log('Warning: Could not set Project:', error.message);
        }
      }

      // ============================================
      // 4. SET ETA (Default: 2025-Q4 or parse from body)
      // ============================================
      const body = context.payload.issue.body || '';

      // Try to parse ETA from body (look for "### 📊 Estimated Complexity" or quarter mentions)
      let etaOption = ETA_OPTIONS['2025-Q4']; // Default

      const quarterMatch = body.match(/quarter[:\s]*(20\d{2}-Q[1-4])/i);
      if (quarterMatch && ETA_OPTIONS[quarterMatch[1]]) {
        etaOption = ETA_OPTIONS[quarterMatch[1]];
      }

      try {
        await github.graphql(`
          mutation {
            updateProjectV2ItemFieldValue(input: {
              projectId: "${projectId}"
              itemId: "${itemId}"
              fieldId: "${FIELDS.eta}"
              value: { singleSelectOptionId: "${etaOption}" }
            }) {
              projectV2Item { id }
            }
          }
        `);
        console.log('✓ Set ETA to 2025-Q4 (default)');
      } catch (error) {
        console.log('Warning: Could not set ETA:', error.message);
      }

      // ============================================
      // 5. SET EXPECTED RESULTS (From acceptance criteria)
      // ============================================
      const criteriaMatch = body.match(/### ✅ Acceptance Criteria\n+([\s\S]*?)\n+###/);

      if (criteriaMatch) {
        // Extract category headers (**Category:**)
        const categories = criteriaMatch[1]
          .match(/\*\*[^*]+:\*\*/g)
          ?.map(cat => cat.replace(/\*\*/g, '').replace(/:$/, ''))
          .join(', ') || 'Various acceptance criteria';

        const results = categories.substring(0, 300); // Limit to 300 chars

        try {
          await github.graphql(`
            mutation {
              updateProjectV2ItemFieldValue(input: {
                projectId: "${projectId}"
                itemId: "${itemId}"
                fieldId: "${FIELDS.expectedResults}"
                value: { text: "${results.replace(/"/g, '\\"')}" }
              }) {
                projectV2Item { id }
              }
            }
          `);
          console.log('✓ Set Expected Results:', results);
        } catch (error) {
          console.log('Warning: Could not set Expected Results:', error.message);
        }
      }

      // ============================================
      // 6. SET PRIORITY (From issue labels)
      // ============================================
      const labels = context.payload.issue.labels.map(l => l.name);
      const priorityLabel = labels.find(l => l.startsWith('priority:'));

      if (priorityLabel) {
        const priorityValue = priorityLabel.replace('priority:', '');
        const priorityOption = PRIORITY_OPTIONS[priorityValue];

        if (priorityOption) {
          try {
            await github.graphql(`
              mutation {
                updateProjectV2ItemFieldValue(input: {
                  projectId: "${projectId}"
                  itemId: "${itemId}"
                  fieldId: "${FIELDS.priority}"
                  value: { singleSelectOptionId: "${priorityOption}" }
                }) {
                  projectV2Item { id }
                }
              }
            `);
            console.log('✓ Set Priority to', priorityValue);
          } catch (error) {
            console.log('Warning: Could not set Priority:', error.message);
          }
        }
      }
```

### Where to Apply This

**Update these files in ALL repos:**
1. `automagik-genie/.github/workflows/link-to-roadmap.yml`
2. `automagik-hive/.github/workflows/link-to-roadmap.yml`
3. `automagik-spark/.github/workflows/link-to-roadmap.yml`
4. `automagik-forge/.github/workflows/link-to-roadmap.yml`
5. `automagik-tools/.github/workflows/link-to-roadmap.yml`
6. `automagik-omni/.github/workflows/link-to-roadmap.yml`

---

## Field IDs Reference

### Project Board

- **Project ID:** `PVT_kwDOBvG2684BE-4E`
- **Organization:** `namastexlabs`
- **Project Number:** `9`
- **URL:** https://github.com/orgs/namastexlabs/projects/9

### Field IDs

| Field Name | Field ID | Type | Notes |
|------------|----------|------|-------|
| Stage | `PVTSSF_lADOBvG2684BE-4Ezg2c_hc` | Single Select | Based on initiative stage |
| Status | `PVTSSF_lADOBvG2684BE-4Ezg2c5dY` | Single Select | Default: Todo |
| Project | `PVTSSF_lADOBvG2684BE-4Ezg2c_ec` | Single Select | From repo name |
| ETA | `PVTSSF_lADOBvG2684BE-4Ezg2dPxc` | Single Select | Quarter |
| Priority | `PVTSSF_lADOBvG2684BE-4Ezg2c_kA` | Single Select | From labels |
| Expected Results | `PVTF_lADOBvG2684BE-4Ezg2c8aE` | Text | From acceptance criteria |
| Owner | `PVTF_lADOBvG2684BE-4Ezg2c8aI` | Text | Manual |
| Target Date | `PVTF_lADOBvG2684BE-4Ezg2c8aM` | Date | Manual |

### Option IDs - Stage

| Option | ID | Usage |
|--------|-----|-------|
| Wishlist | `d4964f90` | Early ideation |
| Exploring | `f5c85cef` | Validation phase |
| RFC | `cd5acf90` | Community feedback |
| Priorization | `a3c2913b` | Planning |
| **Executing** | `073f61b0` | **Active implementation (DEFAULT)** |
| Preview | `b572947d` | Beta testing |
| Shipped | `3d0b8ddd` | Production |
| Archived | `0e15297c` | Deprioritized |

### Option IDs - Status

| Option | ID | Usage |
|--------|-----|-------|
| **Todo** | `f75ad846` | **Not started (DEFAULT)** |
| In Progress | `47fc9ee4` | Active work |
| Done | `98236657` | Completed |

### Option IDs - Project

| Option | ID | Repo |
|--------|-----|------|
| omni | `9c171c42` | automagik-omni |
| hive | `a28ceeff` | automagik-hive |
| spark | `0a588179` | automagik-spark |
| forge | `2a9e974c` | automagik-forge |
| genie | `93d4bd3c` | automagik-genie |
| tools | `f00fd26a` | automagik-tools |
| cross-project | `c1f1ab29` | Multi-repo work |

### Option IDs - ETA

| Option | ID | Usage |
|--------|-----|-------|
| backlog | `88ae1263` | Not scheduled |
| **2025-Q4** | `a35fa4f5` | **Oct-Dec 2025 (DEFAULT)** |
| 2026-Q1 | `a0cccfe6` | Jan-Mar 2026 |
| 2026-Q2 | `cf1026cb` | Apr-Jun 2026 |
| 2026-Q3 | `3c402b09` | Jul-Sep 2026 |
| 2026-Q4 | `ec810765` | Oct-Dec 2026 |

### Option IDs - Priority

| Option | ID | Usage |
|--------|-----|-------|
| critical | `700a2c58` | Blocker, urgent |
| high | `d7a47ff6` | Important |
| medium | `79c50f9e` | Normal |
| low | `c7f229a8` | Nice to have |

---

## Troubleshooting

### Issue: Fields Not Populating

**Symptoms:** Issue created with `planned-feature` label but project board fields are empty

**Possible Causes:**

1. **Workflow not on default branch**
   ```bash
   # Check default branch
   gh repo view namastexlabs/automagik-{repo} --json defaultBranchRef --jq '.defaultBranchRef.name'

   # Check if workflow exists on default branch
   gh api repos/namastexlabs/automagik-{repo}/contents/.github/workflows/link-to-roadmap.yml
   ```

2. **Wrong field IDs in workflow**
   - Old Status field ID: `PVTSSF_lADOBvG2684BE-4Ezg2dPw0` ❌
   - Correct Status field ID: `PVTSSF_lADOBvG2684BE-4Ezg2c5dY` ✅

3. **Label doesn't exist**
   ```bash
   # Check if planned-feature label exists
   gh label list --repo namastexlabs/automagik-{repo} | grep planned-feature

   # If missing, sync labels
   gh workflow run label-sync.yml --repo namastexlabs/automagik-{repo}
   ```

4. **GitHub App secrets missing**
   ```bash
   # Check if secrets exist
   gh secret list --repo namastexlabs/automagik-{repo}

   # Should show:
   # PROJECT_APP_ID
   # PROJECT_APP_PRIVATE_KEY
   ```

### Issue: Workflow Fails

**Check workflow runs:**
```bash
gh run list --repo namastexlabs/automagik-{repo} --workflow=link-to-roadmap.yml --limit 5
```

**View failure details:**
```bash
gh run view {run-id} --repo namastexlabs/automagik-{repo} --log-failed
```

**Common errors:**

| Error | Cause | Fix |
|-------|-------|-----|
| "The single select option Id does not belong to the field" | Wrong option ID | Update to correct ID from reference |
| "Could not resolve to a node with the global id" | Wrong field ID | Update to correct field ID from reference |
| "Label not found" | Label doesn't exist | Run label-sync workflow first |
| "Initiative #X not found" | Wrong initiative number | Fix issue body with correct number |

### Issue: Manual Population Needed

**If workflow can't be fixed immediately, populate manually:**

```bash
# Get item ID for the issue
gh api graphql -f query='
{
  organization(login: "namastexlabs") {
    projectV2(number: 9) {
      items(first: 50) {
        nodes {
          id
          content {
            ... on Issue {
              number
              repository { name }
            }
          }
        }
      }
    }
  }
}' | jq -r '.data.organization.projectV2.items.nodes[] | select(.content.repository.name == "automagik-{repo}" and .content.number == {issue-num}) | .id'

# Then use the manual population script
# See: docs/workflow-automation-fixes.md
```

### Issue: Expected Results Not Extracted

**Check acceptance criteria format:**

```markdown
✅ CORRECT:
### ✅ Acceptance Criteria

**Labels:**
- [ ] Item 1

**Templates:**
- [ ] Item 2

❌ WRONG:
### ✅ Acceptance Criteria

Labels:
- [ ] Item 1  (missing ** **)

Templates
- [ ] Item 2  (missing : and ** **)
```

**Expected format:**
- Categories must be: `**Category Name:**`
- Bold markers required: `**`
- Colon required: `:`

---

## Testing

### Test Workflow in Each Repo

1. **Create test issue:**
   ```bash
   gh issue create \
     --repo namastexlabs/automagik-{repo} \
     --title "TEST: Workflow validation" \
     --label "planned-feature,priority:medium" \
     --body "$(cat << 'EOF'
   ### 🔗 Roadmap Initiative: [#29](https://github.com/namastexlabs/automagik-roadmap/issues/29)

   ### 📋 Work Type: `Feature Implementation`

   ### 📄 Description
   Test issue to validate workflow automation.

   ### ✅ Acceptance Criteria

   **Testing:**
   - [ ] Workflow triggers correctly
   - [ ] Fields populate automatically

   **Validation:**
   - [ ] All fields present in project board
   EOF
   )"
   ```

2. **Verify results:**
   - Check issue has `roadmap-linked` and `initiative-29` labels
   - Check issue appears in Project #9
   - Check all fields populated:
     - Stage: Executing
     - Status: Todo
     - Project: {repo name}
     - ETA: 2025-Q4
     - Expected Results: "Testing, Validation"
     - Priority: medium

3. **Clean up:**
   ```bash
   gh issue close {issue-num} --repo namastexlabs/automagik-{repo}
   ```

---

## Migration Path

### Step 1: Fix Spark Branch (Priority)

```bash
cd /home/cezar/automagik/automagik-spark
git checkout main
git pull origin dev:.github/workflows/
git add .github/workflows/
git commit -m "feat: merge workflows from dev to main for automation"
git push
```

### Step 2: Update All Workflows

For each repo (genie, hive, spark, forge, tools, omni):

1. Open `.github/workflows/link-to-roadmap.yml`
2. Find "Set project board fields" step
3. Replace with fixed version from above
4. Commit and push
5. Test with sample issue

### Step 3: Validate

Create test issue in each repo and verify all fields populate.

---

## Maintenance

### When to Update This Guide

- ✅ New field added to project board
- ✅ Field ID changes (rare but possible)
- ✅ New repo added to organization
- ✅ New project board created
- ✅ Workflow logic changes

### How to Get Current Field IDs

```bash
gh api graphql -f query='
{
  organization(login: "namastexlabs") {
    projectV2(number: 9) {
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
            dataType
          }
        }
      }
    }
  }
}' | jq .
```

---

## Summary

**Current State:**
- ✅ genie, omni: Working (partially - missing ETA/Expected Results)
- ⚠️ hive, tools: Infrastructure deployed, needs field ID fixes
- ❌ spark: Workflows on wrong branch
- ❌ forge: Needs workflow deployment

**To Fix:**
1. Update all workflows with correct field IDs (Status: `PVTSSF_lADOBvG2684BE-4Ezg2c5dY`)
2. Add ETA field population (Field: `PVTSSF_lADOBvG2684BE-4Ezg2dPxc`)
3. Add Expected Results extraction (Field: `PVTF_lADOBvG2684BE-4Ezg2c8aE`)
4. Merge spark workflows to main
5. Deploy forge workflows

**Result:**
- 🎯 Zero manual field population
- 🎯 All issues auto-appear in project board
- 🎯 Complete metadata for tracking
- 🎯 Consistent across all 6 repos
