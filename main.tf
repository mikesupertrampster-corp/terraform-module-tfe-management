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

# Note: requires https://github.com/settings/applications/new
resource "tfe_oauth_client" "github" {
  count            = var.github_oauth_token == null ? 0 : 1
  organization     = tfe_organization.main.id
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.github_oauth_token
  service_provider = "github"
}

resource "tfe_organization_token" "org" {
  organization = tfe_organization.main.name
}

resource "tfe_team_token" "team" {
  for_each = tfe_team.teams
  team_id  = each.value.id
}