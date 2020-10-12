# load packages -----------------------------------------------------------

## Package names
packages <- c("tidyverse", "reshape", "hablar", "here", "snakecase", "data.table", "conflicted")

## Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

## Packages loading
invisible(lapply(packages, library, character.only = TRUE))

select <- dplyr::select
rename <- reshape::rename
# load data ---------------------------------------------------------------

## note: downloaded from Qualtrics, made sure to export viewing order for randomized questions

raw <- read_csv(here("data", "raw.csv"))

# removing extra columns and row 2 --------------------------------------------------

raw <- raw %>%
  slice(-2) %>%
  select(-c(StartDate:UserLanguage, SC0, Condition))


# renaming columns --------------------------------------------------------

## first have to create sequences of numbers to use for identifying repeated measures

## creating empty data frame for entering sequences
y <- data.frame(
  matrix(
    ncol = 16, nrow = 32,
    dimnames = list(NULL, c(
      "idvoice", "trust", "dom", "threat",
      "intell", "comm", "prob", "conf", "trait_do", "team", "frnd",
      "neighbr", "employee", "boss", "role_do", "thoughts"
    ))
  )
)

## changing "to" argument for cols 15 and 16 for code to work

y[15] <- seq(from = 17, to = 513, by = 16)
y[16] <- seq(from = 18, to = 514, by = 16)
seq_length <- seq(from = 1, to = 14)

for (i in seq_length) {
  y[i] <- seq(2 + i, to = 16 * 32, by = 16)
}

## renaming repeated measures

for (i in names(y)) {
  names(raw)[y[, i]] <- i
}


## renaming other columns
raw <- raw %>% rename(
  c(
    Q286 = "age", Q288 = "educ", Q290 = "race",
    Q290_7_TEXT = "race_other", Q292 = "sex",
    Q294_1 = "residence", Q294_4_TEXT = "residence_other",
    Q296_1 = "pol_ideology", Q298 = "pol_party",
    Q298_4_TEXT = "pol_party_other", Q32 = "suspicion",
    Q32_4_TEXT = "suspicion_other", Q93 = "mc_name",
    Q82 = "mc_race_w", Q84 = "mc_race_b", Q236 = "feedback",
    Q93_DO = "mc_name_do", Q54_DO = "b_race_name_do",
    Q55_DO = "w_race_name_do", FL_3_DO = "cond_do",
    FL_153_DO = "name1", FL_154_DO = "voice1",
    FL_191_DO = "name2", FL_201_DO = "voice2",
    FL_219_DO = "name3", FL_232_DO = "voice3",
    FL_316_DO = "name4", FL_257_DO = "voice4",
    MCrace_DO = "mc_race_q_do", MCrace2_DO = "race_name_q_do",
    headphones_speakers_3_TEXT = "headphones_speakers_other",
    Score = "mc_name_score"
  )
)
names(raw) <- gsub("Q54", "b_race_name", names(raw))
names(raw) <- gsub("Q55", "w_race_name", names(raw))

# merging repeated columns to remove NAs ---------------------------------------------------------

names(raw) <- make.unique(names(raw))

for (i in names(y)) {
  raw[, i] <- raw %>%
    unite(i, names(raw[grep(i, names(raw))]),
          remove = T, na.rm = T
    ) %>%
    select(i)
}

## removing extra columns

raw <- raw %>% select(-c(idvoice.1:thoughts.31))


## separating repeated measures

for (i in names(y)) {
  raw[, paste0(i, 1:4)] <- raw %>%
    separate(i, paste0(i, 1:4),
             sep = "_", remove = T, extra = "drop"
    ) %>%
    select(paste0(i, 1:4))
}

## removing extra columns

raw <- raw %>% select(-names(y))

# export names and descriptions -----------------------------------------------------------

## storing in DF called col_names_des

col_names <- names(x = raw)
des <- unlist(raw[1, ], use.names = F)
col_names_des <- data.frame(cbind(col_names, des))

col_names_des <- col_names_des %>% add_row(
  col_names = c(
    "leadership_1", "leadership_2", "leadership_3", "leadership_4", "trust_rev1",
    "trust_rev2", "trust_rev3", "trust_rev4", "threatpotential_1",
    "threatpotential_2", "threatpotential_3", "threatpotential_4"
  ),
  des = c(
    "leadership composite for condition with Black name and high pitched voice",
    "leadership composite for condition with Black name and low pitched voice",
    "leadership composite for condition with White name and high pitched voice",
    "leadership composite for condition with White name and low pitched voice",
    "reverse-scored trustworthiness ratings for condition with Black name and high pitched voice",
    "reverse-scored trustworthiness ratings for condition with Black name and low pitched voice",
    "reverse-scored trustworthiness ratings for condition with White name and high pitched voice",
    "reverse-scored trustworthiness ratings for condition with White name and low pitched voice",
    "threat potential for condition with Black name and high pitched voice",
    "threat potential for condition with Black name and low pitched voice",
    "threat potential for condition with White name and high pitched voice",
    "threat potential for condition with White name and low pitched voice"
  )
)

write.csv(col_names_des, here("data", "vars-and-labels.csv"), row.names = F)

## removing extra row (description from qualtrics)

raw <- raw[-1, ]


# converting vars to numeric  ----------------------------------------------

raw <- raw %>% retype()


# composite leadership --------------------------------------------------------------

## selecting relevant columns


s <- grep("^intell|^comm|^prob|^conf", names(raw))

## have to find the mean for each group within condition & repeat for each condition

for (i in seq(1:4)) {
  raw <- raw %>% mutate(!!paste0("leadership", i) := rowMeans(raw[seq(from = s[i], to = s[length(s)], by = 4)], na.rm = T))
}


# composite threat potential ----------------------------------------------


## threat potential measure will be calculated by reverse-scoring the trustworthiness measure (100-trust scores)

## first reverse-scoring all four trust items

raw <- raw %>% mutate(
  trust_rev1 = 100 - trust1,
  trust_rev2 = 100 - trust2,
  trust_rev3 = 100 - trust3,
  trust_rev4 = 100 - trust4
)

## selecting relevant columns

s <- grep("^dom|^trust_rev", names(raw))

for (i in seq(1:4)) {
  raw <- raw %>% mutate(!!paste0("threatpotential", i) := rowMeans(raw[c(s[i], s[i + 4])], na.rm = T))
}

# recoding display order vars --------------------------------------------


raw$name1 <- dplyr::recode(raw$name1, FL_171 = "Deshawn", FL_172 = "Tyrone", FL_182 = "Terrell", FL_183 = "Keyshawn")

raw$voice1 <- dplyr::recode(raw$voice1,
                            FL_155 = "a", FL_156 = "b", FL_157 = "c", FL_158 = "d",
                            FL_159 = "e", FL_160 = "f", FL_161 = "g", FL_162 = "h"
)

raw$name2 <- dplyr::recode(raw$name2, FL_193 = "Deshawn", FL_195 = "Tyrone", FL_197 = "Terrell", FL_199 = "Keyshawn")

raw$voice2 <- dplyr::recode(raw$voice2,
                            FL_202 = "a", FL_204 = "b", FL_205 = "c", FL_206 = "d",
                            FL_207 = "e", FL_208 = "f", FL_209 = "g", FL_210 = "h"
)

raw$name3 <- dplyr::recode(raw$name3, FL_220 = "Scott", FL_221 = "Brad", FL_222 = "Logan", FL_223 = "Brett")

raw$voice3 <- dplyr::recode(raw$voice3,
                            FL_233 = "a", FL_236 = "b", FL_238 = "c", FL_240 = "d",
                            FL_242 = "e", FL_244 = "f", FL_246 = "g", FL_248 = "h"
)

raw$name4 <- dplyr::recode(raw$name4, FL_317 = "Scott", FL_319 = "Brad", FL_321 = "Logan", FL_323 = "Brett")

raw$voice4 <- dplyr::recode(raw$voice4,
                            FL_258 = "a", FL_259 = "b", FL_260 = "c", FL_261 = "d",
                            FL_262 = "e", FL_263 = "f", FL_264 = "g", FL_265 = "h"
)


# long format -------------------------------------------------------------

raw[, "id"] <- seq(1, nrow(raw))

setnames(raw, old = raw %>% select(idvoice1:conf4, team1:boss4, leadership1:leadership4, name1:voice4, threatpotential1:threatpotential4) %>% names(), new = snakecase::to_any_case(raw %>% select(idvoice1:conf4, team1:boss4, leadership1:leadership4, name1:voice4, threatpotential1:threatpotential4) %>% names()))

long <- raw %>%
  gather(Column, Value, idvoice_1:conf_4, team_1:boss_4, leadership_1:leadership_4, name_1:voice_4, threatpotential_1:threatpotential_4) %>%
  separate(Column, into = c("Column", "condition"), sep = "_") %>%
  spread(Column, Value)

long$condition <- dplyr::recode(long$condition, "1" = "BH", "2" = "BL", "3" = "WH", "4" = "WL")

## separating race and voice pitch variables to test & plot interaction effects

x <- do.call(rbind, strsplit(long$condition, ""))
long <- cbind(long, x)

long <- long %>% rename(c("1" = "cond_race", "2" = "cond_pitch"))

long$cond_pitch <- factor(long$cond_pitch)

levels(long$cond_pitch) <- c("High", "Low")

long$cond_race <- factor(long$cond_race)

levels(long$cond_race) <- c("Black", "White")

##changing var type 
long <- long %>% retype()

## recoding condition & race vars

long$cond_pitchC <- as.numeric(ifelse(long$cond_pitch == "Low",1,2)) - 1.5
long$cond_raceC <- as.numeric(ifelse(long$cond_race == "Black",1,2)) - 1.5

# export clean wide and long data -------------------------------------------------------

write.csv(raw, here("data", "wide.csv"), row.names = F)
write.csv(long, here("data", "long.csv"), row.names = F)
