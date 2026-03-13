# homelab

Homelab infrastructure repository.

## Architecture

- **Local server** (Ubuntu/Debian): Docker Compose + Traefik, provisioned by Ansible
- **DigitalOcean**: Mastodon (future migration from Vultr), managed by OpenTofu
- **Cloudflare**: DNS, R2 (Mastodon media + Obsidian backup), API tokens
- **AWS SES**: Mastodon email delivery (ap-northeast-1)
- **HCP Terraform**: Remote state management
- **GitHub**: Repository settings managed via OpenTofu

## Stack

| Layer | Tool | Purpose |
|-------|------|---------|
| Infrastructure | OpenTofu | DO, Cloudflare, AWS SES, GitHub, HCP Terraform |
| State | HCP Terraform | Remote state storage (3 workspaces) |
| Lint | TFLint | OpenTofu static analysis |
| Provisioning | Ansible | Server setup, Docker install, service deploy |
| Services | Docker Compose | Container orchestration |
| Reverse Proxy | Traefik | Local routing, auto HTTPS |
| Dev Environment | Nix flake-parts | Tools, MCP servers, agent skills |

## Directory Layout

- `tofu/` — Main infrastructure (Cloudflare DNS/R2, AWS SES, DO)
- `tofu/tfe/` — HCP Terraform self-management (org, workspaces)
- `tofu/github/` — GitHub repository settings
- `tofu/modules/` — Reusable modules (cloudflare-r2, cloudflare-account-token)
- `ansible/` — Playbooks and roles for server provisioning
- `docker/local/` — Docker Compose for local services

## Commands

```bash
# OpenTofu (each workspace is independent)
cd tofu && tofu init && tofu plan && tofu apply
cd tofu/tfe && tofu init && tofu plan && tofu apply
cd tofu/github && tofu init && tofu plan && tofu apply

# TFLint
cd tofu && tflint --init && tflint

# Local server provisioning
cd ansible && ansible-playbook playbooks/site.yml

# Docker services
cd docker/local && docker compose up -d
```
