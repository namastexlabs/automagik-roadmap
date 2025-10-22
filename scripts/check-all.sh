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
echo "Press Enter to continue to next check..."
read -r

# 2. Label Validation
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🏷️  CHECK 2/5: LABEL CONSISTENCY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
"$SCRIPT_DIR/validate-labels.sh"
echo ""
echo "Press Enter to continue to next check..."
read -r

# 3. Quarter Validation
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📅 CHECK 3/5: QUARTER/ETA VALIDATION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
"$SCRIPT_DIR/validate-quarters.sh"
echo ""
echo "Press Enter to continue to next check..."
read -r

# 4. Initiative Completeness
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 CHECK 4/5: INITIATIVE COMPLETENESS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
"$SCRIPT_DIR/check-initiative-completeness.sh" $DETAILED
echo ""
echo "Press Enter to continue to final check..."
read -r

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
echo "💡 For automated runs (skip pauses), pipe to grep or redirect output:"
echo "   ./scripts/check-all.sh 2>&1 | tee health-report.txt"
echo ""
