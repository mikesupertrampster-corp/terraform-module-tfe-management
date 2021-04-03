resource "tfe_registry_module" "modules" {
  for_each = toset(length(tfe_oauth_client.github) != 0 ? var.modules : [])

  vcs_repo {
    display_identifier = each.value
    identifier         = each.value
    oauth_token_id     = tfe_oauth_client.github.0.oauth_token_id
  }

  lifecycle {
    ignore_changes = [vcs_repo.0.oauth_token_id]
  }
}