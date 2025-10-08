# Setup Automated Initiative Sync (2 Minutes!)

Since the `Automagik Roadmap Bot` app is public, you can install it directly - no need to create your own app!

## Quick Setup (Anyone Can Do This)

### Step 1: Install the App (1 minute)

1. Go to: **[Install Automagik Roadmap Bot](https://github.com/apps/automagik-roadmap-bot)** _(replace with actual app URL)_
2. Click **"Install"**
3. Choose your organization/account
4. Select **"Only select repositories"**
5. Choose the repository with your roadmap
6. Click **"Install"**

Done! The app is now installed.

### Step 2: Add Organization-Level Secrets (1 minute)

**If you're using the namastexlabs organization** (or any organization with the app already set up):

The secrets are already configured at organization level! Just ensure your repository has access:

1. Go to: `https://github.com/organizations/YOUR_ORG/settings/secrets/actions`
2. Find `PROJECT_APP_ID` and `PROJECT_APP_PRIVATE_KEY`
3. Click "Update" → Add your repository to the allowed list

**If you're setting this up for the first time in your org:**

Contact @vasconceloscezar to get the app credentials, then add them as organization secrets:

1. Go to: `https://github.com/organizations/YOUR_ORG/settings/secrets/actions`
2. Click "New organization secret"
3. Add `PROJECT_APP_ID` with value: `2083727`
4. Add `PROJECT_APP_PRIVATE_KEY` with the private key provided
5. Set "Repository access" to repos that need automation

### Step 3: Update Workflow (if using template)

If you created a new repo from the template, update `.github/workflows/sync-to-project.yml`:

```yaml
# Change this line:
owner: namastexlabs

# To your organization:
owner: YOUR_ORG_NAME
```

Also update the project URL:
```yaml
project-url: https://github.com/orgs/YOUR_ORG/projects/YOUR_PROJECT_NUMBER
```

### Step 4: Test It!

Create a test issue:
1. Use the "🎯 Roadmap Initiative" template
2. Fill out the form
3. Submit
4. Check that it appears on your project board with all fields populated!

## For Template Users

If someone uses this repo as a template, they have 2 options:

### Option A: Use the Public App (Recommended - 2 minutes)

1. Install `Automagik Roadmap Bot` on their repo
2. Add organization secrets (or ask for app credentials)
3. Update workflow with their org/project details
4. Done! Fully automated.

### Option B: Manual Script (Zero setup)

Just use the script after creating issues:

```bash
./scripts/sync-issue-to-project.sh <issue-number>
```

No app, no secrets needed!

## Organization-Level Secrets (Best Practice)

For organizations managing multiple roadmap repos:

1. **Add secrets at org level** (not per-repo):
   - `PROJECT_APP_ID`: `2083727`
   - `PROJECT_APP_PRIVATE_KEY`: Your private key

2. **Set access policy**: "Selected repositories"

3. **Add repos as needed**: Each new roadmap repo just needs to be added to the allow list

This way, you configure secrets **once** and all roadmap repos work automatically!

## Advantages of This Approach

✅ **One app for everyone** - No need to create individual apps
✅ **Org-level secrets** - Configure once, use everywhere
✅ **Template-friendly** - Users install app → add repo to secret access → done
✅ **Secure** - App has minimal permissions (issues + projects only)
✅ **No expiration** - Unlike PATs, the app token never expires

## Current Status (namastexlabs)

- [x] App created and public
- [x] App ID: `2083727`
- [ ] Organization secrets added
- [ ] Tested on issue #8

## Next Steps

1. **Add organization secrets** to namastexlabs org
2. **Test with issue #8** (should auto-sync)
3. **Document the app URL** so others can install it
