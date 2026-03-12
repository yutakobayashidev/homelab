data "cloudflare_api_token_permission_groups_list" "this" {
}

locals {
  r2_api_permissions = { for x in data.cloudflare_api_token_permission_groups_list.this.result : x.name => x.id if contains(["Workers R2 Storage Bucket Item Read", "Workers R2 Storage Bucket Item Write"], x.name) }
  permission_id_list = [
    local.r2_api_permissions["Workers R2 Storage Bucket Item Read"],
    local.r2_api_permissions["Workers R2 Storage Bucket Item Write"]
  ]

  resources = {
    "com.cloudflare.edge.r2.bucket.${var.cloudflare_account_id}_default_${var.bucket_name}" = "*"
  }
}

resource "cloudflare_api_token" "this" {
  name = "${var.project_name}-${var.environment}-${var.token_name}"

  policies = [{
    effect            = "allow"
    resources         = local.resources
    permission_groups = [for x in local.permission_id_list : { id = x }]
  }]
}
