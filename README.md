# homelab

Self-hosted services and infrastructure managed with Docker Compose, Ansible, and OpenTofu.

## Architecture

```
Local Server (Ubuntu/Debian)
├── Traefik (reverse proxy)
└── Services (Docker Compose)

DigitalOcean (future)
├── Droplet (Mastodon)
└── Spaces (backups)

Cloudflare
├── DNS (yutakobayashi.com)
├── R2 (Mastodon media / Obsidian backup)
└── API Tokens

AWS
└── SES (Mastodon email delivery)

HCP Terraform
├── tfe workspace (HCP Terraform self-management)
├── homelab workspace (infrastructure state)
└── github workspace (GitHub repository settings)

Management
├── Ansible    → server provisioning
├── OpenTofu   → cloud infrastructure
└── Nix flake  → dev environment
```

## Prerequisites

- [Nix](https://nixos.org/) (recommended) or install manually:
  - [OpenTofu](https://opentofu.org/) >= 1.6
  - [Ansible](https://docs.ansible.com/) >= 2.15
  - [TFLint](https://github.com/terraform-linters/tflint)
- [Docker](https://www.docker.com/) and Docker Compose

## Setup

### 1. Development Environment

```bash
# Install all dev tools via Nix flake
nix develop

# MCP servers and agent skills are auto-configured via shellHook
```

### 2. HCP Terraform

State is managed by [HCP Terraform](https://app.terraform.io/). Authenticate once:

```bash
tofu login app.terraform.io
```

### 3. OpenTofu

Three independent workspaces:

| Directory | Workspace | Manages |
|-----------|-----------|---------|
| `tofu/` | homelab | Cloudflare DNS/R2, AWS SES, DO |
| `tofu/tfe/` | tfe | HCP Terraform organization, workspaces |
| `tofu/github/` | github | GitHub repository settings |

```bash
cd tofu  # or tofu/tfe, tofu/github

# Create and edit variables file
cp terraform.tfvars.example terraform.tfvars

# Init, plan, apply
tofu init
tofu plan
tofu apply
```

#### Required Secrets (`tofu/terraform.tfvars`)

| Variable | Description |
|----------|-------------|
| `cloudflare_api_token` | Cloudflare API token (Zone:DNS:Edit, Zone:Zone:Read) |
| `cloudflare_account_id` | Cloudflare account ID |
| `cloudflare_zone_id` | Cloudflare Zone ID |
| `aws_access_key` | AWS access key (for SES) |
| `aws_secret_key` | AWS secret key |
| `aws_region` | AWS region (ap-northeast-1) |
| `domain` | Root domain name |
| `do_token` | DigitalOcean API token |

#### Required Secrets (`tofu/github/terraform.tfvars`)

| Variable | Description |
|----------|-------------|
| `github_token` | GitHub Personal Access Token |

### 4. Local Server

```bash
# Edit Ansible inventory
vim ansible/inventory/hosts.yml

# Provision server
cd ansible && ansible-playbook playbooks/site.yml

# Or deploy directly with Docker Compose
cd docker/local && docker compose up -d
```

## Adding a New Service

1. Add service to `docker/local/docker-compose.yml`
2. Configure routing with Traefik labels:
   ```yaml
   labels:
     - "traefik.enable=true"
     - "traefik.http.routers.myservice.rule=Host(`myservice.example.com`)"
     - "traefik.http.routers.myservice.tls.certresolver=letsencrypt"
   ```
3. Deploy: `ansible-playbook playbooks/docker.yml` or `docker compose up -d`

## Directory Structure

```
tofu/                              # OpenTofu - infrastructure
├── main.tf                        # providers, R2 buckets, tokens
├── dns.tf                         # Cloudflare DNS records
├── ses.tf                         # AWS SES (email)
├── variables.tf / outputs.tf
├── .tflint.hcl
├── modules/
│   ├── cloudflare-r2/             # R2 bucket + custom domain
│   └── cloudflare-account-token/  # R2 API token
├── tfe/                           # HCP Terraform self-management
│   ├── main.tf                    # tfe provider
│   ├── organization.tf            # org settings (2FA mandatory)
│   ├── projects.tf
│   └── workspaces.tf              # homelab, github workspaces
└── github/                        # GitHub repository management
    ├── main.tf                    # github provider
    ├── variables.tf
    └── repositories.tf            # repo settings, topics

ansible/                           # Server provisioning
├── inventory/hosts.yml
├── playbooks/
│   ├── site.yml                   # Full provisioning
│   ├── common.yml                 # Base setup (UFW, fail2ban)
│   └── docker.yml                 # Docker + service deploy
└── roles/
    ├── base/                      # OS hardening
    └── docker/                    # Docker CE install

docker/local/                      # Local services
├── docker-compose.yml             # Traefik + services
└── traefik/traefik.yml
```

## Managed Resources

| Provider | Resource | Details |
|----------|----------|---------|
| Cloudflare | DNS records | fedi.yutakobayashi.com (A), SES DKIM (CNAME x3) |
| Cloudflare | R2 buckets | fediverse (Mastodon media), obsidian (backup) |
| Cloudflare | R2 tokens | mastodon-r2, obsidian-r2 |
| Cloudflare | R2 custom domain | fedi-files.yutakobayashi.com |
| AWS | SES | fedi.yutakobayashi.com (domain identity + DKIM) |
| HCP Terraform | Organization | yutakobayashi (2FA mandatory) |
| HCP Terraform | Workspaces | tfe, homelab, github |
| GitHub | Repositories | homelab, dotnix, repiq, ava |

## Future

- Mastodon migration from Vultr to DigitalOcean
- Self-hosted services
  - Home Assistant
  - Nextcloud
  - AdGuard Home
  - xnotif (X/Twitter notification relay)
  - OpenClaw
- Observability
  - Grafana + Prometheus monitoring stack
  - Claude Code OpenTelemetry → Grafana
  - Oura Ring metrics (daily_readiness, daily_spo2, daily_sleep)
  - sFlow / RIPE Atlas network monitoring
- microk8s for learning Kubernetes
