# load packages -----------------------------------------------------------

## Package names
packages <- c("here", "tidyverse", "lme4", "nlme", "lmerTest")

## Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

## Packages loading
invisible(lapply(packages, library, character.only = TRUE))

# load data ---------------------------------------------------------------

long <- read_csv(here("data", "long.csv"))

# primary hypothesis 1 ----------------------------------------------------

## models that will be compared for fit:

## keeping default settings maximum likelihood because we aren't compared fixed effects 

## 1) model with fixed effects + all random intercepts possible
intercept_only <- lmer(threat ~ cond_race*cond_pitch + (1|id) + (1|voice), data = long)

## 2) model with fixed effects + all random intercept + all random slopes possible 

random_slope <- lmer(threat ~ cond_race*cond_pitch + (cond_race+cond_pitch|id) + (cond_race+cond_pitch|voice), data = long)

## trying random slope interactions does not work: " the random-effects parameters and the residual variance (or scale parameter) are probably unidentifiable"
## random_slope <- lmer(threat ~ cond_race*cond_pitch + (cond_race*cond_pitch|id) + (cond_race*cond_pitch|voice), data = long)
## random_slope <- lmer(threat ~ cond_race*cond_pitch + (cond_race*cond_pitch|id) + (cond_race+cond_pitch|voice), data = long)

## isSingular: random_slope <- lmer(threat ~ cond_race*cond_pitch + (cond_race+cond_pitch|id) + (cond_race*cond_pitch|voice), data = long)

anova(intercept_only, random_slope, refit = F)

# primary hypothesis 2 ----------------------------------------------------

## models that will be compared for fit:

## keeping default settings maximum likelihood because we aren't compared fixed effects 

## 1) model with all random intercepts possible

intercept_only <- lmer(leadership ~ cond_race*cond_pitch + (1|id) + (1|voice), data = long)

## 2) model with all random intercepts + all random slopes possible 

random_slope <- lmer(leadership ~ cond_race*cond_pitch + (cond_race+cond_pitch|id) + (cond_race+cond_pitch|voice), data = long)
anova(intercept_only, random_slope)

## compare intercept only to model without random intercepts

# fixed_only <- lm(leadership ~cond_race*cond_pitch, data = long)
# anova(intercept_only, fixed_only)

# secondary hypothesis 1 (trust) --------------------------------------------------

## models that will be compared for fit:

## keeping default settings maximum likelihood because we aren't compared fixed effects 

## 1) model with all random intercepts possible

intercept_only <- lmer(threat ~ trust_scaled + (1|id) + (1|voice), data = long)

## 2) model with all random intercepts + all random slopes possible

## need to rescale - otherwise error message 
long$trust_scaled <- scale(long$trust)
random_slope <- lmer(threat ~ trust_scaled + (trust_scaled|id)+ (trust_scaled|voice), data = long)

anova(intercept_only, random_slope, refit = F)

# secondary hypothesis 2 (dominance)  -------------------------------------

## models that will be compared for fit:

## keeping default settings maximum likelihood because we aren't compared fixed effects 

## 1) model with all random intercepts possible

intercept_only <- lmer(threat ~ dom + (1|id) + (1|voice), data = long)
## compare intercept only to model without random intercepts

fixed_only <- lm(threat ~dom, data = long)
anova(intercept_only, fixed_only)

## 2) model with all random intercepts + all random slopes possible

## need to rescale - otherwise error message 
## long$dom_scaled <- scale(long$dom)
## is singular: random_slope <- lmer(threat ~ dom_scaled + (dom_scaled|id)+ (dom_scaled|voice), data = long)
## had same issue when trying to deal with convergendce issue from original var

# secondary_hyp1b_slopes <- lmer(threat ~ dom + (dom|id) + (dom|voice), data = long,
# control=lmerControl(optimizer="bobyqa",
#                     optCtrl=list(maxfun=2e5)))


# secondary hypothesis 2 --------------------------------------------------

## models that will be compared for fit:

## keeping default settings maximum likelihood because we aren't compared fixed effects 

## 1) model with all random intercepts possible

intercept_only <- lmer(trust ~ cond_race + (1|id) + (1|voice), data = long)

## 2) model with all random intercepts + all random slopes possible 
random_slope <- lmer(trust ~ cond_race+ (cond_race|id) + (cond_race|voice), data = long)
anova(intercept_only, random_slope)

# secondary hypothesis 3 --------------------------------------------------

## 1) model with all random intercepts possible

intercept_only <- lmer(dom~ cond_pitch + (1|id) + (1|voice), data = long)

## 2) model with all random intercepts + all random slopes possible 

random_slope <- lmer(dom ~ cond_pitch+ (cond_pitch|id) + (cond_pitch|voice), data = long)
anova(intercept_only, random_slope)

# secondary hypothesis 4 --------------------------------------------------

## models that will be compared for fit:

## 1) model with fixed effects + all random intercepts possible

intercept_only <- lmer(threatpotential ~ cond_race*cond_pitch + (1|id) + (1|voice), data = long)
fixed_only <- lm(threatpotential ~cond_race*cond_pitch, long)
## 2) model with fixed effects + all random intercept + all random slopes possible 

## is Singular:

# random_slope <- lmer(threatpotential~ cond_race*cond_pitch + (cond_race+cond_pitch|id) + (cond_race+cond_pitch|voice), data = long,
#                      control=lmerControl(optimizer="bobyqa",
#                      optCtrl=list(maxfun=2e5)))
anova(intercept_only, fixed_only)
