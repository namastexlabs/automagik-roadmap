# Project Board Field IDs - Quick Reference

**Project:** [Automagik Roadmap #9](https://github.com/orgs/namastexlabs/projects/9)
**Project ID:** `PVT_kwDOBvG2684BE-4E`

---

## 📌 Copy-Paste Ready Values

### Field IDs (For Workflow Code)

```javascript
const PROJECT_ID = 'PVT_kwDOBvG2684BE-4E';

const FIELD_IDS = {
  stage: 'PVTSSF_lADOBvG2684BE-4Ezg2c_hc',
  status: 'PVTSSF_lADOBvG2684BE-4Ezg2c5dY',
  project: 'PVTSSF_lADOBvG2684BE-4Ezg2c_ec',
  eta: 'PVTSSF_lADOBvG2684BE-4Ezg2dPxc',
  priority: 'PVTSSF_lADOBvG2684BE-4Ezg2c_kA',
  expectedResults: 'PVTF_lADOBvG2684BE-4Ezg2c8aE',
  owner: 'PVTF_lADOBvG2684BE-4Ezg2c8aI',
  targetDate: 'PVTF_lADOBvG2684BE-4Ezg2c8aM'
};
```

### Stage Options

```javascript
const STAGE_OPTIONS = {
  wishlist: 'd4964f90',
  exploring: 'f5c85cef',
  rfc: 'cd5acf90',
  prioritization: 'a3c2913b',
  executing: '073f61b0',      // DEFAULT
  preview: 'b572947d',
  shipped: '3d0b8ddd',
  archived: '0e15297c'
};
```

### Status Options

```javascript
const STATUS_OPTIONS = {
  todo: 'f75ad846',           // DEFAULT
  inProgress: '47fc9ee4',
  done: '98236657'
};
```

### Project Options

```javascript
const PROJECT_OPTIONS = {
  'automagik-omni': '9c171c42',
  'automagik-hive': 'a28ceeff',
  'automagik-spark': '0a588179',
  'automagik-forge': '2a9e974c',
  'automagik-genie': '93d4bd3c',
  'automagik-tools': 'f00fd26a',
  'cross-project': 'c1f1ab29'
};
```

### ETA Options

```javascript
const ETA_OPTIONS = {
  backlog: '88ae1263',
  '2025-Q4': 'a35fa4f5',      // DEFAULT
  '2026-Q1': 'a0cccfe6',
  '2026-Q2': 'cf1026cb',
  '2026-Q3': '3c402b09',
  '2026-Q4': 'ec810765',
  '2027-Q1': '4ac5ad3f'
};
```

### Priority Options

```javascript
const PRIORITY_OPTIONS = {
  critical: '700a2c58',
  high: 'd7a47ff6',
  medium: '79c50f9e',
  low: 'c7f229a8'
};
```

---

## ⚠️ Common Mistakes

### ❌ WRONG Field IDs (OLD - DON'T USE)

```javascript
// These are WRONG - from old workflows
status: 'PVTSSF_lADOBvG2684BE-4Ezg2dPw0',  // ❌ OLD
stageExecuting: '2f83e636',                 // ❌ OLD
project: 'PVTSSF_lADOBvG2684BE-4Ezg2c_ec'  // This one is correct
```

### ✅ CORRECT Field IDs (CURRENT - USE THESE)

```javascript
// These are CORRECT - use these
status: 'PVTSSF_lADOBvG2684BE-4Ezg2c5dY',  // ✅ CORRECT
stageExecuting: '073f61b0',                 // ✅ CORRECT
project: 'PVTSSF_lADOBvG2684BE-4Ezg2c_ec'  // ✅ CORRECT
```

---

## 📋 GraphQL Mutation Templates

### Set Stage Field

```graphql
mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: "PVT_kwDOBvG2684BE-4E"
    itemId: "PVTI_xxx"  # Get from project items query
    fieldId: "PVTSSF_lADOBvG2684BE-4Ezg2c_hc"
    value: { singleSelectOptionId: "073f61b0" }  # Executing
  }) {
    projectV2Item { id }
  }
}
```

### Set Status Field

```graphql
mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: "PVT_kwDOBvG2684BE-4E"
    itemId: "PVTI_xxx"
    fieldId: "PVTSSF_lADOBvG2684BE-4Ezg2c5dY"
    value: { singleSelectOptionId: "f75ad846" }  # Todo
  }) {
    projectV2Item { id }
  }
}
```

### Set Project Field

```graphql
mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: "PVT_kwDOBvG2684BE-4E"
    itemId: "PVTI_xxx"
    fieldId: "PVTSSF_lADOBvG2684BE-4Ezg2c_ec"
    value: { singleSelectOptionId: "93d4bd3c" }  # genie
  }) {
    projectV2Item { id }
  }
}
```

### Set ETA Field

```graphql
mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: "PVT_kwDOBvG2684BE-4E"
    itemId: "PVTI_xxx"
    fieldId: "PVTSSF_lADOBvG2684BE-4Ezg2dPxc"
    value: { singleSelectOptionId: "a35fa4f5" }  # 2025-Q4
  }) {
    projectV2Item { id }
  }
}
```

### Set Priority Field

```graphql
mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: "PVT_kwDOBvG2684BE-4E"
    itemId: "PVTI_xxx"
    fieldId: "PVTSSF_lADOBvG2684BE-4Ezg2c_kA"
    value: { singleSelectOptionId: "d7a47ff6" }  # high
  }) {
    projectV2Item { id }
  }
}
```

### Set Expected Results (Text Field)

```graphql
mutation {
  updateProjectV2ItemFieldValue(input: {
    projectId: "PVT_kwDOBvG2684BE-4E"
    itemId: "PVTI_xxx"
    fieldId: "PVTF_lADOBvG2684BE-4Ezg2c8aE"
    value: { text: "Labels, Templates, Workflows" }
  }) {
    projectV2Item { id }
  }
}
```

---

## 🔍 How to Get Item ID for an Issue

```bash
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
}' | jq -r '.data.organization.projectV2.items.nodes[] | select(.content.repository.name == "automagik-genie" and .content.number == 27) | .id'
```

**Replace:**
- `automagik-genie` → your repo name
- `27` → your issue number

**Returns:** `PVTI_lADOBvG2684BE-4Ezgfv6g4` (example)

---

## 🔄 How to Refresh Field IDs (If They Change)

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
}' | jq -r '
  .data.organization.projectV2.fields.nodes[] |
  if .dataType == "SINGLE_SELECT" then
    "\(.name):\n  Field ID: \(.id)\n  Options:\n    " + ([.options[] | "    \(.name): \(.id)"] | join("\n    "))
  else
    "\(.name):\n  Field ID: \(.id)\n  Type: \(.dataType)"
  end
'
```

---

## 📊 Field Summary Table

| Field | Type | Field ID | Default Value | Auto-Populated? |
|-------|------|----------|---------------|-----------------|
| **Stage** | Single Select | `PVTSSF_lADOBvG2684BE-4Ezg2c_hc` | Executing (`073f61b0`) | ✅ Yes |
| **Status** | Single Select | `PVTSSF_lADOBvG2684BE-4Ezg2c5dY` | Todo (`f75ad846`) | ✅ Yes |
| **Project** | Single Select | `PVTSSF_lADOBvG2684BE-4Ezg2c_ec` | Repo name | ✅ Yes |
| **ETA** | Single Select | `PVTSSF_lADOBvG2684BE-4Ezg2dPxc` | 2025-Q4 (`a35fa4f5`) | ✅ Yes (with fix) |
| **Priority** | Single Select | `PVTSSF_lADOBvG2684BE-4Ezg2c_kA` | From labels | ✅ Yes (with fix) |
| **Expected Results** | Text | `PVTF_lADOBvG2684BE-4Ezg2c8aE` | From acceptance criteria | ✅ Yes (with fix) |
| **Owner** | Text | `PVTF_lADOBvG2684BE-4Ezg2c8aI` | - | ❌ Manual |
| **Target Date** | Date | `PVTF_lADOBvG2684BE-4Ezg2c8aM` | - | ❌ Manual |

---

## 💡 Quick Tips

1. **Always use the Status field ID:** `PVTSSF_lADOBvG2684BE-4Ezg2c5dY` (not the old one)
2. **Stage "Executing" option ID:** `073f61b0` (not `2f83e636`)
3. **Default ETA:** `a35fa4f5` (2025-Q4)
4. **Text fields** use `{ text: "value" }`, not `{ singleSelectOptionId: "..." }`
5. **Single select fields** use `{ singleSelectOptionId: "id" }`

---

## 🆘 Error Messages

| Error | Cause | Solution |
|-------|-------|----------|
| "The single select option Id does not belong to the field" | Wrong option ID for that field | Check option IDs above |
| "Could not resolve to a node with the global id" | Wrong field ID | Use correct field ID from above |
| Field updates silently fail | Using text syntax on single-select field | Use `singleSelectOptionId` not `text` |

---

**Last Updated:** 2025-10-10
**Verified Working:** genie, omni repos
**Needs Fix:** hive, spark, forge, tools repos
