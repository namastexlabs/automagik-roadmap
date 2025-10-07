# 🔗 Cross-Repository References

Best practices for linking between the Automagik roadmap and project repositories.

---

## Why Cross-Repository References?

The Automagik ecosystem spans multiple repositories:
- **automagik-roadmap** - Strategic planning and initiatives
- **automagik-omni** - Implementation repository
- **automagik-hive** - Implementation repository
- **automagik-spark** - Implementation repository
- **automagik-forge** - Implementation repository
- **automagik-genie** - Implementation repository
- **automagik-tools** - Implementation repository

**Cross-repo references:**
- 🔍 Provide context and traceability
- 🤝 Connect planning to execution
- 📊 Enable dependency tracking
- ✅ Improve transparency

---

## Reference Types

### 1. Roadmap → Implementation Repository

**When to use:** Link roadmap initiatives to implementation work.

**Syntax:**
```markdown
## Related Repositories
- Main Implementation: namastexlabs/automagik-omni#123
- Documentation: namastexlabs/automagik-docs#45
- Related Work: namastexlabs/automagik-spark (no specific issue)
```

**GitHub Auto-Links:**
- `namastexlabs/automagik-omni#123` - Links to issue #123 in omni repo
- `namastexlabs/automagik-omni#123 (comment)` - Links to specific comment
- `namastexlabs/automagik-omni@abc123` - Links to specific commit

---

### 2. Implementation Repository → Roadmap

**When to use:** Reference strategic context from implementation PRs/issues.

**In PR descriptions:**
```markdown
## Roadmap Context
Part of roadmap initiative: namastexlabs/automagik-roadmap#42

See detailed specification: [Wish Document](https://github.com/namastexlabs/automagik-roadmap/blob/main/projects/omni/wishes/slack-integration/slack-integration-wish.md)
```

**In commit messages:**
```bash
git commit -m "feat: add Slack integration handler

Implements namastexlabs/automagik-roadmap#42 (Slack Integration)
See wish: projects/omni/wishes/slack-integration/

Co-authored-by: Automagik Genie 🧞 <genie@namastex.ai>"
```

---

### 3. Wish Documents → PRs

**When to use:** Track implementation PRs from wish documents.

**In wish document:**
```markdown
## 🔗 Related Work

### Implementation
- Core handler: namastexlabs/automagik-omni#234
- Tests: namastexlabs/automagik-omni#235
- Documentation: namastexlabs/automagik-omni#236

### Dependencies
- MCP protocol upgrade: namastexlabs/automagik-tools#89
- Shared auth: namastexlabs/automagik-roadmap#12

### Documentation
- User guide: namastexlabs/automagik-docs#56
- API reference: namastexlabs/automagik-docs#57
```

---

### 4. Cross-Project Dependencies

**When to use:** Track dependencies between different Automagik projects.

**In roadmap issue:**
```markdown
## Dependencies

### Blocked By
- namastexlabs/automagik-roadmap#123 (MCP protocol upgrade)
- namastexlabs/automagik-tools#45 (Tool builder API)

### Blocks
- namastexlabs/automagik-roadmap#156 (Hive-Omni integration)
- namastexlabs/automagik-spark#78 (Automated messaging)

### Related
- namastexlabs/automagik-roadmap#234 (Similar work in Forge)
```

**GitHub will auto-link these and show references.**

---

## GitHub Auto-Linking Syntax

### Issues and PRs
```markdown
# Same repo
#123                                    → Issue/PR #123 in current repo

# Other repo (short form)
automagik-omni#123                     → Issue/PR #123 in omni repo (same org)

# Other repo (full form)
namastexlabs/automagik-omni#123        → Issue/PR #123 in omni repo (explicit)

# External org
otherorg/otherrepo#123                 → Issue/PR in external repo
```

### Commits
```markdown
abc1234                                → Commit in current repo
automagik-omni@abc1234                → Commit in omni repo
namastexlabs/automagik-omni@abc1234   → Commit (explicit)
```

### Users and Teams
```markdown
@username                              → GitHub user
@namastexlabs/team                     → GitHub team
```

### Comparisons
```markdown
namastexlabs/automagik-omni@v1.0...v2.0  → Compare versions
```

---

## Reference Patterns by Context

### Pattern 1: Roadmap Issue → Multiple Implementation Repos

**Scenario:** Cross-project initiative affecting multiple repos.

**Roadmap Issue:**
```markdown
# [Initiative] Unified Authentication System

## Description
Implement shared auth system across all Automagik projects.

## Related Repositories

### Implementation
- Core library: namastexlabs/automagik-infra#45
- Omni integration: namastexlabs/automagik-omni#123
- Hive integration: namastexlabs/automagik-hive#234
- Spark integration: namastexlabs/automagik-spark#345

### Documentation
- Architecture: namastexlabs/automagik-docs#67
- Migration guide: namastexlabs/automagik-docs#68
```

**Implementation PRs reference back:**
```markdown
# In automagik-omni#123
Part of unified auth initiative: namastexlabs/automagik-roadmap#42
Depends on core library: namastexlabs/automagik-infra#45
```

---

### Pattern 2: Wish Document → Detailed Implementation Tracking

**Scenario:** Complex feature with multiple PRs.

**Wish Document:**
```markdown
## 🔗 Related Work

### Group A: Core Implementation
- Handler implementation: namastexlabs/automagik-omni#234 ✅
- Message parser: namastexlabs/automagik-omni#235 🚧
- Error handling: namastexlabs/automagik-omni#236 ⏳

### Group B: Integration
- MCP tool registration: namastexlabs/automagik-tools#89 🚧
- Webhook setup: namastexlabs/automagik-omni#237 ⏳

### Group C: Testing & Docs
- Integration tests: namastexlabs/automagik-omni#238 ⏳
- User documentation: namastexlabs/automagik-docs#56 ⏳
```

**Status indicators:**
- ✅ Merged
- 🚧 In Progress
- ⏳ Pending

---

### Pattern 3: Project README → Roadmap Filtered View

**Scenario:** Project-specific roadmap overview.

**Project README (e.g., projects/omni/README.md):**
```markdown
# Omni - Omnichannel MCP Server

**Repository:** [namastexlabs/automagik-omni](https://github.com/namastexlabs/automagik-omni)
**Documentation:** [docs.automagik.ai/omni](https://docs.automagik.ai/omni)

## 🗺️ Roadmap

View Omni-specific initiatives on the roadmap:
- [All Omni Initiatives](https://github.com/namastexlabs/automagik-roadmap/issues?q=is%3Aissue+label%3Aproject%3Aomni)
- [Executing](https://github.com/namastexlabs/automagik-roadmap/issues?q=is%3Aissue+label%3Aproject%3Aomni+label%3AExecuting)
- [Shipped](https://github.com/namastexlabs/automagik-roadmap/issues?q=is%3Aissue+label%3Aproject%3Aomni+label%3AShipped)
- [This Quarter](https://github.com/namastexlabs/automagik-roadmap/issues?q=is%3Aissue+label%3Aproject%3Aomni+label%3Aquarter%3A2025-q4)

## 📂 Detailed Wishes

Browse detailed specifications:
- [wishes/](https://github.com/namastexlabs/automagik-roadmap/tree/main/projects/omni/wishes)
```

---

### Pattern 4: Implementation PR → Roadmap + Wish

**Scenario:** PR implementing part of a wish.

**PR Description:**
```markdown
# feat: add Slack message handler

## Roadmap Context
- Initiative: namastexlabs/automagik-roadmap#42
- Wish: [slack-integration](https://github.com/namastexlabs/automagik-roadmap/blob/main/projects/omni/wishes/slack-integration/slack-integration-wish.md)
- Execution Group: Group A - Core Implementation

## Changes
- Implements Slack message handler
- Adds unit tests
- Updates MCP tool registration

## Testing
- Evidence: See wish qa/group-a/test-results.json
- Manual testing: Verified with test Slack workspace

## Related PRs
- Depends on: namastexlabs/automagik-tools#89 (MCP upgrade)
- Blocks: #235 (Integration tests)
```

---

## URL Patterns

### Linking to Specific Files
```markdown
[Wish Document](https://github.com/namastexlabs/automagik-roadmap/blob/main/projects/omni/wishes/slack-integration/slack-integration-wish.md)
```

### Linking to Folders
```markdown
[Omni Wishes](https://github.com/namastexlabs/automagik-roadmap/tree/main/projects/omni/wishes)
```

### Linking to Filtered Issues
```markdown
[Omni + In Dev](https://github.com/namastexlabs/automagik-roadmap/issues?q=is%3Aissue+label%3Aproject%3Aomni+label%3Astage%3Ain-dev)
```

### Linking to Project Board Views
```markdown
[Roadmap Timeline](https://github.com/orgs/namastexlabs/projects/1/views/1)
[This Quarter](https://github.com/orgs/namastexlabs/projects/1/views/4)
```

---

## Automation with References

### Closing Issues via Commits

**Magic keywords** in commit messages or PRs:
```bash
# These keywords auto-close issues when PR merges
git commit -m "feat: add feature

Closes namastexlabs/automagik-roadmap#42
Fixes namastexlabs/automagik-omni#123"
```

**Keywords that auto-close:**
- `Closes #123`
- `Fixes #123`
- `Resolves #123`
- `Implements #123`

**Keywords that just reference:**
- `Part of #123`
- `Related to #123`
- `See #123`

---

### GitHub Actions with Cross-Repo References

**Automatically comment on roadmap when PR merges:**

```yaml
# In automagik-omni/.github/workflows/roadmap-update.yml
name: Update Roadmap
on:
  pull_request:
    types: [closed]
jobs:
  update:
    if: github.event.pull_request.merged == true
    runs-on: ubuntu-latest
    steps:
      - name: Comment on roadmap issue
        uses: actions/github-script@v7
        with:
          script: |
            const prBody = context.payload.pull_request.body || '';
            const match = prBody.match(/namastexlabs\/automagik-roadmap#(\d+)/);
            if (match) {
              const issueNumber = match[1];
              await github.rest.issues.createComment({
                owner: 'namastexlabs',
                repo: 'automagik-roadmap',
                issue_number: issueNumber,
                body: `✅ Implementation merged: ${context.payload.pull_request.html_url}`
              });
            }
```

---

## Best Practices

### ✅ Do:
- Always reference roadmap initiatives from implementation PRs
- Use full repo paths for clarity (`namastexlabs/automagik-omni#123`)
- Update wish documents with PR links as they're created
- Link to specific files/folders using full URLs
- Use magic keywords to auto-close issues

### ❌ Don't:
- Use relative references that break when copied elsewhere
- Forget to link implementation back to roadmap
- Create circular dependencies
- Use shortened URLs that lose context

---

## Reference Checklist

### When Creating Roadmap Initiative:
- [ ] Specify related repositories in issue template
- [ ] Link to existing related work if any
- [ ] Identify cross-project dependencies

### When Creating Wish:
- [ ] Link wish to roadmap issue
- [ ] Link roadmap issue to wish folder

### When Creating Implementation PR:
- [ ] Reference roadmap initiative
- [ ] Link to wish document (if applicable)
- [ ] Note dependencies on other PRs
- [ ] Update wish with PR link

### When Closing Initiative:
- [ ] Verify all implementation PRs merged
- [ ] Update wish to "Complete"
- [ ] Document final state in roadmap issue

---

## Examples

### Example 1: Simple Feature
```markdown
# Roadmap Issue #42
Related: namastexlabs/automagik-omni#123

# Implementation PR (automagik-omni#123)
Implements: namastexlabs/automagik-roadmap#42
```

### Example 2: Complex Multi-Repo Initiative
```markdown
# Roadmap Issue #42: Unified Auth
- Core: namastexlabs/automagik-infra#45
- Omni: namastexlabs/automagik-omni#123
- Hive: namastexlabs/automagik-hive#234
- Docs: namastexlabs/automagik-docs#67

# Each implementation PR references back:
Part of namastexlabs/automagik-roadmap#42
Depends on namastexlabs/automagik-infra#45
```

---

## Tools & Utilities

### GitHub CLI for Cross-Repo References

```bash
# View cross-references for an issue
gh issue view 42 --repo namastexlabs/automagik-roadmap

# Search issues across multiple repos
gh search issues "label:project:omni" \
  --repo namastexlabs/automagik-roadmap \
  --repo namastexlabs/automagik-omni
```

### VSCode Extension
- **GitHub Pull Requests and Issues** - Auto-complete issue references

---

## Related Documentation

- [Stage Definitions](stage-definitions.md) - Initiative lifecycle
- [Wish Template](wish-template.md) - Detailed specifications
- [Label Guide](label-guide.md) - Label taxonomy

---

*Last updated: 2025-10-07*
