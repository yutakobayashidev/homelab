# homelab

Homelab infrastructure repository.

## Architecture

- **Local server** (Ubuntu/Debian): Docker Compose + Traefik, provisioned by Ansible
- **DigitalOcean**: Mastodon (future migration from Vultr), managed by OpenTofu
- **DO Spaces**: Backups and Mastodon media storage

## Stack

| Layer | Tool | Purpose |
|-------|------|---------|
| Infrastructure | OpenTofu | DO Droplet, DNS, Spaces |
| Provisioning | Ansible | Server setup, Docker install, service deploy |
| Services | Docker Compose | Container orchestration |
| Reverse Proxy | Traefik | Local routing, auto HTTPS |
| Backup | Restic | Scheduled backups to DO Spaces |

## Directory Layout

- `tofu/` — OpenTofu configurations (DO resources)
- `ansible/` — Playbooks and roles for server provisioning
- `docker/local/` — Docker Compose for local services
- `scripts/` — Utility scripts

## Commands

```bash
# Local server provisioning
cd ansible && ansible-playbook playbooks/site.yml

# OpenTofu
cd tofu && tofu plan && tofu apply

# Docker services
cd docker/local && docker compose up -d
```
