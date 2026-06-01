✅ STEP 1 — Create Service Principal (App Registration)
Option A: Azure CLI (fastest)
Shellaz ad app create --display-name "github-oidc-app"Show more lines
Get the IDs:
Shellaz ad app list --display-name "github-oidc-app" --query "[0].{appId:appId}" -o tsvShow more lines
Then get Tenant ID:
Shellaz account show --query tenantId -o tsvShow more lines

✅ You now have:

CLIENT_ID (App ID)
TENANT_ID


✅ STEP 2 — Create Service Principal (Enterprise app)
Shellaz ad sp create --id <CLIENT_ID>Show more lines

✅ STEP 3 — Assign Azure Role (IMPORTANT ✅)
👉 This is where your last error came from (No subscriptions found)
Shellaz role assignment create \  --assignee <CLIENT_ID> \  --role Contributor \  --scope /subscriptions/<SUBSCRIPTION_ID>Show more lines
✅ Now your SP can access Azure resources

✅ STEP 4 — Configure Federated Credential (OIDC)
Go to:
Azure Portal → App Registrations → Your App
→ Certificates & Secrets → Federated Credentials → Add Credential


✅ Add these values
✅ 1. Issuer
https://token.actions.githubusercontent.com


✅ 2. Subject (VERY IMPORTANT)
For main branch:
repo:pr3012/terraform-learn-azure-resources:ref:refs/heads/main


✅ Recommended (avoid future errors):
Use wildcard:
repo:pr3012/terraform-learn-azure-resources:ref:refs/heads/*


✅ Add this ALSO (for PRs)
repo:pr3012/terraform-learn-azure-resources:pull_request


✅ 3. Audience
api://AzureADTokenExchange


✅ STEP 5 — Add GitHub Secrets
Go to:
GitHub → Repo → Settings → Secrets and variables → Actions

Add:
AZURE_CLIENT_ID
AZURE_TENANT_ID
AZURE_SUBSCRIPTION_ID


✅ STEP 6 — Create GitHub Workflow
📄 .github/workflows/deploy.yml

✅ STEP 7 — Run Workflow

Push to main
Open GitHub Actions tab
Check logs

✅ Expected output:
az account show
→ shows your subscription ✅


✅ ERRORS YOU FACED (Solved ✅)

❌ 1. Missing client-id, tenant-id
👉 Cause:

Secrets not defined / wrong names

✅ Fix:

Add correct secrets in GitHub


❌ 2. AADSTS700213 (Federated Credential mismatch)
👉 Cause:

Subject mismatch (branch / repo / PR)

✅ Fix:

Use:
repo:<org>/<repo>:ref:refs/heads/*


Add PR subject if needed


❌ 3. No subscriptions found
👉 Cause:

No role assigned to Service Principal

✅ Fix:

Assign Contributor role


✅ FINAL ARCHITECTURE (MENTAL MODEL)
GitHub Action
   ↓ (OIDC Token)
Azure AD (Entra ID)
   ↓ (Federated Credential Validation)
Service Principal
   ↓ (RBAC Role Assignment)
Azure Subscription
   ↓
Resources (deploy/read/update)


✅ OPTIONAL NEXT STEPS (for you)
Now you can plug in:
✅ Terraform
YAML- run: terraform init- run: terraform apply -auto-approveShow more lines

✅ Bicep / ARM
YAML- run: az deployment group create ...Show more lines

✅ App Service deploy
YAML- run: az webapp up ...Show more lines

✅ Pro Tips (Production)

✅ Use least privilege roles (not always Contributor)
✅ Avoid storing secrets → OIDC eliminates passwords ✔
✅ Use branch restrictions (instead of wildcard later)
✅ Use GitHub Environments for approvals
