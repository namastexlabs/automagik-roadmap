# Add GitHub App Secrets

Quick guide to add the secrets for your GitHub App.

## Your App Details

- **App ID**: `2083727`
- **Client ID**: `Iv23linBYsqABcayeGZZ`
- **Private Key**: You downloaded the `.pem` file

## Option 1: Organization-Level Secrets (RECOMMENDED)

This way, the secrets work for ALL repos in the namastexlabs org that need them.

### Add Secrets:

1. Go to: https://github.com/organizations/namastexlabs/settings/secrets/actions

2. Click **"New organization secret"**

3. **First Secret - App ID:**
   - Name: `PROJECT_APP_ID`
   - Secret: `2083727`
   - Repository access: **"Selected repositories"**
     - Choose: `automagik-roadmap` (and any other roadmap repos)
   - Click "Add secret"

4. **Second Secret - Private Key:**
   - Name: `PROJECT_APP_PRIVATE_KEY`
   - Secret: Open the `.pem` file in a text editor, copy **ENTIRE contents**
   - Repository access: **"Selected repositories"**
     - Choose: `automagik-roadmap` (and any other roadmap repos)
   - Click "Add secret"

### Verify:

```bash
# Check if secrets are accessible (will show true/false, not values)
gh api repos/namastexlabs/automagik-roadmap/actions/secrets
```

## Option 2: Repository-Level Secrets

If you only want this for the current repo:

1. Go to: https://github.com/namastexlabs/automagik-roadmap/settings/secrets/actions

2. Click **"New repository secret"**

3. Add both secrets as above (same names and values)

## Test the Setup

After adding secrets, trigger the workflow on issue #8:

```bash
# Re-trigger the workflow by adding a label
gh issue edit 8 --add-label "test-sync"
```

Or create a new test issue:

```bash
# Use the web form
open https://github.com/namastexlabs/automagik-roadmap/issues/new/choose
```

The workflow should now run successfully and sync to the project board!

## Troubleshooting

### How to check if secrets exist:

```bash
gh secret list --repo namastexlabs/automagik-roadmap
```

Should show:
- PROJECT_APP_ID
- PROJECT_APP_PRIVATE_KEY

### How to update a secret:

```bash
# For repository secret
gh secret set PROJECT_APP_ID --body "2083727" --repo namastexlabs/automagik-roadmap

# For organization secret (if you have org admin access)
gh secret set PROJECT_APP_ID --body "2083727" --org namastexlabs
```

### Workflow still failing?

Check the workflow run logs:
```bash
gh run list --workflow=sync-to-project.yml --limit 1
# Get the ID from above, then:
gh run view <ID> --log
```

Look for errors like:
- "Bad credentials" → Private key incorrect
- "Resource not accessible" → App doesn't have permissions
- "App not installed" → Install the app on the repo

## Security Notes

✅ **Keep the private key secure** - It's in GitHub Secrets (encrypted)
✅ **Don't commit the .pem file** - Store backup in password manager
✅ **Rotate annually** - Generate new key and update secret
