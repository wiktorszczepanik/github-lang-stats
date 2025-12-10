input_values <- function() {
    input <- function(prompt_text) {
        cat(prompt_text)
        readLines(con = "stdin", n = 1)
    }
    username <- input(prompt = "Enter username: ")
    answer <- input(prompt = "Do you want to enter optional Github token [No/Yes]: ")
    state <- tolower(answer)
    if (state == "yes") {
        temp_token <- input(prompt = "Enter Github token: ")
        Sys.setenv(GITHUB_PAT = temp_token)
    }
    return(username)
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

aggregate_lang_bytes <- function(lang_list) {
    out <- list()
    for (repo in lang_list) {
        for (lang in names(repo)) {
            out[[lang]] <- (out[[lang]] %||% 0) + repo[[lang]]
        }
    }
    return(out)
}

langs_bytes_sum <- function(lang_list) {
    total_size <- sum(unlist(lang_list))
    return(total_size)
}

get_data_frame <- function(lang_list) {
    df = data.frame(
        languages = names(lang_list),
        share = unlist(lang_list),
        row.names = NULL
    )
}

legend_colors <- function() {
    my_colors <- c(
        Python = "#377eb8",
        SQL = "#4daf4a",
        Java = "#e41a1c",
        VBA = "#984ea3",
        `Visual Basic 6.0` = "#ff7f00",
        `C++` = "#ffff33"
    )
}
