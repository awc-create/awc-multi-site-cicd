# Multi-Site CI/CD Pipeline & Vercel Setup Guide

This repository manages automated CI/CD deployments for multiple Next.js projects, enabling preview and production deployments via GitHub Actions and Vercel.

## Getting Started

## 1. Setting Up GitHub Actions & CI/CD Integration

To integrate your project into the multi-site CI/CD pipeline, follow these steps:

### Step 1: Create a Vercel Access Token

1. Go to [Vercel Tokens](https://vercel.com/account/tokens).
2. Click "Create", name it `cicd-vercel-token`, and select:
   - Full Access
   - No Expiration (or set an appropriate limit)
3. Copy the token.
4. Go to your CI/CD repository (`awc-multi-site-cicd`) → Settings → Secrets and Variables → Actions.
5. Add a new secret:

```bash
Name: VERCEL_TOKEN Value: (Paste your Vercel token here)

```

### Step 2: Set Up Your Project Repository for CI/CD

1. Go to your project repo (e.g., `madaaircon`) locally and run:

```bash
git pull origin main
mkdir -p .github/workflows

```
2. Create the CI/CD trigger workflow in .github/workflows/trigger-deploy.yml:

```yaml
name: Trigger CI/CD Deployment

on:
  push:
    branches:
      - main
      - 'feat/**'
      - 'fix/**'

jobs:
  notify-cicd-repo:
    runs-on: ubuntu-latest
    steps:
      - name: Send Deployment Trigger
        run: |
          curl -X POST -H "Authorization: token ${{ secrets.PERSONAL_ACCESS_TOKEN }}" \
          -H "Accept: application/vnd.github.everest-preview+json" \
          --data '{
            "event_type": "deploy",
            "client_payload": {
              "repository": "${{ github.repository }}",
              "repository_name": "${{ github.event.repository.name }}",
              "branch": "${{ github.ref_name }}"
            }}' \
          https://api.github.com/repos/YOUR_CICD_REPO_OWNER/awc-multi-site-cicd/dispatches
```

3. Commit & Push to Your Repository:

```bash
git add .github/workflows/trigger-deploy.yml
git commit -m "Setup CI/CD workflow for deployment"
git push origin main
```

## 2. Setting Up Vercel Deployment Locally

Once your project is connected to the CI/CD pipeline, you need to configure Vercel.

### Step 1: Install Vercel CLI
Run the following command in your project root directory:

```bash
sudo npm i -g vercel
```

### Step 2: Login to Vercel
Run:

```bash
vercel login
```

1. Select "Login using email".
2. Enter your email and verify the code.

### Step 3: Link Your Project to Vercel
Run:

``` bash
vercel link
```

The options will be -

```bash
Set up "project-path"? → Press y
Which scope should contain your project? → Press Enter
Link to existing project? → Press n
What's your project name? → Press Enter
In which directory is your project located? → Press Enter
Want to modify these settings? → Press n
```

This will build your project and create a .vercel/ folder. As well as adding the .vercel to the gitignore.

### Step 4: Extract & Store Vercel Project Credentials
Inside .vercel/project.json, you will find:


```yaml
{
  "projectId": "YOUR_PROJECT_ID",
  "orgId": "YOUR_ORG_ID"
}
```

1. Copy these values
2. Go to your CI/CD repository (awc-multi-site-cicd) → Settings → Secrets and Variables → Actions.
3. Add new secrets:

```ini
PROJECT_NAME_PROJECT_ID = (Paste "projectId" from .vercel/project.json)
PROJECT_NAME_ORG_ID = (Paste "orgId" from .vercel/project.json)
```

Example for SETUP:

```ini
SETUP_PROJECT_ID = (Paste projectId)
SETUP_ORG_ID = (Paste orgId)
```

## 3. How the CI/CD Pipeline Works

### Workflow Overview


|  Step                                       |  What happens?                                   |
|---------------------------------------------|--------------------------------------------------| 
|  Push to Feature Branch (feat/** or fix/**) |  Runs build & test, deploys to Vercel Preview    |
|                                             |                                                  |
|  Merge to main                              |  Runs build & test, deploys to Vercel Production |

Each deployment uses:

1. VERCEL_TOKEN (Global Token)
2. Project-Specific PROJECT_ID and ORG_ID

## 4. Adding a New Project to the CI/CD Pipeline

Every new project must follow these steps:

### Step 1: Set Up GitHub Secrets in awc-multi-site-cicd
Go to awc-multi-site-cicd → Settings → Secrets and Variables → Actions, and add:

```ini
PROJECT_NAME_PROJECT_ID = (Project ID from .vercel/project.json)
PROJECT_NAME_ORG_ID = (Org ID from .vercel/project.json)
```

### Step 2: Set Up the Project Repository
Inside your project repo, create .cicd-config.yml:

```yaml
project_type: static
tests:
  - unit
deploy_to: vercel
```

Then commit & push:

```bash
git add .cicd-config.yml
git commit -m "Add CI/CD config"
git push origin main
```

### Step 3: Push a Test Change
To test:

```bash
git checkout -b feat/test-deploy
echo "console.log('Testing CI/CD');" >> test.js
git add test.js
git commit -m "Test Vercel Preview Deployment"
git push origin feat/test-deploy
```

1. Check GitHub Actions Logs in awc-multi-site-cicd.

2. Verify the preview build in Vercel.

### Final Steps

1. Check GitHub Actions Logs → Confirm workflow is running.
2. Check Vercel Deployments → See if preview builds work.
3. Merge into main → Ensure production deploys correctly.
4. Now your project is fully integrated with CI/CD and Vercel!