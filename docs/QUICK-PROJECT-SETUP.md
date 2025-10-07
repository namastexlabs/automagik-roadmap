# 🚀 Quick Project Board Setup

**Current Status:** Basic fields exist, custom fields need to be added manually.

---

## ✅ What Already Exists

Your project board already has:
- **Title** (built-in)
- **Status** (Todo, In Progress, Done)
- **Labels** (synced from issues)
- **Assignees** (built-in)
- **Expected Results** (text field - created via API)
- **Owner** (text field - created via API)
- **Target Date** (date field - created via API)

---

## 📋 Add Custom Fields (5 minutes)

You need to add these 4 single-select fields manually:

### 1. Add "Project" Field

1. Go to https://github.com/orgs/namastexlabs/projects/9
2. Click the **"+"** button next to field headers (top right)
3. Click **"+ New field"**
4. Name: **Project**
5. Field type: **Single select**
6. Add these options (one by one):
   - `omni`
   - `hive`
   - `spark`
   - `forge`
   - `genie`
   - `tools`
   - `cross-project`
7. Click **"Save"**

### 2. Add "Stage" Field

1. Click **"+ New field"** again
2. Name: **Stage**
3. Field type: **Single select**
4. Add these options:
   - `exploring` 🟡
   - `rfc` 🟠
   - `in-design` 🟣
   - `in-dev` 🔵
   - `preview` 🟢
   - `shipped` ✅
   - `archived` ⚫
5. Click **"Save"**

**Tip:** You can assign colors to each option for visual clarity!

### 3. Add "Priority" Field

1. Click **"+ New field"**
2. Name: **Priority**
3. Field type: **Single select**
4. Add these options:
   - `critical` 🔴
   - `high` 🟠
   - `medium` 🟡
   - `low` 🟢
5. Click **"Save"**

### 4. Add "Quarter" Field

1. Click **"+ New field"**
2. Name: **Quarter**
3. Field type: **Single select**
4. Add these options:
   - `2025-q4`
   - `2026-q1`
   - `2026-q2`
   - `2026-q3`
   - `2026-q4`
   - `backlog`
5. Click **"Save"**

---

## 🎨 Create Better Views (10 minutes)

### View 1: All Initiatives (Rename existing)

1. Click on "View 1" (current default view)
2. Click the "..." menu → **"Rename"**
3. Name: **📊 All Initiatives**
4. Make sure these columns are visible:
   - Title
   - Status
   - Labels
   - Project *(once created)*
   - Stage *(once created)*
   - Priority *(once created)*
   - Quarter *(once created)*
   - Owner
   - Expected Results
5. Click **"Save changes"**

### View 2: Stage Board (Kanban)

1. Click **"+ New view"** (top right)
2. Name: **🔄 Stage Board**
3. Layout: **Board**
4. Click **"Group by"** → Select **"Stage"** *(once Stage field is created)*
5. Cards should show:
   - Title
   - Labels
   - Project
   - Priority
   - Owner
6. Click **"Save changes"**

### View 3: By Project (Grouped Table)

1. Click **"+ New view"**
2. Name: **📦 By Project**
3. Layout: **Table**
4. Click **"Group by"** → Select **"Project"**
5. Visible columns:
   - Title
   - Stage
   - Priority
   - Quarter
   - Status
   - Owner
6. Sort by: **Priority** (drag Priority to the top of sort options)
7. Click **"Save changes"**

### View 4: This Quarter (Filtered)

1. Click **"+ New view"**
2. Name: **⏰ Q4 2025**
3. Layout: **Table**
4. Click **"Filter"** → Add filter:
   - **Quarter** equals **2025-q4**
5. Group by: **Stage**
6. Visible columns:
   - Title
   - Project
   - Priority
   - Status
   - Owner
   - Expected Results
7. Click **"Save changes"**

### View 5: High Priority (Filtered)

1. Click **"+ New view"**
2. Name: **🔥 High Priority**
3. Layout: **Table**
4. Click **"Filter"** → Add filter:
   - **Priority** equals **critical** OR **high**
5. Group by: **Project**
6. Sort by: **Priority** (critical first)
7. Click **"Save changes"**

### View 6: Timeline (Roadmap)

1. Click **"+ New view"**
2. Name: **📅 Timeline**
3. Layout: **Roadmap**
4. Date field: **Target Date**
5. Group by: **Quarter**
6. Zoom level: **Quarters**
7. Click **"Save changes"**

---

## ✏️ Fill in Field Values for Existing Issues

For each of the 5 example issues (#1-#5), fill in the custom fields:

### Issue #1: Omni - Slack Integration
- **Project:** omni
- **Stage:** exploring
- **Priority:** high
- **Quarter:** 2026-q1
- **Owner:** TBD
- **Status:** Todo

### Issue #2: Hive - Multi-Agent Swarm
- **Project:** hive
- **Stage:** rfc
- **Priority:** high
- **Quarter:** 2026-q1
- **Owner:** TBD
- **Status:** Todo

### Issue #3: Cross-Project - Unified Auth
- **Project:** cross-project
- **Stage:** exploring
- **Priority:** critical
- **Quarter:** 2025-q4
- **Owner:** TBD
- **Status:** Todo

### Issue #4: Tools - MCP Marketplace
- **Project:** tools
- **Stage:** in-design
- **Priority:** medium
- **Quarter:** 2026-q1
- **Owner:** TBD
- **Status:** Todo

### Issue #5: Spark - Intelligent Scheduling
- **Project:** spark
- **Stage:** exploring
- **Priority:** medium
- **Quarter:** 2026-q2
- **Owner:** TBD
- **Status:** Todo

---

## 🎯 Quick Checklist

- [ ] Add **Project** field (single select, 7 options)
- [ ] Add **Stage** field (single select, 7 options with colors)
- [ ] Add **Priority** field (single select, 4 options with colors)
- [ ] Add **Quarter** field (single select, 6 options)
- [ ] Rename "View 1" to "📊 All Initiatives"
- [ ] Create "🔄 Stage Board" (Board grouped by Stage)
- [ ] Create "📦 By Project" (Table grouped by Project)
- [ ] Create "⏰ Q4 2025" (Table filtered by quarter)
- [ ] Create "🔥 High Priority" (Table filtered by priority)
- [ ] Create "📅 Timeline" (Roadmap view)
- [ ] Fill in custom field values for 5 existing issues

---

## 💡 Tips

**Color Coding:**
- Use emoji prefixes for field options (🔴 critical, 🟡 exploring, etc.)
- Assign colors in GitHub's color picker when creating options
- This makes the board visually scannable at a glance

**Automation Ideas:**
- You can later set up GitHub Actions to auto-populate fields based on labels
- Use "Workflows" in the project settings to auto-set Status when issues close

**Keyboard Shortcuts:**
- Press `?` in the project view to see all keyboard shortcuts
- Use `Tab` to quickly navigate between fields when editing

---

**Estimated Time:** 15-20 minutes total

Once done, your project board will be fully functional with all the views and fields! 🚀
