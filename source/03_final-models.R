# load packages -----------------------------------------------------------

## Package names
packages <- c("here", "tidyverse", "lmerTest", "lmer", "MCMC")

## Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

## Packages loading
invisible(lapply(packages, library, character.only = TRUE))

# load data ---------------------------------------------------------------

long <- read_csv(here("data", "long.csv"))

## primary hypothesis 1: testing main effects & interaction between race and voice pitch on perceived threat

## LRT suggests slopes is significantly better fit

primary_hyp1_intercepts <- lmer(threat ~ cond_race * cond_pitch + (1 | id) + (1 | voice), data = long)
primary_hyp1_slopes <- lmer(threat ~ cond_race * cond_pitch + (cond_race + cond_pitch | id) + (cond_race + cond_pitch | voice), data = long)

primary_hyp1_test <- anova(primary_hyp1_intercepts, primary_hyp1_slopes, refit = F)

## primary hypothesis 2: testing main effects & interaction between race and voice pitch on perceived leadership ability

# random slopes model converges, but is not significantly better than the intercept only model

primary_hyp2_intercepts <- lmer(leadership ~ cond_race * cond_pitch + (1 | id) + (1 | voice), data = long)
primary_hyp2_slopes <- lmer(leadership ~ cond_race * cond_pitch + (cond_race + cond_pitch | id) + (cond_race + cond_pitch | voice), data = long)

primary_hyp2_test <- anova(primary_hyp2_intercepts, primary_hyp2_slopes, refit = F)

## secondary hypothesis 1: perceived trustworthiness will negatively predict threat, while perceived dominance will positively predict threat

long$trust_scaled <- scale(long$trust)

secondary_hyp1a_intercepts <- lmer(threat ~ trust_scaled + (1 | id) + (1 | voice), data = long)
secondary_hyp1a_slopes <- lmer(threat ~ trust_scaled + (trust_scaled | id) + (trust_scaled | voice), data = long)

secondary_hyp1a_test <- anova(secondary_hyp1a_intercepts, secondary_hyp1a_slopes, refit = F)

secondary_hyp1b_intercepts <- lmer(threat ~ dom + (1 | id) + (1 | voice), data = long)
## because the slopes model wouldn't converge (even after scaling, will compare model with only intercepts to model with only fixed effects)

fixed_only <- lm(threat ~ dom, data = long)
secondary_hyp1b_test <- anova(secondary_hyp1b_intercepts, fixed_only)

## secondary hypothesis 2: main effect of race on trustworthiness

secondary_hyp2_intercepts <- lmer(trust ~ cond_race + (1 | id) + (1 | voice), data = long)
secondary_hyp2_slopes <- lmer(trust ~ cond_race + (cond_race | id) + (cond_race | voice), data = long)

secondary_hyp2_test <- anova(secondary_hyp2_intercepts, secondary_hyp2_slopes)

## secondary hypothesis 3: main effect of voice pitch on perceived dominance

secondary_hyp3_intercepts <- lmer(dom ~ cond_pitch + (1 | id) + (1 | voice), data = long)
secondary_hyp3_slopes <- lmer(dom ~ cond_pitch + (cond_pitch | id) + (cond_pitch | voice), data = long)
secondary_hyp3_test <- anova(secondary_hyp3_intercepts, secondary_hyp3_slopes)

## secondary hypothesis 4: main effect of race on threat potential & voice pitch and race will interact to affect threat potential

secondary_hyp4_intercepts <- lmer(threatpotential ~ cond_race * cond_pitch + (1 | id) + (1 | voice), data = long)
secondary_hyp4_fixed <- lm(threatpotential ~ cond_race * cond_pitch, long)

secondary_hyp4_test <- anova(secondary_hyp4_intercepts, secondary_hyp4_fixed)
