terraform {
  required_providers {
    tfe = {
      source = "hashicorp/tfe"
    }
  }
}

# Note: import on bootstrap
resource "tfe_organization" "main" {
  name  = var.org
  email = var.email
}

# Note: import on bootstrap
resource "tfe_team" "teams" {
  for_each     = toset(["owners"])
  name         = each.key
  organization = tfe_organization.main.id
}

# Note: import on bootstrap
resource "tfe_team_member" "members" {
  for_each = merge(flatten([for key, value in tfe_team.teams :
    [for user in var.users : { tostring(user) = value["id"] }]
  ])...)

  team_id  = each.value
  username = each.key
}

resource "tfe_oauth_client" "client" {
  for_each         = var.tfe_oauth_client == null ? {} : { (var.tfe_oauth_client.provider) = var.tfe_oauth_client }
  organization     = tfe_organization.main.id
  api_url          = each.value["api_url"]
  http_url         = each.value["http_url"]
  oauth_token      = var.tfe_oauth_client_token
  service_provider = each.key
}

resource "tfe_organization_token" "org" {
  organization = tfe_organization.main.name
}

resource "tfe_team_token" "team" {
  for_each = tfe_team.teams
  team_id  = each.value.id
}