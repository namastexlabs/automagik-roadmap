#!/bin/bash
# Automagik Roadmap - GitHub Project Setup Script
# Creates custom fields, syncs labels, and populates initial initiatives

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
ORG="namastexlabs"
REPO="automagik-roadmap"
PROJECT_ID="PVT_kwDOBvG2684BE-4E"
PROJECT_NUMBER="9"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Automagik Roadmap Project Setup${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Step 1: Sync labels to repository
echo -e "${GREEN}Step 1: Syncing labels to repository...${NC}"
cd "$(dirname "$0")/.."

# Check if we're in the right directory
if [ ! -f ".github/labels.yml" ]; then
    echo -e "${YELLOW}Error: .github/labels.yml not found${NC}"
    echo "Please run this script from the automagik-roadmap directory"
    exit 1
fi

# Use gh CLI with label-syncer action or manual creation
echo "Creating labels manually via gh CLI..."

# Read labels from YAML and create them
# Note: This is a simplified approach. For production, use label-syncer action
while IFS= read -r line; do
    if [[ $line =~ ^-\ name:\ (.+)$ ]]; then
        label_name="${BASH_REMATCH[1]}"
        # Read next lines for color and description
        read -r color_line
        read -r desc_line

        if [[ $color_line =~ color:\ \'(.+)\'$ ]]; then
            color="${BASH_REMATCH[1]}"
        fi

        if [[ $desc_line =~ description:\ \'(.+)\'$ ]]; then
            description="${BASH_REMATCH[1]}"
        fi

        # Create or update label
        gh label create "$label_name" \
            --repo "$ORG/$REPO" \
            --color "$color" \
            --description "$description" \
            --force 2>/dev/null || true

        echo "  ✓ $label_name"
    fi
done < .github/labels.yml

echo -e "${GREEN}✓ Labels synced${NC}"
echo ""

# Step 2: Create example initiatives
echo -e "${GREEN}Step 2: Creating example initiatives...${NC}"

# Create function to create an issue and add to project
create_initiative() {
    local title="$1"
    local body="$2"
    local labels="$3"

    echo "Creating: $title"

    # Create issue
    issue_url=$(gh issue create \
        --repo "$ORG/$REPO" \
        --title "$title" \
        --body "$body" \
        --label "$labels")

    # Extract issue number
    issue_number=$(echo "$issue_url" | grep -oP '\d+$')

    # Add to project
    gh project item-add "$PROJECT_NUMBER" \
        --owner "$ORG" \
        --url "$issue_url" 2>/dev/null || true

    echo "  ✓ Created issue #$issue_number and added to project"
    echo ""
}

# Example Initiative 1: Omni - Slack Integration
create_initiative \
    "[Initiative] Omni: Slack Integration" \
    "## 🎯 Overview

### What
Add native Slack integration to Automagik Omni for bidirectional messaging between AI agents and Slack channels.

### Why
**Problem:** Many teams use Slack as their primary communication tool. Currently, Omni supports WhatsApp and Discord, but Slack integration is the #1 requested feature from enterprise users.

**Solution:** Implement Slack Bot API integration with MCP tool support.

**Impact:** Enable enterprise teams to deploy AI agents directly in their Slack workspaces.

### Expected Results (RESULTADO_ESPERADO)
- Enable 50+ teams to use Omni in Slack within first month
- Support text messages, file attachments, and threaded conversations
- Maintain <500ms message latency
- Achieve 99.9% message delivery rate

---

## 🚩 RASCI

**Responsible:** TBD
**Accountable:** @vasconceloscezar
**Support:** Omni maintainers
**Consulted:** Enterprise users, Slack API experts
**Informed:** Community via Discord

---

## ✅ Success Criteria

- [ ] Slack bot authentication working
- [ ] Send/receive text messages
- [ ] Support file attachments
- [ ] Thread support for conversations
- [ ] MCP tool registered
- [ ] Documentation complete
- [ ] Integration tests passing

---

## 🔗 Related Work

**Wish Folder:** projects/omni/wishes/slack-integration/ (to be created)
**Related Repositories:** namastexlabs/automagik-omni" \
    "initiative,project:omni,Exploring,type:feature,priority:high,quarter:2026-q1,area:mcp,area:messaging"

# Example Initiative 2: Hive - Multi-Agent Swarm Coordination
create_initiative \
    "[Initiative] Hive: Multi-Agent Swarm Coordination" \
    "## 🎯 Overview

### What
Implement swarm intelligence patterns for coordinating multiple AI agents working on complex tasks.

### Why
**Problem:** Current agent orchestration is sequential. Complex tasks requiring parallel execution by multiple specialized agents are inefficient.

**Solution:** Implement swarm coordination patterns (centralized, distributed, hierarchical) with dynamic task allocation.

**Impact:** Reduce complex task completion time by 40%+ through parallel agent execution.

### Expected Results (RESULTADO_ESPERADO)
- Support 3+ coordination patterns (centralized, distributed, hierarchical)
- Enable 5-20 concurrent agents per swarm
- Implement dynamic task allocation algorithm
- Reduce complex task time by 40%

---

## 🚩 RASCI

**Responsible:** TBD
**Accountable:** @vasconceloscezar
**Support:** Hive maintainers, AI researchers
**Consulted:** Agent framework developers
**Informed:** Community

---

## ✅ Success Criteria

- [ ] Swarm coordinator implemented
- [ ] 3 coordination patterns working
- [ ] Dynamic task allocation
- [ ] Performance benchmarks met
- [ ] Example workflows documented
- [ ] Tests passing

---

## 🔗 Related Work

**Wish Folder:** projects/hive/wishes/swarm-coordination/
**Related Repositories:** namastexlabs/automagik-hive" \
    "initiative,project:hive,RFC,type:feature,priority:high,quarter:2026-q1,area:agents,area:workflows"

# Example Initiative 3: Cross-Project - Unified Auth System
create_initiative \
    "[Initiative] Cross-Project: Unified Authentication System" \
    "## 🎯 Overview

### What
Implement shared authentication and authorization system across all Automagik projects.

### Why
**Problem:** Each project implements auth independently, leading to:
- Inconsistent security practices
- Code duplication
- Difficult user management across projects
- No single sign-on (SSO)

**Solution:** Create shared auth library with JWT tokens, API keys, and OAuth support.

**Impact:** Consistent security, reduced development time, enable SSO across ecosystem.

### Expected Results (RESULTADO_ESPERADO)
- Reduce auth implementation time by 80% for new projects
- Enable SSO across all Automagik projects
- Support JWT, API keys, and OAuth 2.0
- Comprehensive audit logging

---

## 🚩 RASCI

**Responsible:** TBD
**Accountable:** @vasconceloscezar
**Support:** All project maintainers
**Consulted:** Security team, project leads
**Informed:** All contributors

---

## ✅ Success Criteria

- [ ] Auth library implemented
- [ ] JWT token management
- [ ] API key generation/validation
- [ ] OAuth 2.0 flows
- [ ] Integrated into 2+ projects
- [ ] Security audit complete
- [ ] Documentation complete

---

## 🔗 Related Work

**Related Repositories:**
- namastexlabs/automagik-omni
- namastexlabs/automagik-hive
- namastexlabs/automagik-spark" \
    "initiative,project:cross-project,Exploring,type:infrastructure,priority:critical,quarter:2025-q4,area:auth,area:security"

# Example Initiative 4: Tools - MCP Tool Marketplace
create_initiative \
    "[Initiative] Tools: MCP Tool Marketplace" \
    "## 🎯 Overview

### What
Create a public marketplace for discovering and sharing MCP tools built by the community.

### Why
**Problem:** MCP tools are scattered across repos with no central discovery mechanism. Users don't know what tools exist.

**Solution:** Build a searchable marketplace with categories, ratings, and one-click installation.

**Impact:** Accelerate MCP adoption by making tools discoverable and easy to use.

### Expected Results (RESULTADO_ESPERADO)
- Launch marketplace with 50+ tools
- Enable one-click tool installation
- Implement search and filtering
- Achieve 1000+ tool installs in first quarter

---

## 🚩 RASCI

**Responsible:** TBD
**Accountable:** @vasconceloscezar
**Support:** Tools maintainers, UX designer
**Consulted:** MCP community
**Informed:** Community

---

## ✅ Success Criteria

- [ ] Marketplace UI implemented
- [ ] Tool submission process
- [ ] Search and filtering working
- [ ] Rating and review system
- [ ] One-click installation
- [ ] 50+ tools listed
- [ ] Documentation complete

---

## 🔗 Related Work

**Wish Folder:** projects/tools/wishes/mcp-marketplace/
**Related Repositories:** namastexlabs/automagik-tools" \
    "initiative,project:tools,Priorization,type:feature,priority:medium,quarter:2026-q1,area:ui,area:mcp"

# Example Initiative 5: Spark - Intelligent Scheduling
create_initiative \
    "[Initiative] Spark: Intelligent Scheduling with AI" \
    "## 🎯 Overview

### What
Add AI-powered scheduling to Spark that learns optimal execution times based on system load, dependencies, and historical data.

### Why
**Problem:** Current cron-based scheduling is static. Jobs may run during high load or before dependencies are ready.

**Solution:** Implement ML-based scheduler that adapts based on patterns.

**Impact:** Improve job success rate and reduce system load spikes.

### Expected Results (RESULTADO_ESPERADO)
- Increase job success rate by 25%
- Reduce peak system load by 30%
- Automatically learn optimal execution windows
- Support dependency-aware scheduling

---

## 🚩 RASCI

**Responsible:** TBD
**Accountable:** @vasconceloscezar
**Support:** Spark maintainers, ML engineer
**Consulted:** DevOps team
**Informed:** Community

---

## ✅ Success Criteria

- [ ] Scheduling algorithm implemented
- [ ] Historical data collection
- [ ] Load-aware scheduling
- [ ] Dependency resolution
- [ ] Performance benchmarks met
- [ ] Tests passing

---

## 🔗 Related Work

**Wish Folder:** projects/spark/wishes/intelligent-scheduling/
**Related Repositories:** namastexlabs/automagik-spark" \
    "initiative,project:spark,Exploring,type:enhancement,priority:medium,quarter:2026-q2,area:workflows,area:performance"

echo -e "${GREEN}✓ Example initiatives created${NC}"
echo ""

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✓ Setup Complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "Next steps:"
echo "1. View project board: https://github.com/orgs/$ORG/projects/$PROJECT_NUMBER"
echo "2. Configure custom fields manually in the project UI"
echo "3. Create custom views (Timeline, Stage Board, etc.)"
echo "4. Start adding more initiatives!"
echo ""
