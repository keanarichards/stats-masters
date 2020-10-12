# load packages -----------------------------------------------------------

## Package names
packages <- c("tidyverse", "here", "psych")

## Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

## Packages loading
invisible(lapply(packages, library, character.only = TRUE))




# load data ---------------------------------------------------------------

wide <- read_csv(here("data", "wide.csv"))

# find alpha for each condition, then average across all 4 of them  -------

scaleKey <- rep(1, 4)
alphas <- rep(1,4)
for (i in 1:4){
alphas[i] <- scoreItems(keys = scaleKey, items = wide %>% dplyr::select(paste0("intell_", i), paste0("conf_", i),paste0("comm_", i),paste0("prob_", i)))$alpha
}
