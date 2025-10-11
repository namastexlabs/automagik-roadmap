# Workflow Automation Fixes for Auto Field Population

## 1. Fix Spark Branch Issue

**Problem:** Workflows deployed to `dev` branch, not `main` (default branch)

**Solution:**
```bash
cd /home/cezar/automagik/automagik-spark
git checkout main
git merge dev  # or cherry-pick workflow commits
git push
```

---

## 2. Update Workflow with Correct Field IDs

**Current workflow has WRONG field IDs. Update all `link-to-roadmap.yml` files:**

### Correct Field IDs:
```yaml
fields:
  stage: 'PVTSSF_lADOBvG2684BE-4Ezg2c_hc'
  status: 'PVTSSF_lADOBvG2684BE-4Ezg2c5dY'  # ← FIX THIS (was wrong)
  project: 'PVTSSF_lADOBvG2684BE-4Ezg2c_ec'
  eta: 'PVTSSF_lADOBvG2684BE-4Ezg2dPxc'     # ← ADD THIS
  expected_results: 'PVTF_lADOBvG2684BE-4Ezg2c8aE'  # ← ADD THIS

options:
  stage_executing: '073f61b0'  # ← FIX THIS (was wrong)
  status_todo: 'f75ad846'
  eta_2025q4: 'a35fa4f5'       # ← ADD THIS
```

---

## 3. Add ETA Field Population to Workflow

**Add new step after "Set project board fields":**

```yaml
- name: Set ETA field
  uses: actions/github-script@v7
  with:
    github-token: ${{ steps.generate-token.outputs.token }}
    script: |
      const projectId = 'PVT_kwDOBvG2684BE-4E';
      const itemId = '${{ steps.add-to-board.outputs.project_item_id }}';
      const etaField = 'PVTSSF_lADOBvG2684BE-4Ezg2dPxc';

      if (!itemId || itemId === '') {
        console.log('Skipping ETA - item not in project');
        return;
      }

      // Default to 2025-Q4 or parse from issue body
      const eta = 'a35fa4f5'; // 2025-Q4

      try {
        await github.graphql(`
          mutation {
            updateProjectV2ItemFieldValue(input: {
              projectId: "${projectId}"
              itemId: "${itemId}"
              fieldId: "${etaField}"
              value: { singleSelectOptionId: "${eta}" }
            }) {
              projectV2Item { id }
            }
          }
        `);
        console.log('✓ Set ETA to 2025-Q4');
      } catch (error) {
        console.log('Warning: Could not set ETA:', error.message);
      }
```

---

## 4. Add Expected Results Field Population

**Add new step to extract acceptance criteria:**

```yaml
- name: Set Expected Results field
  uses: actions/github-script@v7
  with:
    github-token: ${{ steps.generate-token.outputs.token }}
    script: |
      const projectId = 'PVT_kwDOBvG2684BE-4E';
      const itemId = '${{ steps.add-to-board.outputs.project_item_id }}';
      const resultsField = 'PVTF_lADOBvG2684BE-4Ezg2c8aE';

      if (!itemId || itemId === '') {
        console.log('Skipping Expected Results - item not in project');
        return;
      }

      const body = context.payload.issue.body || '';

      // Extract acceptance criteria categories
      const criteriaMatch = body.match(/### ✅ Acceptance Criteria\n+([\s\S]*?)\n+###/);
      if (!criteriaMatch) {
        console.log('No acceptance criteria found');
        return;
      }

      // Extract category headers (**Category:**)
      const categories = criteriaMatch[1]
        .match(/\*\*[^*]+:\*\*/g)
        ?.map(cat => cat.replace(/\*\*/g, '').replace(/:$/, ''))
        .join(', ') || 'Various acceptance criteria';

      // Limit to 300 chars
      const results = categories.substring(0, 300);

      try {
        await github.graphql(`
          mutation {
            updateProjectV2ItemFieldValue(input: {
              projectId: "${projectId}"
              itemId: "${itemId}"
              fieldId: "${resultsField}"
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
```

---

## 5. Ensure Labels Exist Before Creating Issues

**Run label-sync workflow BEFORE creating issues:**

```bash
# For each repo
gh workflow run label-sync.yml --repo namastexlabs/automagik-{repo}

# Wait for completion
sleep 10

# Then create issue with planned-feature label
gh issue create --label "planned-feature,priority:high" ...
```

---

## 6. Project Field Option IDs Reference

**Store these in a central location for all repos:**

```yaml
# .github/project-fields.yml
project_id: 'PVT_kwDOBvG2684BE-4E'

fields:
  stage: 'PVTSSF_lADOBvG2684BE-4Ezg2c_hc'
  status: 'PVTSSF_lADOBvG2684BE-4Ezg2c5dY'
  project: 'PVTSSF_lADOBvG2684BE-4Ezg2c_ec'
  eta: 'PVTSSF_lADOBvG2684BE-4Ezg2dPxc'
  expected_results: 'PVTF_lADOBvG2684BE-4Ezg2c8aE'
  priority: 'PVTSSF_lADOBvG2684BE-4Ezg2c_kA'

stage_options:
  executing: '073f61b0'
  wishlist: 'd4964f90'
  exploring: 'f5c85cef'
  rfc: 'cd5acf90'
  prioritization: 'a3c2913b'
  preview: 'b572947d'
  shipped: '3d0b8ddd'
  archived: '0e15297c'

status_options:
  todo: 'f75ad846'
  in_progress: '47fc9ee4'
  done: '98236657'

project_options:
  omni: '9c171c42'
  hive: 'a28ceeff'
  spark: '0a588179'
  forge: '2a9e974c'
  genie: '93d4bd3c'
  tools: 'f00fd26a'
  cross_project: 'c1f1ab29'

eta_options:
  2025_q4: 'a35fa4f5'
  2026_q1: 'a0cccfe6'
  backlog: '88ae1263'

priority_options:
  critical: '700a2c58'
  high: 'd7a47ff6'
  medium: '79c50f9e'
  low: 'c7f229a8'
```

---

## Summary

**To make it fully automatic:**

1. ✅ Merge spark workflows to `main` branch
2. ✅ Fix field IDs in all `link-to-roadmap.yml` files
3. ✅ Add ETA field population step
4. ✅ Add Expected Results extraction step
5. ✅ Ensure label-sync runs before issue creation
6. ✅ Document field IDs centrally

**Then future issues will auto-populate:**
- Stage → "Executing" (from initiative state)
- Status → "Todo" (default)
- Project → Repo name (from repo)
- ETA → "2025-Q4" (default or from body)
- Expected Results → Acceptance criteria categories (from body)
