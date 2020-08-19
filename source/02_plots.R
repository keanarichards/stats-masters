# load packages -----------------------------------------------------------

## Package names
packages <- c("here", "tidyverse")

## Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

## Packages loading
invisible(lapply(packages, library, character.only = TRUE))

# load data ---------------------------------------------------------------

long <- read_csv(here("data", "long.csv"))

theme_set(theme_bw(base_size = 12, base_family = ""))
install.packages("pairwiseComparisons")
## https://ademos.people.uic.edu/Chapter16.html
## use ean

slope_voice <- long %>%
  group_by(cond_race, cond_pitch, voice) %>%
  summarise(mean_threat = mean(threat))

ggplot(data = slope_voice, aes(x = cond_race, y = mean_threat, group = cond_pitch)) +
  facet_grid(~voice) +
  geom_point(aes(colour = cond_pitch)) +
  geom_smooth(method = "lm", se = TRUE, aes(colour = cond_pitch)) +
  xlab("race condition") +
  ylab("threat")


qplot(cond_race, threat,
  facets = cond_pitch ~ voice,
  colour = voice, geom = "boxplot", data = long
)


qplot(cond_race, leadership,
  facets = cond_pitch ~ voice,
  colour = voice, geom = "boxplot", data = long
)



ggplot(data = long, aes(x = cond_race, y = threat, group = voice)) +
  facet_grid(~voice) +
  geom_smooth(method = "lm", se = TRUE, aes(colour = voice)) +
  xlab("condition") +
  ylab("threat") +
  theme(legend.position = "none")
