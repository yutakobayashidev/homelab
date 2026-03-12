# Mastodon DNS records (yutakobayashi.com zone)
# Imported from existing Cloudflare records

resource "cloudflare_dns_record" "mastodon_a" {
  zone_id = var.cloudflare_zone_id
  name    = "fedi"
  type    = "A"
  content = var.mastodon_ip
  proxied = true
  ttl     = 1
}

resource "cloudflare_dns_record" "mastodon_media_cname" {
  zone_id = var.cloudflare_zone_id
  name    = "fedi-files"
  type    = "CNAME"
  content = "public.r2.dev"
  proxied = true
  ttl     = 1
}

# SES DKIM records for fedi.yutakobayashi.com
resource "cloudflare_dns_record" "mastodon_dkim_1" {
  zone_id = var.cloudflare_zone_id
  name    = "4epkx5liidlbwr24hvivm5hqdxkfvtfw._domainkey.fedi"
  type    = "CNAME"
  content = "4epkx5liidlbwr24hvivm5hqdxkfvtfw.dkim.amazonses.com"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "mastodon_dkim_2" {
  zone_id = var.cloudflare_zone_id
  name    = "5gualsmqbqr2iyy4jcswf45fnntumcec._domainkey.fedi"
  type    = "CNAME"
  content = "5gualsmqbqr2iyy4jcswf45fnntumcec.dkim.amazonses.com"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "mastodon_dkim_3" {
  zone_id = var.cloudflare_zone_id
  name    = "tvkogr4mjxbbpsortlpketewdt7rrlqb._domainkey.fedi"
  type    = "CNAME"
  content = "tvkogr4mjxbbpsortlpketewdt7rrlqb.dkim.amazonses.com"
  proxied = false
  ttl     = 1
}
