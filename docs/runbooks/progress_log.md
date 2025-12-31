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

## 2025-12-31 — Project 1 / Step 3: Flow Logs + VPC Endpoints (Cost-Safe, No NAT)

### Objective
Add security visibility (VPC Flow Logs) and private AWS service access (VPC Endpoints) while keeping costs low (no NAT Gateway).

### Changes implemented
- **VPC Flow Logs → S3**
  - Created module: `modules/flow_logs_s3`
  - Provisioned a dedicated S3 bucket for flow logs with:
    - Block Public Access enabled
    - SSE-S3 (AES256) encryption
    - Lifecycle expiration (retention) to control storage cost
  - Enabled VPC Flow Logs on the dev VPC with `traffic_type = ALL` and per-hour partitioning.

- **VPC Endpoints**
  - Created module: `modules/vpc_endpoints`
  - Added **S3 Gateway Endpoint** associated with the **private route table** (S3 access without internet/NAT).
  - Added **SSM Interface Endpoints** in private subnets with Private DNS enabled:
    - `ssm`
    - `ec2messages`
    - `ssmmessages`
  - Created an endpoint security group allowing HTTPS (443) from within the VPC CIDR.

### IAM adjustment (required)
- Updated IAM user `terraform-lab` permissions to allow Flow Logs delivery setup:
  - Added inline policy `terraform-lab-logs-delivery` with `logs:CreateLogDelivery` and related `logs:*LogDelivery` / resource policy read/write actions.
  - Note: This was applied via an admin-capable IAM identity (not the `lab` profile).

### Verification
- `terraform init -reconfigure` completed successfully (S3 backend + lockfile).
- `terraform plan` → **No changes** after apply.
- Verified resources via CLI:
  - `aws ec2 describe-flow-logs --filter Name=resource-id,Values=<vpc_id>`
  - `aws ec2 describe-vpc-endpoints --filters Name=vpc-id,Values=<vpc_id>`
- Confirmed S3 state remains in:
  - Bucket: `seven-aws-sec-net-lab-tfstate-62780dda`
  - Key: `envs/dev/terraform.tfstate`

### Outputs captured (envs/dev)
- `flow_logs_bucket_name`
- `flow_log_id`
- `s3_gateway_endpoint_id`
- `ssm_endpoint_ids`
- `vpce_security_group_id`

### Next step
Step 4: Launch a private EC2 instance with **SSM Session Manager** access (no SSH, no public IP, no NAT) to validate endpoint path end-to-end.

## 2025-12-31 — Project 1 / Step 4: Private EC2 + SSM Session Manager (No SSH, No Public IP)

### Objective
Deploy private compute and prove management access via SSM Session Manager only (no SSH, no NAT).

### Changes implemented
- Added module `modules/private_ec2_ssm`:
  - Amazon Linux 2023 EC2 instance in private subnet (no public IP)
  - IMDSv2 enforced
  - Encrypted root volume
  - Dedicated security group with no ingress and limited egress (HTTPS + DNS)
  - IAM role + instance profile with `AmazonSSMManagedInstanceCore`

### Verification
- Terraform apply succeeded; outputs confirmed:
  - `private_ec2_instance_id`: i-0c2fb1cb0285f6a81
  - `private_ec2_private_ip`: 10.10.0.190
- Instance registered in SSM and reachable:
  - `aws ssm describe-instance-information` returned `PingStatus: Online`
- Next verification: establish interactive session via:
  - `aws ssm start-session --target <instance-id>`
