#!/bin/bash
# Run all roadmap health checks in sequence
# Usage: ./check-all.sh [--detailed]

set -e

DETAILED=${1:-""}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║          🏥 AUTOMAGIK ROADMAP HEALTH CHECK SUITE            ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "Running comprehensive roadmap analysis..."
echo ""

# 1. Board Health
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 CHECK 1/5: BOARD HEALTH"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
"$SCRIPT_DIR/check-board-health.sh"
echo ""

# 2. Label Validation
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🏷️  CHECK 2/5: LABEL CONSISTENCY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
"$SCRIPT_DIR/validate-labels.sh"
echo ""

# 3. Quarter Validation
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📅 CHECK 3/5: QUARTER/ETA VALIDATION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
"$SCRIPT_DIR/validate-quarters.sh"
echo ""

# 4. Initiative Completeness
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 CHECK 4/5: INITIATIVE COMPLETENESS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
"$SCRIPT_DIR/check-initiative-completeness.sh" $DETAILED
echo ""

# 5. Cross-Repo Sync
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔄 CHECK 5/5: CROSS-REPO SYNC"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
"$SCRIPT_DIR/check-cross-repo-sync.sh"
echo ""

# Summary
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    ✅ ALL CHECKS COMPLETE                    ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "📊 Quick Actions:"
echo "  - Review flagged issues above"
echo "  - Update missing labels/fields"
echo "  - Archive stale initiatives"
echo "  - Export to CSV: python3 scripts/export-to-csv.py"
echo ""
echo "💡 Save output to file:"
echo "   ./scripts/check-all.sh 2>&1 | tee health-report.txt"
echo ""
