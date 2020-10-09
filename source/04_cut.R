
# models ------------------------------------------------------------------

# contrast coding

# long$cond_raceC <- factor(long$cond_race)
# long$cond_pitchC <- factor(long$cond_pitch)
# contrasts(long$cond_raceC) <- contr.sum(2)
# contrasts(long$cond_pitchC) <- contr.sum(2)

# reduced_model1 <- lmer(threat ~ cond_race*cond_pitch + (cond_race+cond_pitch|id) + (cond_pitch|voice), data = long)
# 
# anova(reduced_model1, max_model1, refit = F)
# 
# reduced_model1a <- lmer(threat ~ cond_race*cond_pitch + (cond_race+cond_pitch|id) + (1|voice), data = long)
# 
# anova(reduced_model1a, reduced_model1, refit = F)
# 



# reduced_model2 <- lmer(leadership ~ cond_race*cond_pitch + (cond_pitch|id) + (cond_race+cond_pitch|voice), data = long)
# 
# anova(reduced_model2, max_model2, refit = F)
# 
# reduced_model2a <- lmer(leadership ~ cond_race*cond_pitch + (cond_pitch|id) + (cond_pitch|voice), data = long)
# 
# reduced_model2b <- lmer(leadership ~ cond_race*cond_pitch + (1|id) + (cond_pitch|voice), data = long)
# 
# anova(reduced_model2b, reduced_model2a, refit = F)
# 
# reduced_model2c <- lmer(leadership ~ cond_race*cond_pitch + (1|id) + (1|voice), data = long)
# 
# 
# anova(reduced_model2c, reduced_model2b, refit = F)



# reduced_model3 <- lmer(threat ~ trustC+ (trustC|id)+ (1|voice), data = long,  control=lmerControl(optimizer="bobyqa"))
# 
# anova(reduced_model3, max_model3, refit = F)
# 
# reduced_model3a <- lmer(threat ~ trustC+ (1|id)+ (1|voice), data = long,  control=lmerControl(optimizer="bobyqa"))
# 
# anova(reduced_model3a, max_model3, refit = F)
# 

# reduced_model4 <- lmer(threat ~ domC+ (1|id), data = long)
# 
# anova(reduced_model4, max_model4, refit = F)
# 

# reduced_model5 <- lmer(trust ~ cond_pitchC+ (cond_pitchC|id) + (1|voice), data = long)
# 
# anova(reduced_model5, max_model5, refit = F)

# reduced_model6 <- lmer(dom ~ cond_pitch+ (cond_pitch|id) + (1|voice), data = long)
# 
# anova(reduced_model6, max_model6, refit = F)


# reduced_model7 <- lmer(threatpotential~ cond_race*cond_pitch + (1|id), data = long)
# 
# anova(reduced_model7, max_model7)




## insert original model  into lmer_t() like so: 
sj4.reml.heur.t <- lmer_t(sj4.reml)


max_model1 <- lmer(threat ~ cond_race*cond_pitch + (cond_race+cond_pitch|id) + (cond_race+cond_pitch|voice), data = long)
mod1 <- buildmer(formula(max_model1),data=long,control=lmerControl(optimizer='bobyqa'))
f <- formula(mod1@model)
mod1 <- lmer(f, data = long)
tab <- lmer_t(fin_mod4)
summary(tab)


tab_model(tab)
primary_hyp1_intercepts <- lmer(threat ~ cond_race * cond_pitch + (1 | id) + (1 | voice), data = long)
r <- lmer_t(primary_hyp1_intercepts, method = "Kenward-Roger")

primary_hyp1_intercepts %>%  tab_model(file = here("figs", "summ_reg_table2.html"))
summary(r)
primary_hyp1_slopes <- lmer(threat ~ cond_race * cond_pitch + (cond_race + cond_pitch | id) + (cond_race + cond_pitch | voice), data = long)

primary_hyp1_test <- anova(primary_hyp1_intercepts, primary_hyp1_slopes, refit = F)




# plots -------------------------------------------------------------------


# theme_set(theme_bw(base_size = 12, base_family = ""))
# install.packages("pairwiseComparisons")
# ## https://ademos.people.uic.edu/Chapter16.html
# ## use ean
# 
# slope_voice <- long %>%
#   group_by(cond_race, cond_pitch, voice) %>%
#   summarise(mean_threat = mean(threat))
# 
# ggplot(data = slope_voice, aes(x = cond_race, y = mean_threat, group = cond_pitch)) +
#   facet_grid(~voice) +
#   geom_point(aes(colour = cond_pitch)) +
#   geom_smooth(method = "lm", se = TRUE, aes(colour = cond_pitch)) +
#   xlab("race condition") +
#   ylab("threat")
# 
# 
# qplot(cond_race, threat,
#   facets = cond_pitch ~ voice,
#   colour = voice, geom = "boxplot", data = long
# )
# 
# 
# qplot(cond_race, leadership,
#   facets = cond_pitch ~ voice,
#   colour = voice, geom = "boxplot", data = long
# )
# 
# 
# 
# ggplot(data = long, aes(x = cond_race, y = threat, group = voice)) +
#   facet_grid(~voice) +
#   geom_smooth(method = "lm", se = TRUE, aes(colour = voice)) +
#   xlab("condition") +
#   ylab("threat") +
#   theme(legend.position = "none")

# print.xtable(compare_table1, type = "html", file = here("figs", "compare_table1.html"), include.rownames = F, html.table.attributes = 'align="right", rules="rows", frame="below"')

# include_graphics(here("figs","compare_table1.png"))

###https://hlplab.wordpress.com/2010/06/15/r-code-for-latex-tables-of-lmer-model-effects/
### https://cran.r-project.org/web/packages/sjPlot/vignettes/tab_mixed.html
## https://www.r-bloggers.com/code-latex-tables-for-lme4-models/
### https://community.rstudio.com/t/knit-to-pdf-with-css-html-or-convert-html-file-to-pdf-file/24128/20
## https://stackoverflow.com/questions/62197268/knitting-output-from-sjplottab-model-or-other-html-tables-into-pdf-document
## https://wch.github.io/webshot/articles/intro.html


# assumptions -------------------------------------------------------------


