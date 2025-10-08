# LLM Guide: Creating Roadmap Initiatives

## Single Command

```bash
cat initiative.json | ./scripts/create-initiative-from-json.sh
```

## JSON Format

```json
{
  "title": "Your Initiative Title",
  "project": "omni|hive|spark|forge|genie|tools|cross-project",
  "stage": "Wishlist|Ideation|Exploring|RFC|Prioritization|Executing|Preview|Shipped",
  "priority": "critical|high|medium|low",
  "quarter": "2025-q4|2026-q1|2026-q2|2026-q3|2026-q4|2027-q1|backlog",
  "owner": "github-username",
  "type": "feature|enhancement|research|infrastructure|documentation",
  "areas": ["api", "mcp", "cli", "workflows", "agents"],
  "description": "Problem, solution, and impact description",
  "expected_results": [
    "Measurable result 1",
    "Measurable result 2"
  ],
  "success_criteria": [
    "How we know it's complete 1",
    "How we know it's complete 2"
  ]
}
```

## Example

```bash
echo '{
  "title": "Slack Integration",
  "project": "omni",
  "stage": "Exploring",
  "priority": "high",
  "quarter": "2026-q1",
  "owner": "vasconceloscezar",
  "type": "feature",
  "areas": ["mcp", "messaging"],
  "description": "Add Slack support to Omni for team communication",
  "expected_results": [
    "Slack bot connects and sends messages",
    "Thread support working",
    "File attachments supported"
  ],
  "success_criteria": [
    "Can send/receive messages",
    "100% uptime over 1 week",
    "Team using it daily"
  ]
}' | ./scripts/create-initiative-from-json.sh
```

## What Happens

1. **Script creates GitHub issue** with proper template format
2. **GitHub Actions workflow** (automatic):
   - Adds to project board
   - Sets all 8 custom fields (Project, Stage, Priority, ETA, Status, Owner, Target Date, Expected Results)
   - Applies all labels
   - Posts confirmation comment

## Field Defaults

If not provided:
- `stage`: "Exploring"
- `priority`: "medium"
- `quarter`: "backlog"
- `owner`: "vasconceloscezar"
- `type`: "feature"
- `responsible`: same as `owner`
- `accountable`: same as `owner`

## Projects

- `omni` - Multi-channel messaging platform
- `hive` - Multi-agent orchestration
- `spark` - AI-powered job scheduling
- `forge` - AI code review & planning
- `genie` - CLI workspace manager
- `tools` - Smart tools with SLMs
- `cross-project` - Cross-cutting initiatives

## Areas

Common areas: `api`, `mcp`, `cli`, `workflows`, `agents`, `messaging`, `testing`, `docs`, `infrastructure`

## Stages

- **Wishlist** - Planning phase, not started
- **Ideation** - Brainstorming ideas
- **Exploring** - Research and investigation
- **RFC** - Proposal/design doc
- **Prioritization** - Being prioritized
- **Executing** - Active development
- **Preview** - Beta/testing
- **Shipped** - Complete and live

## That's It!

One JSON input → Complete initiative on project board 🎉
