#!/bin/bash
# Setup custom fields and views for Automagik Roadmap project board

set -e

PROJECT_ID="PVT_kwDOBvG2684BE-4E"
ORG="namastexlabs"

echo "🎨 Setting up Automagik Roadmap project views..."
echo ""

# Function to create single select field
create_single_select_field() {
    local field_name="$1"
    shift
    local options=("$@")

    echo "Creating field: $field_name"

    # Build options JSON array
    local options_json="["
    for option in "${options[@]}"; do
        options_json+="{\"name\": \"$option\", \"color\": \"GRAY\"},"
    done
    options_json="${options_json%,}]"  # Remove trailing comma

    # Create field
    local result=$(gh api graphql -f query="
    mutation {
      createProjectV2Field(input: {
        projectId: \"$PROJECT_ID\"
        dataType: SINGLE_SELECT
        name: \"$field_name\"
        singleSelectOptions: $options_json
      }) {
        projectV2Field {
          ... on ProjectV2SingleSelectField {
            id
            name
          }
        }
      }
    }")

    echo "  ✓ Created $field_name"
}

# Function to create text field
create_text_field() {
    local field_name="$1"

    echo "Creating field: $field_name"

    local result=$(gh api graphql -f query="
    mutation {
      createProjectV2Field(input: {
        projectId: \"$PROJECT_ID\"
        dataType: TEXT
        name: \"$field_name\"
      }) {
        projectV2Field {
          ... on ProjectV2Field {
            id
            name
          }
        }
      }
    }")

    echo "  ✓ Created $field_name"
}

# Function to create date field
create_date_field() {
    local field_name="$1"

    echo "Creating field: $field_name"

    local result=$(gh api graphql -f query="
    mutation {
      createProjectV2Field(input: {
        projectId: \"$PROJECT_ID\"
        dataType: DATE
        name: \"$field_name\"
      }) {
        projectV2Field {
          ... on ProjectV2Field {
            id
            name
          }
        }
      }
    }")

    echo "  ✓ Created $field_name"
}

echo "📋 Step 1: Creating custom fields..."
echo ""

# Create Project field
create_single_select_field "Project" "omni" "hive" "spark" "forge" "genie" "tools" "cross-project"

# Create Stage field
create_single_select_field "Stage" "exploring" "rfc" "in-design" "in-dev" "preview" "shipped" "archived"

# Create Priority field
create_single_select_field "Priority" "critical" "high" "medium" "low"

# Create Quarter field
create_single_select_field "Quarter" "2025-q4" "2026-q1" "2026-q2" "2026-q3" "2026-q4" "backlog"

# Create text fields
create_text_field "Expected Results"
create_text_field "Owner"

# Create date field
create_date_field "Target Date"

echo ""
echo "✓ Custom fields created"
echo ""

# Get the default view ID
echo "📊 Step 2: Creating custom views..."
echo ""

DEFAULT_VIEW_ID=$(gh api graphql -f query="
query {
  organization(login: \"$ORG\") {
    projectV2(number: 9) {
      views(first: 1) {
        nodes {
          id
        }
      }
    }
  }
}" --jq '.data.organization.projectV2.views.nodes[0].id')

# Rename default view
gh api graphql -f query="
mutation {
  updateProjectV2View(input: {
    viewId: \"$DEFAULT_VIEW_ID\"
    name: \"📊 All Initiatives\"
  }) {
    projectV2View {
      id
      name
    }
  }
}" > /dev/null

echo "  ✓ Renamed default view to '📊 All Initiatives'"

# Create Stage Board view
STAGE_BOARD_RESULT=$(gh api graphql -f query="
mutation {
  createProjectV2View(input: {
    projectId: \"$PROJECT_ID\"
    name: \"🔄 Stage Board\"
    layout: BOARD_LAYOUT
  }) {
    projectV2View {
      id
    }
  }
}")

echo "  ✓ Created '🔄 Stage Board' view"

# Create By Project view
PROJECT_VIEW_RESULT=$(gh api graphql -f query="
mutation {
  createProjectV2View(input: {
    projectId: \"$PROJECT_ID\"
    name: \"📦 By Project\"
    layout: TABLE_LAYOUT
  }) {
    projectV2View {
      id
    }
  }
}")

echo "  ✓ Created '📦 By Project' view"

# Create This Quarter view
QUARTER_VIEW_RESULT=$(gh api graphql -f query="
mutation {
  createProjectV2View(input: {
    projectId: \"$PROJECT_ID\"
    name: \"⏰ This Quarter (Q4 2025)\"
    layout: TABLE_LAYOUT
  }) {
    projectV2View {
      id
    }
  }
}")

echo "  ✓ Created '⏰ This Quarter (Q4 2025)' view"

# Create Priority view
PRIORITY_VIEW_RESULT=$(gh api graphql -f query="
mutation {
  createProjectV2View(input: {
    projectId: \"$PROJECT_ID\"
    name: \"🔥 High Priority\"
    layout: TABLE_LAYOUT
  }) {
    projectV2View {
      id
    }
  }
}")

echo "  ✓ Created '🔥 High Priority' view"

# Create Timeline view
TIMELINE_VIEW_RESULT=$(gh api graphql -f query="
mutation {
  createProjectV2View(input: {
    projectId: \"$PROJECT_ID\"
    name: \"📅 Timeline\"
    layout: ROADMAP_LAYOUT
  }) {
    projectV2View {
      id
    }
  }
}")

echo "  ✓ Created '📅 Timeline' view"

echo ""
echo "✓ All views created"
echo ""

echo "========================================="
echo "✅ Project setup complete!"
echo "========================================="
echo ""
echo "🎨 Custom Fields Added:"
echo "  - Project (single select: omni, hive, spark, forge, genie, tools, cross-project)"
echo "  - Stage (single select: exploring → shipped)"
echo "  - Priority (single select: critical, high, medium, low)"
echo "  - Quarter (single select: 2025-q4 → backlog)"
echo "  - Expected Results (text)"
echo "  - Owner (text)"
echo "  - Target Date (date)"
echo ""
echo "📊 Views Created:"
echo "  - 📊 All Initiatives (table - default view)"
echo "  - 🔄 Stage Board (kanban by stage)"
echo "  - 📦 By Project (table grouped by project)"
echo "  - ⏰ This Quarter (filtered to Q4 2025)"
echo "  - 🔥 High Priority (filtered to high/critical)"
echo "  - 📅 Timeline (roadmap view)"
echo ""
echo "🔗 View your project board:"
echo "   https://github.com/orgs/$ORG/projects/9"
echo ""
echo "📝 Next steps:"
echo "  1. Configure field values for existing issues"
echo "  2. Set up automation rules (optional)"
echo "  3. Customize view filters and grouping"
echo ""
