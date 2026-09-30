data "cloudflare_zone" "domain" {
  filter = {
    name = var.domain
  }
}

resource "cloudflare_dns_record" "web" {
  zone_id = data.cloudflare_zone.domain.id
  name    = "web"
  type    = "A"
  content = aws_eip.web.public_ip
  ttl     = 300
  proxied = false
}


resource "cloudflare_zero_trust_tunnel_cloudflared" "monitoring" {
  account_id = var.cloudflare_account_id
  name       = "devops-bootcamp-monitoring"
  config_src = "cloudflare"
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "monitoring" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.monitoring.id
  config = {
    ingress = [
      {
        hostname = "monitoring.${var.domain}"
        service  = "http://localhost:3000"
      },
      {
        service = "http_status:404"
      }
    ]
  }
}

resource "cloudflare_dns_record" "monitoring" {
  zone_id = data.cloudflare_zone.domain.id
  name    = "monitoring"
  type    = "CNAME"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.monitoring.id}.cfargotunnel.com"
  ttl     = 1
  proxied = true
}

data "cloudflare_zero_trust_tunnel_cloudflared_token" "monitoring" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.monitoring.id
}
