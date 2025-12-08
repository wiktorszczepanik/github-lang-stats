REPOS = "GET /users/{username}/repos"
LANGS = "GET /repos/{owner}/{repo}/languages"

get_user_repos <- function(username) {
    gh(REPOS, username = username)
}

get_repo_langs <- function(owner, repo) {
    gh(LANGS, owner = owner, repo = repo)
}