# Obsidian Remotely Save Setup

Sync Obsidian vaults to Cloudflare R2 using the [Remotely Save](https://github.com/remotely-save/remotely-save) plugin.

## Prerequisites

- R2 bucket `obsidian` and access token are managed by OpenTofu (`tofu/main.tf`)
- Retrieve credentials from OpenTofu outputs:

```bash
cd tofu

# Access Key ID
tofu output obsidian_r2_access_key_id

# Secret Access Key
tofu output obsidian_r2_secret_access_key
```

## Plugin Configuration

1. Install **Remotely Save** from Obsidian Community Plugins
2. Open Settings → Remotely Save
3. Choose remote service: **S3 or S3-compatible**
4. Fill in the following:

| Field | Value |
|-------|-------|
| S3 Endpoint | `https://8b50ea3379fb9efb39ecef76cfcaa04a.r2.cloudflarestorage.com` |
| S3 Region | `auto` |
| S3 Access Key ID | (from `tofu output obsidian_r2_access_key_id`) |
| S3 Secret Access Key | (from `tofu output obsidian_r2_secret_access_key`) |
| S3 Bucket Name | `obsidian` |

5. Click **Check** to verify the connection
6. Configure sync schedule as desired (e.g., on startup, every 5 minutes)

## CORS (if needed)

If the plugin reports CORS errors, add a CORS policy to the R2 bucket via the Cloudflare dashboard:

- Allowed Origins: `app://obsidian.md`
- Allowed Methods: `GET, PUT, DELETE, HEAD`
- Allowed Headers: `*`

## Notes

- The R2 token (`homelab-prod-obsidian-r2`) has read/write access scoped to the `obsidian` bucket only
- Endpoint format: `https://<account_id>.r2.cloudflarestorage.com` (no bucket name in URL)
- Do **not** use the public `r2.dev` URL — use the S3-compatible API endpoint
