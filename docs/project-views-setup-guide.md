# 📊 Project Views Setup Guide

This guide helps you create custom views for the Automagik Roadmap project board.

**Custom fields have already been created via script. This guide covers creating views manually.**

---

## ✅ Custom Fields (Already Created)

The following custom fields are available in your project:

- **Project** (single select): omni, hive, spark, forge, genie, tools, cross-project
- **Stage** (single select): exploring, rfc, in-design, in-dev, preview, shipped, archived
- **Priority** (single select): critical, high, medium, low
- **Quarter** (single select): 2025-q4, 2026-q1, 2026-q2, 2026-q3, 2026-q4, backlog
- **Expected Results** (text)
- **Owner** (text)
- **Target Date** (date)

---

## 📊 Recommended Views

### 1. 📊 All Initiatives (Table View)

**Purpose:** Complete overview of all initiatives with all fields visible.

**Setup:**
1. Go to https://github.com/orgs/namastexlabs/projects/9
2. Rename "View 1" to "📊 All Initiatives"
3. Layout: **Table**
4. Visible columns:
   - Title
   - Status
   - Project
   - Stage
   - Priority
   - Quarter
   - Owner
   - Expected Results
   - Labels
5. Group by: None
6. Sort by: Created (newest first)

---

### 2. 🔄 Stage Board (Kanban View)

**Purpose:** Kanban board organized by development stage.

**Setup:**
1. Click "+ New view"
2. Name: "🔄 Stage Board"
3. Layout: **Board**
4. Group by: **Stage**
5. Column field: Stage
6. Visible fields:
   - Title
   - Project
   - Priority
   - Quarter
   - Owner
7. Sort by: Priority (high to low)

---

### 3. 📦 By Project (Table View)

**Purpose:** All initiatives grouped by project.

**Setup:**
1. Click "+ New view"
2. Name: "📦 By Project"
3. Layout: **Table**
4. Group by: **Project**
5. Visible columns:
   - Title
   - Stage
   - Priority
   - Quarter
   - Owner
   - Expected Results
6. Sort by: Priority (high to low), then Created

---

### 4. ⏰ This Quarter (Table View)

**Purpose:** Focus on current quarter (Q4 2025) initiatives.

**Setup:**
1. Click "+ New view"
2. Name: "⏰ This Quarter (Q4 2025)"
3. Layout: **Table**
4. Filter: **Quarter** is **2025-q4**
5. Visible columns:
   - Title
   - Project
   - Stage
   - Priority
   - Owner
   - Status
   - Expected Results
6. Group by: Stage
7. Sort by: Priority (high to low)

---

### 5. 🔥 High Priority (Table View)

**Purpose:** Critical and high priority initiatives across all projects.

**Setup:**
1. Click "+ New view"
2. Name: "🔥 High Priority"
3. Layout: **Table**
4. Filter: **Priority** is **critical** OR **high**
5. Visible columns:
   - Title
   - Project
   - Stage
   - Quarter
   - Owner
   - Expected Results
6. Group by: Project
7. Sort by: Priority (critical first), then Quarter

---

### 6. 📅 Timeline (Roadmap View)

**Purpose:** Visual timeline of initiatives by quarter.

**Setup:**
1. Click "+ New view"
2. Name: "📅 Timeline"
3. Layout: **Roadmap**
4. Date field: **Target Date**
5. Group by: **Quarter**
6. Zoom: Quarters
7. Visible fields:
   - Title
   - Project
   - Stage
   - Priority
   - Owner

---

## 🎨 Color Coding Recommendations

### Priority Colors
When setting up priority field colors:
- 🔴 **Critical**: Red
- 🟠 **High**: Orange
- 🟡 **Medium**: Yellow
- 🟢 **Low**: Green

### Stage Colors
When setting up stage field colors:
- 🟡 **Exploring**: Yellow
- 🟠 **RFC**: Orange
- 🟣 **In Design**: Purple
- 🔵 **In Dev**: Blue
- 🟢 **Preview**: Light Green
- ✅ **Shipped**: Dark Green
- ⚫ **Archived**: Gray

---

## 📋 Quick Setup Checklist

- [ ] Rename default view to "📊 All Initiatives"
- [ ] Create "🔄 Stage Board" (Kanban by Stage)
- [ ] Create "📦 By Project" (Table grouped by Project)
- [ ] Create "⏰ This Quarter" (Filtered to Q4 2025)
- [ ] Create "🔥 High Priority" (Filtered to critical/high)
- [ ] Create "📅 Timeline" (Roadmap view)
- [ ] Customize field colors (Priority, Stage)
- [ ] Set default view to "📊 All Initiatives"

---

## 🔧 Filling in Custom Fields

For each existing issue:

1. **Project**: Set based on the `project:*` label
2. **Stage**: Set based on the `stage:*` label
3. **Priority**: Set based on the `priority:*` label
4. **Quarter**: Set based on the `quarter:*` label
5. **Owner**: Copy from RASCI "Responsible" field
6. **Expected Results**: Copy from issue description
7. **Target Date**: Set end of target quarter

---

## 💡 Tips

### Automation
You can set up GitHub Actions to automatically:
- Set **Project** field based on `project:*` labels
- Set **Stage** field based on `stage:*` labels
- Set **Priority** field based on `priority:*` labels
- Set **Quarter** field based on `quarter:*` labels

### Field Syncing
Consider creating a workflow that syncs labels to custom fields:

```yaml
# .github/workflows/sync-project-fields.yml
name: Sync Project Fields
on:
  issues:
    types: [labeled, unlabeled]
jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - name: Sync fields from labels
        uses: actions/github-script@v7
        # ... implementation
```

---

## 📚 Additional Resources

- [GitHub Projects Documentation](https://docs.github.com/en/issues/planning-and-tracking-with-projects)
- [Project Views Guide](https://docs.github.com/en/issues/planning-and-tracking-with-projects/customizing-views-in-your-project)
- [Custom Fields Guide](https://docs.github.com/en/issues/planning-and-tracking-with-projects/understanding-fields)

---

*Last updated: 2025-10-07*
