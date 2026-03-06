# terraform-data-platform-modules

This repository contains a focused, production-style project demonstrating practical skills in data engineering, analytics, and platform engineering.

## Scope
- Clear project structure
- Emphasis on correctness and maintainability
- Incremental improvements tracked via pull requests

## How to use
See project-specific documentation in the `docs/` directory or repository root.

## Status
Active development.

## Module Skeleton: `modules/iam`

The following is a safe IAM module skeleton and example usage (no credentials embedded).

Suggested structure:

```text
modules/
  iam/
    main.tf
    variables.tf
    outputs.tf
    README.md
examples/
  iam/
    main.tf
```

### `modules/iam/main.tf`

```hcl
resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = var.assume_role_policy_json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}
```

### `modules/iam/variables.tf`

```hcl
variable "role_name" {
  description = "IAM role name"
  type        = string
}

variable "assume_role_policy_json" {
  description = "Trust policy JSON for sts:AssumeRole"
  type        = string
}

variable "managed_policy_arns" {
  description = "Managed policy ARNs to attach"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags for IAM resources"
  type        = map(string)
  default     = {}
}
```

### `modules/iam/outputs.tf`

```hcl
output "role_name" { value = aws_iam_role.this.name }
output "role_arn"  { value = aws_iam_role.this.arn }
output "role_id"   { value = aws_iam_role.this.id }
```

### Example usage: `examples/iam/main.tf`

```hcl
provider "aws" {
  region = "us-east-1"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

module "iam_role" {
  source                  = "../../modules/iam"
