# load packages -----------------------------------------------------------


## Package names
packages <- c("readr", "tidyverse", "reshape", "hablar")

## Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

## Packages loading
invisible(lapply(packages, library, character.only = TRUE))


# load data ---------------------------------------------------------------

## note: downloaded from Qualtrics, made sure to export viewing order for randomized questions

raw <- read_csv("data/raw2.csv")

# removing extra columns and row 2 --------------------------------------------------

raw <- raw %>% slice(-2) %>% select(-c(StartDate:UserLanguage, SC0, Condition))


# renaming columns --------------------------------------------------------

## first have to create sequences of numbers to use for identifying repeated measures

## creating empty data frame for entering sequences
y <- data.frame(matrix(ncol=16,nrow=32, 
                       dimnames=list(NULL, c("id_voice", "trust", "dom", "threat", 
                                             "intell", "comm", "prob", "conf", "trait_do", "team", "frnd", 
                                             "neighbr", "employee", "boss", "role_do", "thoughts"))))

## changing "to" argument for cols 15 and 16 for code to work

y[15] <- seq(from= 17, to = 513, by = 16)
y[16] <- seq(from= 18, to = 514, by = 16)
seq_length <- seq(from = 1, to= 16)

for(i in seq_length) {
  y[i] = seq(2+ i, to = 16*32, by = 16)
}

## renaming repeated measures

for(i in names(y)){
  names(raw)[y[, i]] <- i
}

## renaming other columns
raw <- raw %>% rename(c(Q286 = "age", Q288="educ", Q290= "race", 
                        Q290_7_TEXT = "race_other", Q292 = "sex", 
                        Q294_1 = "residence", Q294_4_TEXT = "residence_other", 
                        Q296_1 = "pol_ideology", Q298="pol_party", 
                        Q298_4_TEXT= "pol_party_other", Q32 = "suspicion", 
                        Q32_4_TEXT = "suspicion_other", Q93= "mc_name", 
                        Q82 = "mc_race_w", Q84 = "mc_race_b", Q236 = "feedback", 
                        Q93_DO = "mc_name_do", Q54_DO = "b_race_name_do", 
                        Q55_DO = "w_race_name_do", FL_3_DO = "cond_do",
                        FL_153_DO = "name_BH", FL_154_DO = "voice_BH", 
                        FL_191_DO = "name_BL", FL_201_DO = "voice_BL",
                        FL_219_DO = "name_WH", FL_232_DO = "voice_WH",
                        FL_316_DO = "name_WL", FL_257_DO = "voice_WL",
                        MCrace_DO = "mc_race_q_do", MCrace2_DO = "race_name_q_do",
                        headphones_speakers_3_TEXT = "headphones_speakers_other",
                        Score = "mc_name_score"))
names(raw) <- gsub("Q54", "b_race_name", names(raw))
names(raw) <- gsub("Q55", "w_race_name", names(raw))


# merging repeated columns to remove NAs ---------------------------------------------------------

names(raw) <- make.unique(names(raw))

for(i in names(y)) {
  raw[,i] <- raw %>% unite(i, names(raw[grep(i, names(raw))])
, remove = T, na.rm = T) %>% select(i)
}

## removing extra columns

raw <- raw %>% select(-c(id_voice.1:thoughts.31))


## separating repeated measures

for(i in names(y)) {
  raw[,paste0(i, 1:4)] <- raw %>% separate(i, paste0(i, 1:4), sep = "_", remove = T, extra = "drop") %>% select(paste0(i, 1:4))
}

## removing extra columns

raw <- raw %>% select(-names(y))


# export names and descriptions -----------------------------------------------------------

## storing in DF called col_names_des

col_names <-names(x = raw)
des <-unlist(raw[1,], use.names = F)
col_names_des <- cbind(col_names, des) 

## removing extra row (description from qualtrics)

raw <- raw[-1, ]

# converting vars to numeric  ----------------------------------------------

raw <- raw %>% retype()

# composite leadership --------------------------------------------------------------

## selecting relevant columns

s <- grep("^intell|^comm|^prob|^conf", names(raw))

## have to repeat for each condition

for (i in seq(1:4)) {
  raw <-raw %>% mutate(!!paste0("leadership",i):=rowMeans(raw[seq(from = s[i], to = s[16], by= 4)], na.rm = T))
}

# long format -------------------------------------------------------------

raw[, "id"] <- seq(1, nrow(raw))

long <- raw %>% pivot_longer(cols = c(trust1:conf4, team1:boss4, leadership1:leadership4), names_to = c("var", "cond"), names_pattern = "(.*)([1-4])", values_to = "value")

# export clean data -------------------------------------------------------

vignette("pivot")
