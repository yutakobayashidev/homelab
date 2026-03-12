# homelab

Self-hosted services and infrastructure managed with Docker Compose, Ansible, and OpenTofu.

## Architecture

```
Local Server (Ubuntu/Debian)
├── Traefik (reverse proxy)
└── Services (Docker Compose)

DigitalOcean (future)
├── Droplet (Mastodon)
└── Spaces (backups + media)

Management
├── Ansible  → server provisioning
├── OpenTofu → DO infrastructure
└── GitHub Actions → CI/CD
```

## Prerequisites

- [OpenTofu](https://opentofu.org/) >= 1.6
- [Ansible](https://docs.ansible.com/) >= 2.15
- [Docker](https://www.docker.com/) and Docker Compose

## Quick Start

### Local Server

```bash
# 1. Provision the server (install Docker, configure firewall, etc.)
cd ansible
ansible-playbook playbooks/site.yml

# 2. Or just deploy services (if server is already set up)
cd docker/local
cp .env.example .env  # edit with your values
docker compose up -d
```

### DigitalOcean (Mastodon)

```bash
cd tofu
cp terraform.tfvars.example terraform.tfvars  # edit with your values
tofu init
tofu plan
tofu apply
```

## Adding a New Service

1. Add the service to `docker/local/docker-compose.yml`
2. Add Traefik labels for routing:
   ```yaml
   labels:
     - "traefik.enable=true"
     - "traefik.http.routers.myservice.rule=Host(`myservice.example.com`)"
   ```
3. Deploy: `ansible-playbook playbooks/docker.yml` or `docker compose up -d`

## Future

- microk8s migration for learning Kubernetes
- Monitoring stack (Grafana + Prometheus)
