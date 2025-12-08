check_input <- function(args) {
    if (length(args) > 1) {
        stop("Only one script argument is allowed which is github username.")
    } else if (length(args) < 1) {
        stop("One script argument is required which is github username.")
    }
}

get_lang_bytes <- function(repos, username) {
    lang_bytes <- list()
    for (repo in repos) {
        repo_name <- repo$name
        langs <- get_repo_langs(username, repo_name)
        lang_bytes[[repo_name]] <- langs
    }
    return(lang_bytes)
}