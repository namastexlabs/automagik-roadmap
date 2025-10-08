# GitHub App Setup for Automated Initiative Sync

Quick guide to set up the GitHub App for automated project board synchronization.

## What You Need

The workflow uses a GitHub App (recommended by GitHub) instead of Personal Access Tokens because:
- ✅ More secure (scoped permissions)
- ✅ No expiration (unlike PATs that expire every 90 days)
- ✅ Not tied to individual users
- ✅ Better audit trail

## Setup Steps (5 minutes)

### 1. Create GitHub App

Go to: https://github.com/organizations/namastexlabs/settings/apps/new

Fill in:
- **Name**: `Automagik Roadmap Bot`
- **Description**: `Automates initiative creation and project board sync`
- **Homepage URL**: `https://github.com/namastexlabs/automagik-roadmap`
- **Webhook**: Uncheck "Active" (not needed)

**Permissions**:
- Repository permissions → **Issues**: Read and write
- Organization permissions → **Projects**: Read and write ⭐ **CRITICAL!**

**Install on**: Only on this account (namastexlabs)

Click **Create GitHub App**

### 2. Generate Private Key

On the app settings page:
1. Scroll to "Private keys"
2. Click **"Generate a private key"**
3. Save the `.pem` file that downloads

### 3. Note the App ID

At the top of the app settings page, copy the **App ID** (e.g., `123456`)

### 4. Install App on Repository

1. Click "Install App" in left sidebar
2. Click "Install" next to `namastexlabs`
3. Select "Only select repositories" → Choose `automagik-roadmap`
4. Click "Install"

### 5. Add Secrets to Repository

Go to: https://github.com/namastexlabs/automagik-roadmap/settings/secrets/actions

**Add Secret 1**:
- Name: `PROJECT_APP_ID`
- Value: Your App ID from step 3

**Add Secret 2**:
- Name: `PROJECT_APP_PRIVATE_KEY`
- Value: Open the `.pem` file in text editor, copy ENTIRE contents including:
  ```
  -----BEGIN RSA PRIVATE KEY-----
  ... all the content ...
  -----END RSA PRIVATE KEY-----
  ```

### 6. Test It

1. Create test issue: https://github.com/namastexlabs/automagik-roadmap/issues/new/choose
2. Select "🎯 Roadmap Initiative"
3. Fill any values and submit
4. Check it appears on: https://github.com/orgs/namastexlabs/projects/9

## Troubleshooting

**"Resource not accessible by integration"**
→ App doesn't have Projects permission. Go to app settings → Permissions → Set Projects to "Read and write"

**"Bad credentials"**
→ Private key not copied correctly. Make sure you copied the ENTIRE `.pem` file including headers/footers

**"App not installed"**
→ Install app on repository: https://github.com/organizations/namastexlabs/settings/installations

## Security

- Private key stored only in GitHub Secrets ✅
- App scoped to single repository ✅
- Minimal permissions (issues + projects only) ✅
- Annual key rotation recommended (set calendar reminder)

## Done! 🎉

After setup, creating initiatives is fully automated:
1. Fill web form
2. Submit
3. Everything auto-populates on project board!

View automation runs: https://github.com/namastexlabs/automagik-roadmap/actions/workflows/sync-to-project.yml
