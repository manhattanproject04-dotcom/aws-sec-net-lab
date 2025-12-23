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
