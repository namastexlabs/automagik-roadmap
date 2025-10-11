# Initiative Templates

Choose the right template based on your initiative's complexity, scope, and audience.

---

## 📋 Quick Selection Guide

| Template | Best For | Time to Complete | Sections |
|----------|----------|------------------|----------|
| **Minimal** | Small features, quick wins, internal tools | 15-30 min | 8 core sections |
| **Standard** | Most initiatives, cross-team features | 1-2 hours | 12 sections + flexibility |
| **Comprehensive** | Major product launches, customer-facing features | 4-8 hours | 20+ sections (full PRD) |

---

## 1️⃣ Minimal Initiative Template

**Use When:**
- ✅ Internal tooling or infrastructure improvements
- ✅ Well-understood problem with clear solution
- ✅ Small scope (1-2 weeks, single contributor)
- ✅ Low external dependencies
- ✅ Technical audience only

**What's Included:**
- RASCI (ownership)
- Overview (What/Why/Who)
- Goals & Impact
- Problem & Context
- Scope (In/Out)
- Timeline (phases)
- Risks & Mitigation
- Success Metrics

**Example Use Cases:**
- "Add retry logic to API gateway"
- "Implement logging for debugging"
- "Create CLI tool for developers"
- "Automate deployment scripts"

📄 **Template:** [`MINIMAL_INITIATIVE.md`](./MINIMAL_INITIATIVE.md)

---

## 2️⃣ Standard Initiative Template (Recommended Default)

**Use When:**
- ✅ Medium scope (2-8 weeks, small team)
- ✅ Cross-team coordination needed
- ✅ Some unknowns or trade-offs to consider
- ✅ Mix of technical + business stakeholders
- ✅ **Default choice for most initiatives**

**What's Added (vs Minimal):**
- 5W2H framework (full context)
- Links & related documents
- Non-Goals (scope boundaries)
- Options & Proposals comparison
- Dependencies tracking
- Detailed metrics (launch/growth/long-term)
- Open questions

**Example Use Cases:**
- "Multi-channel messaging system"
- "GitHub Actions workflow automation"
- "API rate limiting implementation"
- "Database migration strategy"

📄 **Template:** [`STANDARD_INITIATIVE.md`](./STANDARD_INITIATIVE.md)

---

## 3️⃣ Comprehensive Initiative Template (Full PRD)

**Use When:**
- ✅ Major product launches or features
- ✅ Customer/user-facing changes
- ✅ Large scope (2+ months, multiple teams)
- ✅ High complexity or many unknowns
- ✅ Regulatory/compliance requirements
- ✅ Needs executive/stakeholder buy-in

**What's Added (vs Standard):**
- Personas & Use Cases (user research)
- User Stories with BDD acceptance criteria (Given/When/Then)
- Non-functional requirements (performance, security, etc.)
- Technical architecture (detailed design)
- API specifications
- Testing & QA strategy
- Security & compliance
- Rollout plan (Alpha/Beta/GA)
- Communication plan
- Operational readiness
- Change log

**Example Use Cases:**
- "New customer-facing product feature"
- "Platform migration (e.g., AWS → GCP)"
- "Multi-tenant SaaS architecture"
- "Compliance initiative (GDPR, SOC2)"

📄 **Template:** [`COMPREHENSIVE_INITIATIVE.md`](./COMPREHENSIVE_INITIATIVE.md)

---

## 🎯 Decision Tree

```
Start: New initiative to document
  ↓
Q1: Is this customer/user-facing?
  ├─ Yes → Comprehensive Template
  └─ No → Continue
      ↓
Q2: Multiple teams involved?
  ├─ Yes → Standard Template
  └─ No → Continue
      ↓
Q3: Duration > 2 weeks?
  ├─ Yes → Standard Template
  └─ No → Minimal Template
```

---

## 💡 Tips for Success

### Starting Out
1. **Start minimal, expand later** - It's easier to add detail than remove it
2. **Copy-paste sections** - Upgrade from Minimal → Standard → Comprehensive as needed
3. **Skip empty sections** - Don't force content; leave sections out if not applicable

### Writing Quality Content
- **Be specific:** "Increase API throughput by 50%" not "Make API faster"
- **Add context:** Explain *why* decisions were made, not just *what*
- **Link everything:** PRs, docs, dashboards, related initiatives
- **Update regularly:** Keep status, metrics, and blockers current

### Common Pitfalls to Avoid
- ❌ Writing a novel (too much detail upfront)
- ❌ Skipping RASCI (unclear ownership)
- ❌ No metrics (can't measure success)
- ❌ No scope boundaries (feature creep)
- ❌ Ignoring risks (surprises hurt)

---

## 📝 Template Evolution

You can start with **Minimal** and evolve to **Standard** or **Comprehensive** as the initiative grows:

```
Week 1: Minimal Template
  ↓ (Scope increases, stakeholders join)
Week 3: Upgrade to Standard Template
  ↓ (Customer launch approved, compliance needed)
Week 6: Expand to Comprehensive Template
```

Just copy-paste sections from the larger templates as needed!

---

## 🚀 Creating an Initiative

### Option 1: CLI Script (Recommended)

```bash
# Use the create-initiative.sh script
cat your-initiative.md | ./scripts/create-initiative.sh \
  --title "Your Initiative Title" \
  --project (omni|hive|spark|forge|genie|tools|cross-project) \
  --stage (Wishlist|Exploring|RFC|Prioritization|Executing|Preview|Shipped|Archived) \
  --priority (critical|high|medium|low) \
  --quarter (2025-Q4|2026-Q1|2026-Q2|...|backlog) \
  --type (feature|enhancement|research|infrastructure|documentation) \
  --areas "area1,area2,area3"
```

### Option 2: GitHub Issue Form

Use the web UI to create an issue with the `initiative` label, and the workflow will auto-sync to the project board.

### Option 3: Manual

1. Copy the appropriate template
2. Fill in all `{placeholders}`
3. Create GitHub issue with `initiative` label
4. Issue will auto-sync to project board

---

## 🔗 Related Documentation

- [LLM Guide for Creating Initiatives](../../LLM-GUIDE.md)
- [Create Initiative Script](../../scripts/create-initiative.sh)
- [Project Board](https://github.com/orgs/namastexlabs/projects/9)
- [Labels Reference](../../docs/labels.md)

---

## 📊 Template Comparison Matrix

| Section | Minimal | Standard | Comprehensive |
|---------|:-------:|:--------:|:-------------:|
| **Core Sections** |
| One-line Summary | ✅ | ✅ | ✅ |
| RASCI | ✅ | ✅ | ✅ |
| Overview (What/Why/Who) | ✅ | ✅ | ✅ |
| Goals & Impact | ✅ | ✅ | ✅ |
| Problem & Context | ✅ | ✅ | ✅ |
| Scope (In/Out) | ✅ | ✅ | ✅ |
| Timeline & Phases | ✅ | ✅ | ✅ |
| Risks & Mitigation | ✅ | ✅ | ✅ |
| Success Metrics | ✅ | ✅ | ✅ |
| **Expanded Sections** |
| Links & Related Docs | ❌ | ✅ | ✅ |
| 5W2H (When/Where/How) | ❌ | ✅ | ✅ |
| Non-Goals | ❌ | ✅ | ✅ |
| Options & Proposals | ❌ | ✅ | ✅ |
| Dependencies | ❌ | ✅ | ✅ |
| Detailed Metrics | ❌ | ✅ | ✅ |
| **Comprehensive Only** |
| How Much (Cost) | ❌ | ❌ | ✅ |
| Personas & Use Cases | ❌ | ❌ | ✅ |
| User Stories (BDD) | ❌ | ❌ | ✅ |
| Non-Functional Reqs | ❌ | ❌ | ✅ |
| Technical Architecture | ❌ | ❌ | ✅ |
| API Specifications | ❌ | ❌ | ✅ |
| Testing & QA | ❌ | ❌ | ✅ |
| Security & Compliance | ❌ | ❌ | ✅ |
| Rollout & Communication | ❌ | ❌ | ✅ |
| Operational Readiness | ❌ | ❌ | ✅ |

---

## ❓ FAQ

**Q: Can I mix sections from different templates?**
A: Absolutely! Templates are guidelines, not rules. Copy sections that add value.

**Q: What if I don't know all the details yet?**
A: Use placeholders like `{TBD}` or `{To be determined after spike}`. Update as you learn.

**Q: Should I fill out every section?**
A: No! Skip sections that don't apply. Better to have 80% of relevant sections than 100% with fluff.

**Q: Can I change templates mid-initiative?**
A: Yes! Just copy-paste new sections into your existing issue. GitHub preserves history.

**Q: Do I need approval before creating an initiative?**
A: Depends on your team's process. Draft status lets you share early for feedback.

---

**Need help?** Check the [LLM Guide](../../LLM-GUIDE.md) or ask in `#automagik-roadmap` Slack channel.
