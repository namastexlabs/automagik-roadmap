# Setup Guide: Project Board Automation

This guide walks through setting up the `ADD_TO_PROJECT_PAT` secret required for automated initiative creation.

## Why This Is Needed

The standard `GITHUB_TOKEN` provided by GitHub Actions doesn't have permissions to:
- Add items to organization-level projects
- Update custom fields on project items via GraphQL API

Therefore, we need a **Personal Access Token (PAT)** with elevated permissions.

## Step-by-Step Setup

### 1. Create Fine-Grained Personal Access Token

1. Go to: https://github.com/settings/tokens?type=beta
2. Click **"Generate new token"** → **"Generate new token (fine-grained)"**
3. Fill in token details:
   - **Token name**: `automagik-roadmap-project-automation`
   - **Expiration**: 90 days (recommended) or 1 year
   - **Description**: "Automated project board sync for automagik-roadmap"
   - **Resource owner**: `namastexlabs`

4. **Repository access**:
   - Select **"Only select repositories"**
   - Choose: `namastexlabs/automagik-roadmap`

5. **Repository permissions**:
   - **Issues**: Read and write
   - **Metadata**: Read-only (auto-selected)

6. **Organization permissions**:
   - **Projects**: Read and write (CRITICAL!)

7. Click **"Generate token"** and **COPY THE TOKEN** (you won't see it again!)

### 2. Add Secret to Repository

1. Go to: https://github.com/namastexlabs/automagik-roadmap/settings/secrets/actions
2. Click **"New repository secret"**
3. Name: `ADD_TO_PROJECT_PAT`
4. Value: Paste the token you copied
5. Click **"Add secret"**

### 3. Verify Setup

Create a test issue to verify automation works:

```bash
# From your terminal
gh issue create \
  --repo namastexlabs/automagik-roadmap \
  --label initiative \
  --title "[Initiative] Test: Automation Verification" \
  --body "Testing automated project board sync"
```

Or use the web UI:
1. Go to: https://github.com/namastexlabs/automagik-roadmap/issues/new/choose
2. Select "🎯 Roadmap Initiative"
3. Fill out form
4. Submit

Check that:
- ✅ Issue appears on project board: https://github.com/orgs/namastexlabs/projects/9
- ✅ All custom fields are populated
- ✅ Labels are auto-applied
- ✅ Comment appears confirming sync

### 4. Troubleshooting

#### Workflow fails with "Input required and not supplied: github-token"

**Cause**: `ADD_TO_PROJECT_PAT` secret doesn't exist or has wrong name

**Fix**:
- Go to repo secrets: https://github.com/namastexlabs/automagik-roadmap/settings/secrets/actions
- Verify secret named exactly `ADD_TO_PROJECT_PAT` exists
- If not, create it following step 2 above

#### Workflow fails with "Resource not accessible by integration"

**Cause**: Token doesn't have `Projects: Read and write` permission

**Fix**:
- Delete the old token
- Create new token with correct permissions (step 1)
- Update secret with new token (step 2)

#### Workflow fails with "Could not resolve to a ProjectV2"

**Cause**: Wrong project number in workflow file

**Fix**:
```bash
# Verify project number
gh api graphql -f query='
query {
  organization(login: "namastexlabs") {
    projectsV2(first: 10) {
      nodes {
        number
        title
        url
      }
    }
  }
}' --jq '.data.organization.projectsV2.nodes[] | "\(.number) - \(.title)"'
```

Should show: `9 - Automagik Roadmap`

#### Issue added to board but fields not populated

**Cause**: Field IDs or option IDs may have changed

**Fix**: Get current field IDs:
```bash
gh api graphql -f query='
query {
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
          }
        }
      }
    }
  }
}' --jq '.data.organization.projectV2.fields.nodes[]'
```

Compare with field IDs in `.github/workflows/sync-to-project.yml` and update if needed.

## Token Security Best Practices

### Rotation Schedule

- **Recommended**: Rotate every 90 days
- **Maximum**: Rotate every 365 days
- Set calendar reminder before expiration

### Least Privilege

The token should have ONLY:
- ✅ Read/write access to `automagik-roadmap` repo
- ✅ Read/write access to organization projects
- ❌ NO access to other repositories
- ❌ NO admin permissions

### Monitoring

Check token usage monthly:
1. Go to: https://github.com/settings/tokens
2. Find `automagik-roadmap-project-automation` token
3. Click to view usage/activity
4. Verify no unexpected activity

### Revocation

If token is compromised:
1. Go to: https://github.com/settings/tokens
2. Find the token
3. Click **"Revoke"**
4. Generate new token immediately
5. Update `ADD_TO_PROJECT_PAT` secret

## Alternative: GitHub App (Advanced)

For production use, consider creating a GitHub App instead of PAT:

**Benefits**:
- More secure (scoped to specific events)
- No user association (survives user changes)
- Better audit logs
- No expiration concerns

**Setup** (for later):
1. Create GitHub App: https://github.com/organizations/namastexlabs/settings/apps
2. Grant project write permissions
3. Install app on roadmap repo
4. Use app authentication in workflow

See: https://docs.github.com/en/apps/creating-github-apps/about-creating-github-apps/about-creating-github-apps

## Current Status

- [ ] `ADD_TO_PROJECT_PAT` secret created
- [ ] Token has correct permissions (repo + projects)
- [ ] Test issue successfully synced to board
- [ ] All custom fields populated
- [ ] Calendar reminder for token rotation set

Once all checkboxes are complete, automation is fully operational! 🎉

## Related Documentation

- **Automated Initiative Creation**: [docs/automated-initiative-creation.md](./automated-initiative-creation.md)
- **GitHub Fine-Grained PATs**: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token
- **Projects GraphQL API**: https://docs.github.com/en/issues/planning-and-tracking-with-projects/automating-your-project/using-the-api-to-manage-projects
