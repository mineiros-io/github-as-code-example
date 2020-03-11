locals {
  # default settings for private repositories
  private_defaults = {
    private            = true
    has_issues         = true
    allow_merge_commit = true

    topics = [
      "iac",
      "terraform",
      "terraform-modules",
    ]
  }

  # default settings for public repositories ( merge with private default settings )
  public_defaults = merge(local.private_defaults, {
    private          = false
    license_template = "apache-2.0"
  })

  default_branch_protections = [
    {
      branch         = "master"
      enforce_admins = false

      required_status_checks = {
        strict = true
      }

      required_pull_request_reviews = {
        dismiss_stale_reviews           = true
        require_code_owner_reviews      = true
        required_approving_review_count = length(module.team_reviewers.team_memberships)
        dismissal_teams                 = [module.team_contributors.slug]
      }
    }
  ]
}

module "public_repository" {
  source  = "mineiros-io/repository/github"
  version = "0.1.0"

  name               = "public-repository"
  homepage_url       = "https://medium.com/mineiros"
  description        = "A test repository create for demonstration purpose for the How to manage your GitHub Organization with Terraform article."
  defaults           = local.public_defaults
  branch_protections = local.default_branch_protections
  license_template   = "apache-2.0"
  gitignore_template = "Terraform"

  push_team_ids = [module.team_contributors.id]

  extra_topics = [
    "integrationtest",
    "terraform"
  ]
}

module "private_repository" {
  source  = "mineiros-io/repository/github"
  version = "0.1.0"

  name               = "terraform-aws-cloudfront"
  homepage_url       = "https://medium.com/mineiros"
  description        = "A test repository create for demonstration purpose for the How to manage your GitHub Organization with Terraform article."
  defaults           = local.private_defaults
  branch_protections = local.default_branch_protections
  license_template   = "apache-2.0"
  gitignore_template = "Terraform"

  push_team_ids = [module.team_contributors.id]

  extra_topics = [
    "anothertestrepository",
    "terraform"
  ]
}
