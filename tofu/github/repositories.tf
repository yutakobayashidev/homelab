resource "github_repository" "homelab" {
  name        = "homelab"
  description = "Self-hosted services and infrastructure managed with Docker Compose, Ansible, and OpenTofu"
  visibility  = "public"

  has_issues    = true
  has_projects  = true
  has_wiki      = true
  has_downloads = true

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true

  delete_branch_on_merge = true
}

resource "github_repository" "dotnix" {
  name       = "dotnix"
  visibility = "public"

  has_issues    = true
  has_projects  = true
  has_wiki      = true
  has_downloads = true

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true

  delete_branch_on_merge = true
}

resource "github_repository" "repiq" {
  name        = "repiq"
  description = "Fetch objective metrics for OSS repositories. Built for AI agents."
  visibility  = "public"

  has_issues    = true
  has_projects  = true
  has_wiki      = true
  has_downloads = true

  allow_merge_commit = false
  allow_squash_merge = true
  allow_rebase_merge = true

  delete_branch_on_merge = true
}

resource "github_repository" "ava" {
  name         = "ava"
  description  = "Automatically share development progress to Slack through AI. MCP-powered task reporting with privacy-first design."
  homepage_url = "https://ava-dusky-gamma.vercel.app"
  visibility   = "public"

  has_issues    = true
  has_projects  = true
  has_wiki      = true
  has_downloads = true

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true

  delete_branch_on_merge = true
}

resource "github_repository" "kaikei" {
  name        = "kaikei"
  description = "確定申告・請求書管理"
  visibility  = "private"

  has_issues    = true
  has_projects  = false
  has_wiki      = false
  has_downloads = true

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true

  delete_branch_on_merge = true
}

resource "github_repository" "talks" {
  name       = "talks"
  visibility = "public"

  has_issues    = true
  has_projects  = true
  has_wiki      = true
  has_downloads = true

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true

  delete_branch_on_merge = true
}

resource "github_repository_topics" "repiq" {
  repository = github_repository.repiq.name
  topics     = ["agent-skills", "cli", "crates-io", "github", "go", "npm", "pypi", "oss-metrics"]
}

resource "github_repository_topics" "ava" {
  repository = github_repository.ava.name
  topics     = ["adhd", "ai", "devtools", "hono", "mcp", "mcp-server", "model-context-protocol", "neurodiversity", "nextjs", "productivity"]
}
