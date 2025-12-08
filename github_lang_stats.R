library(gh)
source("functions/man.R")
source("functions/api.R")


# Username
args <- commandArgs(trailingOnly = TRUE)
check_input(args)
username = args[1]

# Collect info
my_repos <- get_user_repos(username)
lang_bytes <- get_lang_bytes(my_repos, username)
all_langs <- unlist(lang_bytes)
lang_sum <- tapply(all_langs, names(all_langs), sum)

# Math
lang_percent <- round(100 * lang_sum / sum(lang_sum), 1)

# Temp view
lang_percent <- sort(lang_percent, decreasing = TRUE)
print(lang_percent)
