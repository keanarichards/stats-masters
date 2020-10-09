# load packages -----------------------------------------------------------

## Package names
packages <- c("here", "tidyverse", "sjPlot", "sjmisc", "lme4", "sjlabelled", "papaja", "robustlmm", "memisc", "webshot", "gtsummary", "gt")

## Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

## Packages loading
invisible(lapply(packages, library, character.only = TRUE))

here <- here::here

## using summarySE function from here: http://www.cookbook-r.com/Manipulating_data/Summarizing_data/

summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,
                      conf.interval=.95, .drop=TRUE) {
  library(plyr)
  
  # New version of length which can handle NA's: if na.rm==T, don't count them
  length2 <- function (x, na.rm=FALSE) {
    if (na.rm) sum(!is.na(x))
    else       length(x)
  }
  
  # This does the summary. For each group's data frame, return a vector with
  # N, mean, and sd
  datac <- ddply(data, groupvars, .drop=.drop,
                 .fun = function(xx, col) {
                   c(N    = length2(xx[[col]], na.rm=na.rm),
                     mean = mean   (xx[[col]], na.rm=na.rm),
                     sd   = sd     (xx[[col]], na.rm=na.rm)
                   )
                 },
                 measurevar
  )
  
  # Rename the "mean" column    
  datac <- rename(datac, c("mean" = measurevar))
  
  datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean
  
  # Confidence interval multiplier for standard error
  # Calculate t-statistic for confidence interval: 
  # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
  ciMult <- qt(conf.interval/2 + .5, datac$N-1)
  datac$ci <- datac$se * ciMult
  
  return(datac)
}

## setting theme for assumptions plots: 

set_theme(base = theme_classic(base_size = 30))

# load data ---------------------------------------------------------------

source(here("source", "01_preregistered-analyses.R"))

# model 1 -----------------------------------------------------------------

## fixed effects

## create mean & ci threat rating for each combination of race & voice pitch

dat <- summarySE(long, "threat", c("cond_race", "cond_pitch"))

fixed_plot1 <- ggplot(data = dat, aes(x = cond_pitch, y = threat, 
                                      fill = cond_race)) +
  geom_bar(stat = "identity", position = "dodge") + 
  geom_errorbar(aes(ymin = threat - ci, ymax = threat + ci), width = .05,
                position = position_dodge(width = .9)) + theme_apa() + labs(x = "Voice pitch", y = "Perceived Threat")+ theme(panel.border  = element_blank()) +
  #draws x and y axis line
  theme(axis.line = element_line(color = 'black'))+ scale_fill_hue("Race")

ggsave(here("figs", "fixed_plot1.png"), fixed_plot1, width = 7, height = 7)

## assumptions 

asm1 <- plot_model(fin_mod1, type='diag')


for (i in 1:4) {
  ggpubr::ggexport(asm1[[i]],filename = here("figs", paste0("asm_mod1.", i,".png")),  width = 1300, height = 800)
}

## table with final model

fin_mod1 %>% tab_model(., file = here("figs", "final_table1.html"), p.val = "satterthwaite", show.df = T, dv.labels = "Perceived Threat")
webshot(here("figs", "final_table1.html"), here("figs", "final_table1.png"), selector = "table", zoom= 2)

## table with model comparison
tab_model(max_model1, fin_mod1, fin_mod1a, file = here("figs","compare_table1.html"), show.p = F, show.df = F, dv.labels = c("(1)", "(2)", "(3)"))
webshot(here("figs","compare_table1.html"), here("figs","compare_table1.png"), selector = "table", zoom= 2)

# model 2 -----------------------------------------------------------------

## fixed effects

dat1 <- summarySE(long, "leadership", c("cond_race", "cond_pitch"))

fixed_plot2 <- ggplot(data = dat1, aes(x = cond_pitch, y = leadership, 
                                       fill = cond_race)) +
  geom_bar(stat = "identity", position = "dodge") + 
  geom_errorbar(aes(ymin = leadership - ci, ymax = leadership + ci), width = .05,
                position = position_dodge(width = .9)) + theme_apa() + labs(x = "Voice pitch", y = "Perceived Leadership Ability")+ theme(panel.border  = element_blank()) +
  #draws x and y axis line
  theme(axis.line = element_line(color = 'black'))+ scale_fill_hue("Race")

ggsave(here("figs", "fixed_plot2.png"), fixed_plot2, width = 7, height = 7)

## assumptions 

asm2 <- plot_model(fin_mod2, type='diag')

for (i in 1:4) {
  ggpubr::ggexport(asm2[[i]],filename = here("figs", paste0("asm_mod2.", i,".png")),  width = 1300, height = 800)
}

## table with final model


fin_mod2 %>% tab_model(., file =  here("figs", "final_table2.html"), p.val = "satterthwaite", show.df = T, dv.labels = "Perceived Leadership Ability")
webshot(here("figs", "final_table2.html"), here("figs", "final_table2.png"), selector = "table", zoom= 2)


## table with model comparison 
tab_model(max_model2, fin_mod2, fin_mod2a, file = here("figs", "compare_table2.html"), show.p = F, show.df = F, dv.labels = c("(1)", "(2)", "(3)"))
webshot(here("figs", "compare_table2.html"), here("figs", "compare_table2.png"), selector = "table", zoom= 2)

# model 3 -----------------------------------------------------------------

## assumptions 

asm3 <- plot_model(fin_mod3, type='diag')

for (i in 1:4) {
  ggpubr::ggexport(asm1[[i]],filename = here("figs", paste0("asm_mod3.", i,".png")),  width = 1300, height = 800)
}


## table with final model

fin_mod3 %>% tab_model(., file = here("figs", "final_table3.html"),p.val = "satterthwaite", show.df = T, dv.labels = "Perceived Threat")
webshot(here("figs", "final_table3.html"), here("figs", "final_table3.png"), selector = "table", zoom= 2)

## table with model comparison 

tab_model(max_model3, fin_mod3, fin_mod3a, file = here("figs", "compare_table3.html"),show.p = F, show.df = F, dv.labels = c("(1)", "(2)", "(3)"))
webshot(here("figs", "compare_table3.html"), here("figs", "compare_table3.png"), selector = "table", zoom= 2)

# model 5 -----------------------------------------------------------------

## assumptions 

asm5 <- plot_model(fin_mod5, type='diag')

for (i in 1:4) {
  ggpubr::ggexport(asm1[[i]],filename = here("figs", paste0("asm_mod5.", i,".png")),  width = 1300, height = 800)
}


## table with final model

fin_mod5 %>% tab_model(., file =  here("figs", "final_table5.html"), p.val = "satterthwaite", show.df = T, dv.labels = "Perceived Trustworthiness")
webshot(here("figs", "final_table5.html"), here("figs", "final_table5.png"), selector = "table", zoom= 2)

## table with model comparison 


tab_model(max_model5, fin_mod5, fin_mod5a, file = here("figs", "compare_table5.html"), show.p = F, show.df = F, dv.labels = c("(1)", "(2)", "(3)"))
webshot(here("figs", "compare_table5.html"), here("figs", "compare_table5.png"), selector = "table", zoom= 2)

# model 6 -----------------------------------------------------------------

## assumptions 


asm6 <- plot_model(fin_mod6, type='diag')
for (i in 1:4) {
  ggpubr::ggexport(asm1[[i]],filename = here("figs", paste0("asm_mod6.", i,".png")),  width = 1300, height = 800)
}


## table with final model

fin_mod6 %>% tab_model(., file =  here("figs", "final_table6.html"), p.val = "satterthwaite", show.df = T, dv.labels = "Perceived Dominance")
webshot(here("figs", "final_table6.html"), here("figs", "final_table6.png"), selector = "table", zoom= 2)

## table with model comparison 

tab_model(max_model6, fin_mod6, fin_mod6a, file = here("figs", "compare_table6.html"), show.p = F, show.df = F, dv.labels = c("(1)", "(2)", "(3)"))
webshot(here("figs", "compare_table6.html"), here("figs", "compare_table6.png"), selector = "table", zoom= 2)


# model 7 -----------------------------------------------------------------

## assumptions 


asm7 <- plot_model(fin_mod7, type='diag')

for (i in 1:4) {
  ggpubr::ggexport(asm1[[i]],filename = here("figs", paste0("asm_mod7.", i,".png")),  width = 1300, height = 800)
}


## table with final model

fin_mod7 %>% tab_model(., file =  here("figs", "final_table7.html"), p.val = "satterthwaite", show.df = T, dv.labels = "Perceived Threat Potential")
webshot(here("figs", "final_table7.html"), here("figs", "final_table7.png"), selector = "table", zoom= 2)


## table with model comparison 


tab_model(max_model7, fin_mod7, fin_mod7a, file = here("figs", "compare_table7.html"), show.p = F, show.df = F, dv.labels = c("(1)", "(2)", "(3)"))
webshot(here("figs", "compare_table7.html"), here("figs", "compare_table7.png"), selector = "table", zoom= 2)


# table with MC ratings of likelihood of race based on name: ratings of likelihood that a person is black  ---------------


# load data ---------------------------------------------------------------

wide <- read_csv(here("data", "wide.csv"))

MC_ratingsb_tbl <- wide %>% dplyr::select(b_race_name_1:b_race_name_8) %>% 
  tbl_summary(label = list(b_race_name_1 ~ "Scott", b_race_name_2 ~ "Logan",
                           b_race_name_3 ~ "Brad", b_race_name_4 ~ "Brett", 
                           b_race_name_5 ~ "Deshawn", b_race_name_6 ~ "Tyrone",
                           b_race_name_7 ~ "Keyshawn",b_race_name_8 ~ "Terrell")) %>% modify_header(update = list(label ~ "**Name**", stat_0 ~ "**Rating**"))

gt_tbl <- as_gt(MC_ratingsb_tbl) %>%
  tab_style(
    style = cell_borders(
      sides = c("top", "bottom"),
      color = "white",
      style = "solid"
    ),
    locations = cells_body(columns = everything(), rows = everything())
  ) %>%
  tab_header(title = md("")) %>%
  opt_align_table_header(align = "left")
gt::gtsave(gt_tbl, file = here("figs", "MC_ratingsb_tbl.png"))


# table with MC ratings of likelihood of race based on name: ratings of likelihood that a person is white  ---------------

MC_ratingsw_tbl <- wide %>% dplyr::select(w_race_name_1:w_race_name_8) %>% 
  tbl_summary(label = list(w_race_name_1 ~ "Scott", w_race_name_2 ~ "Logan",
                           w_race_name_3 ~ "Brad", w_race_name_4 ~ "Brett", 
                           w_race_name_5 ~ "Deshawn", w_race_name_6 ~ "Tyrone",
                           w_race_name_7 ~ "Keyshawn",w_race_name_8 ~ "Terrell")) %>% modify_header(update = list(label ~ "**Name**", stat_0 ~ "**Rating**"))

gt_tbl <- as_gt(MC_ratingsw_tbl) %>%
  tab_style(
    style = cell_borders(
      sides = c("top", "bottom"),
      color = "white",
      style = "solid"
    ),
    locations = cells_body(columns = everything(), rows = everything())
  ) %>%
  tab_header(title = md("")) %>%
  opt_align_table_header(align = "left")
gt::gtsave(gt_tbl, file = here("figs", "MC_ratingsw_tbl.png"))


