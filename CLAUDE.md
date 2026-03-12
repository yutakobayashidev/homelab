# homelab

Homelab infrastructure repository.

## Architecture

- **Local server** (Ubuntu/Debian): Docker Compose + Traefik, provisioned by Ansible
- **DigitalOcean**: Mastodon (future migration from Vultr), managed by OpenTofu
- **Cloudflare R2**: Mastodon media storage
- **DO Spaces**: Backups (future)

## Stack

| Layer | Tool | Purpose |
|-------|------|---------|
| Infrastructure | OpenTofu | DO Droplet, DNS, Cloudflare R2 |
| Lint | TFLint | OpenTofu static analysis |
| Provisioning | Ansible | Server setup, Docker install, service deploy |
| Services | Docker Compose | Container orchestration |
| Reverse Proxy | Traefik | Local routing, auto HTTPS |
| Backup | Restic | Scheduled backups to DO Spaces |

## Directory Layout

- `tofu/` — OpenTofu configurations (DO + Cloudflare R2)
- `tofu/modules/` — Reusable modules (cloudflare-r2, cloudflare-account-token)
- `ansible/` — Playbooks and roles for server provisioning
- `docker/local/` — Docker Compose for local services
- `scripts/` — Utility scripts

## Commands

```bash
# Local server provisioning
cd ansible && ansible-playbook playbooks/site.yml

# OpenTofu
cd tofu && tofu init && tofu plan && tofu apply

# TFLint
cd tofu && tflint --init && tflint

# Docker services
cd docker/local && docker compose up -d
```
