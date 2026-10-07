config {
  call_module_type = "all" # also lint calls to local and remote modules
}

plugin "terraform" {
  enabled = true
  preset  = "all"
}

plugin "aws" {
  enabled = true
  version = "0.49.0" # pinned; tflint --init checks the signature
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
