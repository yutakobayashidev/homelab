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
└── R2 (Mastodon media storage)

Management
├── Ansible  → server provisioning
├── OpenTofu → cloud infrastructure
└── GitHub Actions → CI/CD
```

## Prerequisites

- [Nix](https://nixos.org/) (recommended) or install manually:
  - [OpenTofu](https://opentofu.org/) >= 1.6
  - [Ansible](https://docs.ansible.com/) >= 2.15
  - [TFLint](https://github.com/terraform-linters/tflint) >= 0.58.1
- [Docker](https://www.docker.com/) and Docker Compose

## Setup

### 1. Development Environment

```bash
# Nix flake で開発ツールを一括インストール (opentofu, ansible, tflint, docker-compose)
nix develop

# または direnv を使う場合
direnv allow
```

### 2. OpenTofu

```bash
cd tofu

# 変数ファイルを作成
cp terraform.tfvars.example terraform.tfvars
# terraform.tfvars を編集して実際の値を設定

# 初期化
tofu init

# Lint
tflint --init
tflint

# 差分確認
tofu plan

# 適用
tofu apply

# 出力値の確認
tofu output
```

#### Required Secrets

| 変数 | 説明 |
|------|------|
| `do_token` | DigitalOcean API トークン |
| `spaces_access_id` | DO Spaces アクセスキー ID |
| `spaces_secret_key` | DO Spaces シークレットキー |
| `domain` | ルートドメイン名 |
| `cloudflare_api_token` | Cloudflare API トークン |
| `cloudflare_account_id` | Cloudflare アカウント ID |
| `cloudflare_zone_id` | Cloudflare Zone ID |

#### GitHub Actions

PR で `tflint` + `tofu plan`、main マージで `tofu apply` が自動実行される。

以下の GitHub Secrets を設定すること:

- `DO_TOKEN`
- `SPACES_ACCESS_ID`
- `SPACES_SECRET_KEY`
- `DOMAIN`
- `CLOUDFLARE_API_TOKEN`
- `CLOUDFLARE_ACCOUNT_ID`
- `CLOUDFLARE_ZONE_ID`

### 3. Local Server

```bash
# Ansible inventory を編集 (サーバー IP を設定)
vim ansible/inventory/hosts.yml

# サーバーをプロビジョニング (Docker インストール, ファイアウォール設定等)
cd ansible
ansible-playbook playbooks/site.yml

# または Docker Compose で直接デプロイ
cd docker/local
cp .env.example .env  # 編集して値を設定
docker compose up -d
```

## Adding a New Service

1. `docker/local/docker-compose.yml` にサービスを追加
2. Traefik labels でルーティング設定:
   ```yaml
   labels:
     - "traefik.enable=true"
     - "traefik.http.routers.myservice.rule=Host(`myservice.example.com`)"
     - "traefik.http.routers.myservice.tls.certresolver=letsencrypt"
   ```
3. デプロイ: `ansible-playbook playbooks/docker.yml` or `docker compose up -d`

## Directory Structure

```
tofu/                          # OpenTofu (cloud infrastructure)
├── main.tf                    # providers + module calls
├── variables.tf
├── outputs.tf
├── .tflint.hcl                # TFLint rules
└── modules/
    ├── cloudflare-r2/         # R2 bucket + custom domain
    └── cloudflare-account-token/  # R2 API token

ansible/                       # Server provisioning
├── inventory/hosts.yml
├── playbooks/
│   ├── site.yml               # Full provisioning
│   ├── common.yml             # Base setup (UFW, fail2ban)
│   └── docker.yml             # Docker + service deploy
└── roles/
    ├── base/                  # OS hardening
    └── docker/                # Docker CE install

docker/local/                  # Local services
├── docker-compose.yml         # Traefik + services
└── traefik/traefik.yml        # Traefik config
```

## Future

- microk8s migration for learning Kubernetes
- Monitoring stack (Grafana + Prometheus)
- Mastodon migration from Vultr to DigitalOcean
