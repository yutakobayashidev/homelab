# SES domain identity for Mastodon email delivery

resource "aws_ses_domain_identity" "mastodon" {
  domain = "fedi.${var.domain}"
}

resource "aws_ses_domain_dkim" "mastodon" {
  domain = aws_ses_domain_identity.mastodon.domain
}
