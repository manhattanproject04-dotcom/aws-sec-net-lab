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

## 2025-12-24 — Project 1 / Step 2 Completed (Public + Private across 2 AZs)

- Added public layer: 2 public subnets, Internet Gateway, public route table, and default route (0.0.0.0/0 → IGW); no NAT (cost-safe).
- Terraform apply (envs/dev): **Resources: 7 added, 0 changed, 0 destroyed.**
- Outputs confirmed: `vpc_id`, `public_subnet_ids`, `private_subnet_ids`, `public_route_table_id`, `private_route_table_id`, `internet_gateway_id`.
- Git commit: `feat: add public subnets + IGW + public routing (complete Step 2)`

## 2025-12-25 — Step 2 Stabilized + Remote State Migration Completed (S3 Lockfile)

### What changed
- Resolved Security Group description validation issue (AWS SG description now conforms to allowed character set).
- Finalized `security_groups` module and wired it into `envs/dev` with closed-by-default ingress CIDRs.
- Migrated Terraform state from local to remote backend in S3 and enabled native state locking via S3 lockfile.

### Remote backend (dev)
- Backend: **S3**
- Bucket: `seven-aws-sec-net-lab-tfstate-62780dda`
- Key: `envs/dev/terraform.tfstate`
- Region: `us-east-2`
- Locking: `use_lockfile = true`
- Verification:
  - `terraform init -reconfigure` → backend configured successfully
  - `aws s3api list-objects-v2 --bucket seven-aws-sec-net-lab-tfstate-62780dda --prefix envs/dev/` → state object present
  - `terraform plan` → **No changes** (infra matches configuration)

### Infrastructure status (dev)
- VPC: `vpc-00c6c8339be4122d6`
- Public subnets: `subnet-0654ee0e27fb0d2b6`, `subnet-07ec489fff3f61096`
- Private subnets: `subnet-0632bd33bed11e87b`, `subnet-0908be87aea5e5bea`
- Internet Gateway: `igw-0e134663584f30c20`
- Route tables:
  - Public: `rtb-056c95a653aee60e4`
  - Private: `rtb-0d3a6cd70ea70c23c`
- Security Groups:
  - Admin: `sg-0470b76b7870064fe`
  - App: `sg-0c6244ffa0f5bb775`
  - Data: `sg-018cdce462ceb6cce`

### Git status
- Working tree clean after commit(s); repository is reproducible with remote state enabled.
