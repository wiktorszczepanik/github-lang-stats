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
# total_size <- langs_bytes_sum(lang_total)

data_frame <- get_data_frame(lang_total)
df_sorted <- cleaned_data_frame(data_frame)
language_colors <- legend_colors()

svg("programming_languages.svg", width = 18.3, height = 2.7)

ggplot(df_sorted, aes(x = "", y = share, fill = languages)) +
    geom_col(width = 0.5) +
    coord_flip() +
    scale_y_continuous(expand = c(0,0)) +
    scale_fill_manual(values = language_colors, labels = df_sorted$label) +
    labs(x = NULL, y = "", fill = "") +
    guides(fill = guide_legend(
        nrow = 2,
        byrow = TRUE,
        reverse = FALSE,
        keywidth = 1.4
    )) +
    theme_minimal(base_size = 18) +
    theme(
        # Dark background
        panel.background = element_rect(fill = "#0d1117", color = NA),
        plot.background = element_rect(fill = "#0d1117", color = NA),

        # White font
        text = element_text(color = "white"),
        axis.text = element_text(color = "white"),
        axis.title = element_text(color = "white"),
        legend.text = element_text(color = "white", size = 15.2),
        legend.title = element_text(color = "white"),
        plot.title = element_text(color = "white", face = "bold", size = 20, margin = margin(b = 15)),
        plot.margin = margin(t = 30, b = 40, l = 15, r = 15),

        # Hide X
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),

        # Legend
        legend.background = element_rect(fill = "#0d1117", color = NA),
        legend.key = element_rect(fill = "#0d1117", color = NA),
        legend.spacing.x = unit(2, "cm"),
        legend.position = "bottom",
        legend.direction = "horizontal",
        legend.box = "horizontal",
        legend.margin = margin(0, 6, 0, 0),

        # Grid
        panel.grid = element_blank(),
        panel.spacing = unit(0, "pt"),
    )

invisible(dev.off())
cat("Done!", "\n")
