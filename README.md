# homelab

[![DeepWiki](https://img.shields.io/badge/DeepWiki-yutakobayashidev%2Fhomelab-blue.svg?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACwAAAAyCAYAAAAnWDnqAAAAAXNSR0IArs4c6QAAA05JREFUaEPtmUtyEzEQhtWTQyQLHNak2AB7ZnyXZMEjXMGeK/AIi+QuHrMnbChYY7MIh8g01fJoopFb0uhhEqqcbWTp06/uv1saEDv4O3n3dV60RfP947Mm9/SQc0ICFQgzfc4CYZoTPAswgSJCCUJUnAAoRHOAUOcATwbmVLWdGoH//PB8mnKqScAhsD0kYP3j/Yt5LPQe2KvcXmGvRHcDnpxfL2zOYJ1mFwrryWTz0advv1Ut4CJgf5uhDuDj5eUcAUoahrdY/56ebRWeraTjMt/00Sh3UDtjgHtQNHwcRGOC98BJEAEymycmYcWwOprTgcB6VZ5JK5TAJ+fXGLBm3FDAmn6oPPjR4rKCAoJCal2eAiQp2x0vxTPB3ALO2CRkwmDy5WohzBDwSEFKRwPbknEggCPB/imwrycgxX2NzoMCHhPkDwqYMr9tRcP5qNrMZHkVnOjRMWwLCcr8ohBVb1OMjxLwGCvjTikrsBOiA6fNyCrm8V1rP93iVPpwaE+gO0SsWmPiXB+jikdf6SizrT5qKasx5j8ABbHpFTx+vFXp9EnYQmLx02h1QTTrl6eDqxLnGjporxl3NL3agEvXdT0WmEost648sQOYAeJS9Q7bfUVoMGnjo4AZdUMQku50McDcMWcBPvr0SzbTAFDfvJqwLzgxwATnCgnp4wDl6Aa+Ax283gghmj+vj7feE2KBBRMW3FzOpLOADl0Isb5587h/U4gGvkt5v60Z1VLG8BhYjbzRwyQZemwAd6cCR5/XFWLYZRIMpX39AR0tjaGGiGzLVyhse5C9RKC6ai42ppWPKiBagOvaYk8lO7DajerabOZP46Lby5wKjw1HCRx7p9sVMOWGzb/vA1hwiWc6jm3MvQDTogQkiqIhJV0nBQBTU+3okKCFDy9WwferkHjtxib7t3xIUQtHxnIwtx4mpg26/HfwVNVDb4oI9RHmx5WGelRVlrtiw43zboCLaxv46AZeB3IlTkwouebTr1y2NjSpHz68WNFjHvupy3q8TFn3Hos2IAk4Ju5dCo8B3wP7VPr/FGaKiG+T+v+TQqIrOqMTL1VdWV1DdmcbO8KXBz6esmYWYKPwDL5b5FA1a0hwapHiom0r/cKaoqr+27/XcrS5UwSMbQAAAABJRU5ErkJggg==)](https://deepwiki.com/yutakobayashidev/homelab)

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
├── docker-compose.yml             # Traefik, Grafana, Loki, Promtail
├── traefik/traefik.yml
├── loki/config.yaml               # Loki log aggregation
├── promtail/config.yaml           # Log collector → Loki
└── scripts/oura-exporter.sh       # Oura Ring → Loki exporter
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
  - Claude Code OpenTelemetry → Grafana
  - Prometheus metrics collection
  - Oura Ring metrics (daily_readiness, daily_spo2, daily_sleep)
  - sFlow / RIPE Atlas network monitoring
- microk8s for learning Kubernetes
