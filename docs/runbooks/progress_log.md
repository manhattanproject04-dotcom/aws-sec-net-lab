## 2025-12-23 — Project 1 / Step 2 — Network baseline (dev)

**What I did**
- Used IAM user: `terraform-lab`
- Attached policy: `AmazonVPCFullAccess`
- AWS CLI profile: `lab` (access key active; console access disabled)
- Terraform (envs/dev): `apply` completed — **Resources: 6 added, 0 changed, 0 destroyed**

**Terraform outputs (envs/dev)**
- vpc_id: `vpc-00c6c8339be4122d6`
- private_subnet_ids:
  - `subnet-0632bd33bed11e87b`
  - `subnet-0908be87aea5e5bea`
- private_route_table_id: `rtb-0d3a6cd70ea70c23c`

**Notes**
- Region: `us-east-2`
- Next: proceed to next project step (add here once you confirm).
## 2025-12-23 — Project 1 / Step 2 (Network Baseline) + Repo hygiene + Next: Remote State

### Completed
- Terraform apply (envs/dev): **Resources: 6 added, 0 changed, 0 destroyed**
- Outputs captured: `vpc_id`, `private_subnet_ids`, `private_route_table_id`
- IAM user used: `terraform-lab`
  - Policy attached: `AmazonVPCFullAccess`
  - Access key active; AWS CLI profile: `lab`
- Git initialized + commits created:
  - `docs: log Project 1 Step 2 apply outputs`
  - `feat: network baseline module + dev env wiring`
- Repo hygiene confirmed:
  - Tracked: `envs/dev/.terraform.lock.hcl`
  - Ignored (confirmed via `git status --ignored`): `envs/dev/.terraform/`, `envs/dev/terraform.tfstate`, `envs/dev/terraform.tfvars`, `envs/dev/tfplan`
  - `git status`: working tree clean

### Next up
- Move Terraform state to **remote backend**: S3 (state) + DynamoDB (state locking) for `envs/dev`

## 2025-12-24 — Project 1 / Step 2 — Remote State Backend (S3 + DynamoDB) Enabled

**Backend configuration**
- Backend: S3
- Region: us-east-2
- State bucket: seven-aws-sec-net-lab-tfstate-62780dda
- State key: envs/dev/terraform.tfstate
- DynamoDB lock table: seven-aws-sec-net-lab-tflock

**State migration + validation**
- Confirmed remote state object exists: `aws s3 ls s3://seven-aws-sec-net-lab-tfstate-62780dda/envs/dev/` → `terraform.tfstate`
- Verified convergence: `terraform plan` → **No changes. Infrastructure matches the configuration.**
- Repo status after changes: `git status` → working tree clean

**Notes**
- Local state artifacts remain ignored by git (`terraform.tfstate`, `.terraform/`, `tfplan`, `terraform.tfvars`, `terraform.tfstate.backup`).
