# load packages -----------------------------------------------------------

## Package names
packages <- c("here", "tidyverse", "lme4", "nlme", "lmerTest", "buildmer", "memisc", "robustlmm", "plm", "broom.mixed")

## Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

## Packages loading
invisible(lapply(packages, library, character.only = TRUE))

lmer <- lmerTest::lmer

# load data ---------------------------------------------------------------

long <- read_csv(here("data", "long.csv"))

# primary hypothesis 1 ----------------------------------------------------

max_model1 <- lmer(threat ~ cond_pitchC*cond_raceC + (cond_raceC+cond_pitchC|id) + (cond_raceC+cond_pitchC|voice), data = long)
buildmer(formula(max_model1),data=long,control=lmerControl(optimizer='bobyqa'))
fin_mod1 <- lmer(threat ~ cond_pitchC*cond_raceC + (1 +cond_raceC + cond_pitchC| id) + (1 + cond_pitchC | voice), data= long, control = lmerControl(optimizer = "bobyqa"))
# fin_mod1a <- rlmer(threat ~ cond_pitchC*cond_raceC + (1 +cond_raceC + cond_pitchC| id) + (1 + cond_pitchC | voice), data= long, control = lmerControl(optimizer = "bobyqa"), method = "DASvar", init =lmerNoFit)

rea1 <- phtest(plm(threat ~ cond_pitchC*cond_raceC, index = c("voice","id"), data = long, model = "within"), plm(threat ~ cond_pitchC*cond_raceC, index = c("voice","id"), data = long, model = "random"))

tidy1 <- tidy(fin_mod1, conf.int = TRUE)

# primary hypothesis 2 ----------------------------------------------------

max_model2 <- lmer(leadership ~ cond_pitchC*cond_raceC  + (cond_raceC+cond_pitchC|id) + (cond_raceC+cond_pitchC|voice), data = long)
buildmer(formula(max_model2),data=long,control=lmerControl(optimizer='bobyqa'))
fin_mod2 <- lmer(leadership ~ cond_pitchC*cond_raceC + (1 + cond_pitchC | voice) +  (1 | id), data= long, control = lmerControl(optimizer = "bobyqa"))
# fin_mod2a <- rlmer(leadership ~ cond_pitchC*cond_raceC + (1 + cond_pitchC | voice) +  (1 | id), data= long)

rea2 <- phtest(plm(leadership ~ cond_pitchC*cond_raceC, index = c("voice","id"), data = long, model = "within"), plm(leadership ~ 1 + cond_pitchC*cond_raceC, index = c("voice","id"), data = long, model = "random"))

tidy2 <- tidy(fin_mod2, conf.int = TRUE)


# secondary hypothesis 1 --------------------------------------------------

max_model3 <- lmer(threat ~ trust + dom + (trust+dom |id)+ (trust +dom|voice), data = long,  control=lmerControl(optimizer="bobyqa"))
buildmer(formula(max_model3),data=long,control=lmerControl(optimizer='bobyqa'))
fin_mod3 <- lmer(threat ~ trust + dom + (1 | id) + (1 | voice), data= long, control = lmerControl(optimizer = "bobyqa"))

rea3 <- phtest(plm(threat ~ trust + dom, index = c("voice","id"), data = long, model = "within"), plm(threat ~ trust, index = c("voice","id"), data = long, model = "random"))

## cluster mean centering 
long$domC_id <- long$dom - ave(long$dom,long$id)
long$trustC_id <- long$trust - ave(long$trust,long$id)
long$domC_voice <- long$dom - ave(long$dom,long$voice)
long$trustC_voice <- long$trust - ave(long$trust,long$voice)

fin_mod3 <- lmer(threat ~ trust + dom + trustC_id + domC_id +domC_voice +trustC_voice + (1 | id) + (1 | voice), data= long, control = lmerControl(optimizer = "bobyqa"))
# fin_mod3a <- rlmer(threat ~ trust + dom + trustC_id + domC_id +domC_voice +trustC_voice +(1| id) + (1| voice), data= long, control = lmerControl(optimizer = "bobyqa"))

tidy3 <- tidy(fin_mod3, conf.int = TRUE)

# secondary hypothesis 2 --------------------------------------------------

max_model5 <- lmer(trust ~ cond_raceC+ (cond_raceC|id) + (cond_raceC|voice), data = long)
buildmer(formula(max_model5),data=long,control=lmerControl(optimizer='bobyqa'))
fin_mod5 <- lmer(trust ~ cond_raceC + (1 | id) + (1 | voice), data= long, control = lmerControl(optimizer = "bobyqa"))
# fin_mod5a <- rlmer(trust ~ cond_raceC + (1 | id) + (1 | voice), data= long, control = lmerControl(optimizer = "bobyqa"))

rea5 <- phtest(plm(trust ~ cond_raceC, index = c("voice","id"), data = long, model = "within"), plm(trust ~ cond_raceC, index = c("voice","id"), data = long, model = "random"))

tidy5 <- tidy(fin_mod5, conf.int = TRUE)


# secondary hypothesis 3 --------------------------------------------------
max_model6 <- lmer(dom ~ cond_pitchC+ (cond_pitchC|id) + (cond_pitchC|voice), data = long)
buildmer(formula(max_model6),data=long,control=lmerControl(optimizer='bobyqa'))
fin_mod6 <- lmer(dom ~ cond_pitchC + (1 | voice) + (1 | id), data= long, control = lmerControl(optimizer = "bobyqa"))
# fin_mod6a <- rlmer(dom ~ cond_pitchC + (1 | voice) + (1 | id), data= long, control = lmerControl(optimizer = "bobyqa"))

rea6 <- phtest(plm(dom ~ cond_pitchC, index = c("voice","id"), data = long, model = "within"), plm(dom ~ cond_pitchC, index = c("voice","id"), data = long, model = "random"))

tidy6 <- tidy(fin_mod6, conf.int = TRUE)


# secondary hypothesis 4 --------------------------------------------------

max_model7 <- lmer(threatpotential~ cond_raceC*cond_pitchC + (cond_raceC+cond_pitchC|id) + (cond_raceC+cond_pitchC|voice), data = long)
buildmer(formula(max_model7),data=long,control=lmerControl(optimizer='bobyqa'))
fin_mod7 <- lmer(threatpotential ~ cond_raceC*cond_pitchC + (1 + cond_pitchC | voice) +  (1 | id), data= long, control = lmerControl(optimizer = "bobyqa"))
# fin_mod7a <- rlmer(threatpotential ~cond_raceC*cond_pitchC + (1 + cond_pitchC | voice) +  (1 | id), data= long, control = lmerControl(optimizer = "bobyqa"), init =lmerNoFit)

rea7 <- phtest(plm(threatpotential ~ cond_raceC*cond_pitchC, index = c("voice","id"), data = long, model = "within"), plm(threatpotential ~ cond_pitchC, index = c("voice","id"), data = long, model = "random"))

tidy7 <- tidy(fin_mod7, conf.int = TRUE)

