COLORS = "assets/colors.json"

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
    return(fromJSON(COLORS))
}

cleaned_data_frame <- function(df) {
    df_sorted <- df[order(df$share, decreasing = TRUE), ]
    df_sorted$languages <- factor(df_sorted$languages, levels = df_sorted$languages)
    df_sorted$percent <- df_sorted$share / sum(df_sorted$share)
    df_sorted$label <- paste0(df_sorted$languages, " (", round(df_sorted$share / sum(df_sorted$share) * 100, 1), "%)")
    return(df_sorted)
}
