variable "org" {
  type = string
}

variable "email" {
  type = string
}

variable "users" {
  type = list(string)
}

variable "github_oauth_token" {
  type      = string
  sensitive = true
  default   = null
}

variable "workspaces" {
  type = map(object({
    workdir   = string
    exec      = string
    vcs_repo  = string
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