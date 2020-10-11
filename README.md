
# Reproducing the results:

Before attempting to reproduce any of these results after forking this
project, you will need to install and load the `here` package so the
source files will run properly, see more on why the `here` package is a
good idea
[here](http://jenrichmond.rbind.io/post/how-to-use-the-here-package/),
[here](https://github.com/jennybc/here_here), and
[here](https://malco.io/2018/11/05/why-should-i-use-the-here-package-when-i-m-already-using-projects/)\!

After loading the package, open the `stats-masters.Rproj` in Rstudio and
run the following in the console:

`set_here()`

This will ensure that the stats-masters project is the root directory
for all associated code. To check that this worked, go to the
“stats-masters” folder that has the `stats-masters.Rproj` and make
sure that there is a .here file in the same folder as the .Rproj file.

There are a few options for reproducing the results found in this thesis
(note: you want to recreate the entire paper, you will need to install
the papaja and tinytex packages in advance - see
[here](https://github.com/crsh/papaja) for more information on how to
install this and its dependencies):

1)  First, if you are solely interested in reproducing the analyses
    themselves, you can go to the “source” subdirectory and run any of
    those files directly. Note, they are not dependent on each other, so
    you do not need to run the code to load the raw data and clean it
    (unless you deleted the cleaned versions of the files in the data
    directory).

2)  To automate the compilation process using the Knitr, you can go to
    the “full\_paper.Rmd” document within the “paper” directory. Open
    this file and knit the document (Ctrl+Shift+K on Windows & Linux or
    Command+Shift+K on macOS).

3)  To automate the compilation process using the Makefile in the main
    directory, you will need to have GNU Make downloaded, which can be
    used to run the Makefile that compiles the whole project (or parts
    of the project as needed). See [Jenny Bryan’s incredible course,
    with one of the more comprehensible explanations of Makefiles I
    could find](https://stat545.com/automation-overview.html) for more
    details on makefiles and to find more resources on using makefiles.
    One of the benefits of this option is that certain parts of the
    analyses can be replicated without needing to re-compile all of the
    documents at once.

I also recommend reading the section on Makefiles from “Reproducible
Research with R and RStudio” from Christopher Gandrud for a
beginner-friendly explanation of what they do and some basic syntax.

Once GNU Make is downloaded, check that it will be used to compile the
product by going to the ‘Build’ \>\> ‘Configure Build Tools’ at the top
of the screen in RStudio. Under the dropdown for Project build tools,
click ‘Makefile’ and make sure that the “Makefile directory” is set to
“(Project Root).” If there are any issues with this, try the link
above to learn more about GNU Make or the various resources on that
page.

Running the makefile using *make all* in the RStudio Terminal will
re-run all code from start to finish to produce the final product. If
the terminal is not preferable, another option to compile the final
product is to click “Build” at the top of RStudio and run “Build all.”

To run specific parts of the analyses, enter *make help* into the
terminal, which will list commands and their respective output for some
of the major parts of the analyses (e.g., results documents, methods
documents)

# Logistics:

  - All variables names and descriptions can be found in the files
    called “vars-and-labels” in the data directory

  - Running the main analyses in the 01\_preregistered-analyses.R file
    will likely take several hours the first time the code is run
    (unless you comment out the rlmer analyses). However, if you knit
    the entire folder when you run this code, it will take less time the
    next time you knit the document because the most computationally
    intensive code chunks will be cached, so the code will take far less
    time after running thereafter,

  - You can find the pre-registration, original survey questions, and
    the stimuli of this project [here](https://osf.io/r8m2u/)

  - the voice\_manipulations.csv contains the summary statistics on the
    voice manipulations from Praat

Session info for my version of the paper:

    ## R version 3.6.3 (2020-02-29)
    ## Platform: x86_64-w64-mingw32/x64 (64-bit)
    ## Running under: Windows 10 x64 (build 18362)
    ## 
    ## Matrix products: default
    ## 
    ## locale:
    ## [1] LC_COLLATE=Spanish_Mexico.1252  LC_CTYPE=Spanish_Mexico.1252   
    ## [3] LC_MONETARY=Spanish_Mexico.1252 LC_NUMERIC=C                   
    ## [5] LC_TIME=Spanish_Mexico.1252    
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] compiler_3.6.3  magrittr_1.5    tools_3.6.3     htmltools_0.5.0
    ##  [5] yaml_2.2.1      stringi_1.4.6   rmarkdown_2.3   knitr_1.30     
    ##  [9] stringr_1.4.0   xfun_0.15       digest_0.6.25   rlang_0.4.7    
    ## [13] evaluate_0.14
