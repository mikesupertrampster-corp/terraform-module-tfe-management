resource "tfe_registry_module" "modules" {
  for_each = toset(length(tfe_oauth_client.client) != 0 ? var.modules : [])

  vcs_repo {
    display_identifier = each.value
    identifier         = each.value
    oauth_token_id     = tfe_oauth_client.client[var.tfe_oauth_client.provider].oauth_token_id
  }
}