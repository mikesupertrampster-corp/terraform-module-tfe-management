variable "org" {
  type = string
}

variable "email" {
  type = string
}

variable "users" {
  type = list(string)
}

variable "tfe_oauth_client_token" {
  type      = string
  sensitive = true
  default   = null
}

variable "tfe_oauth_client" {
  type = object({
    provider = string
    api_url  = string
    http_url = string
  })
  default = null
}

variable "workspaces" {
  type = map(object({
    workdir = string
    exec    = string
    vcs_repo = object({
      vcs  = string
      repo = string
    })
    variables = list(map(string))
  }))
  default = {}
}

variable "variables" {
  type      = map(map(string))
  sensitive = true
}

variable "modules" {
  type    = list(string)
  default = []
}