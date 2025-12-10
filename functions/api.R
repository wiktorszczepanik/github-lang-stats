USER = "GET /users/{username}"
REPOS = "GET /users/{username}/repos"
LANGS = "GET /repos/{owner}/{repo}/languages"

validate_user <- function(username) {
  tryCatch({
    gh(USER, username = username)
    invisible(TRUE)
  }, error = function(error) {
    if (grepl("404", error$message)) {
      stop(sprintf("User '%s' does not exist on GitHub.", username))
    } else {
      stop(error)
    }
  })
}

get_user_repos <- function(username) {
    gh(REPOS, username = username)
}

get_repo_langs <- function(owner, repo) {
    gh(LANGS, owner = owner, repo = repo)
}