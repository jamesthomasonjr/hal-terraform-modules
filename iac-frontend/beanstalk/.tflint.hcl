config {
  terraform_version = "0.11.3"
  deep_check = false

  ignore_module = {
    "terraform-aws-modules/security-group/aws" = true
  }
}
