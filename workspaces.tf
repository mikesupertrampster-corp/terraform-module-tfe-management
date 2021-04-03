resource "tfe_workspace" "all" {
  for_each          = var.workspaces
  name              = each.key
  organization      = tfe_organization.main.id
  queue_all_runs    = true
  auto_apply        = false
  execution_mode    = each.value["exec"]
  working_directory = each.value["workdir"]

  dynamic "vcs_repo" {
    for_each = each.value["vcs_repo"] != null && length(tfe_oauth_client.github) != 0 ? [each.value["vcs_repo"]] : []
    content {
      identifier         = vcs_repo.value
      ingress_submodules = false
      oauth_token_id     = tfe_oauth_client.github.0.oauth_token_id
    }
  }
}

resource "tfe_variable" "variables" {
  for_each = merge(flatten([
    for wso in tfe_workspace.all : {
      for i, v in var.workspaces[wso["name"]]["variables"] :
      "${wso["name"]}-${v["key"]}" => {
        key            = v["key"],
        category       = v["category"],
        workspace_id   = wso["id"],
        workspace_name = wso["name"]
      }
    }
  ])...)

  category     = each.value["category"]
  sensitive    = true
  workspace_id = each.value["workspace_id"]
  key          = each.value["key"]
  value        = each.value["key"] == "TFE_TOKEN" ? tfe_team_token.team[var.variables[each.value["workspace_name"]][each.value["key"]]].token : var.variables[each.value["workspace_name"]][each.value["key"]]
}
