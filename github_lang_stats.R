library(gh)
library(jsonlite)
library(ggplot2)
source("functions/man.R")
source("functions/api.R")

# Input
username <- input_values() # + optional Github token
validate_user(username)

# Collect info
my_repos <- get_user_repos(username)
lang_bytes <- get_lang_bytes(my_repos, username)
lang_total <- aggregate_lang_bytes(lang_bytes)
total_size <- langs_bytes_sum(lang_total)

df = get_data_frame(lang_total)
df_sorted <- df[order(df$share, decreasing = TRUE), ]
df_sorted$languages <- factor(df_sorted$languages, levels = df_sorted$languages)
language_colors <- fromJSON("assets/colors.json")
df_sorted$percent <- df_sorted$share / sum(df_sorted$share)
df_sorted$label <- paste0(df_sorted$languages, " (", round(df_sorted$share / sum(df_sorted$share) * 100, 1), "%)")

svg("test.svg", width = 18, height = 6)

ggplot(df_sorted, aes(x = "All", y = share, fill = languages)) +
    geom_col() +
    coord_flip() +
    scale_fill_manual(values = language_colors, labels = df_sorted$label) +
    labs(title = "Most used languages", x = NULL, y = "Share size", fill = "") +
    guides(fill = guide_legend(
        nrow = 2,
        byrow = TRUE,
        reverse = FALSE
    )) +
    theme_minimal(base_size = 14) +
    theme(
        # Dark background
        panel.background = element_rect(fill = "#0d1117", color = NA),
        plot.background = element_rect(fill = "#0d1117", color = NA),
        legend.background = element_rect(fill = "#0d1117", color = NA),
        legend.key = element_rect(fill = "#0d1117", color = NA),

        # White font
        text = element_text(color = "white"),
        axis.text = element_text(color = "white"),
        axis.title = element_text(color = "white"),
        legend.text = element_text(color = "white", size = 12),
        legend.title = element_text(color = "white"),
        plot.title = element_text(color = "white", face = "bold", size = 16),

        # Hide X
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),

        # Legend
        legend.position = "bottom",
        legend.justification = "center",
        legend.box = "horizontal"
    )

invisible(dev.off())
print("Done!")
