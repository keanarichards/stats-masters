
# Statistics Master's Thesis

Keana Richards 

--- 

Note: words that are italicized below represent code   

## Setting up: 


First must run the add .here file to directory. 
Then, you must load the "here" package so the source files will run properly, see more on why the "here" package is a good idea [here](http://jenrichmond.rbind.io/post/how-to-use-the-here-package/), [here](https://github.com/jennybc/here_here), and [here](https://malco.io/2018/11/05/why-should-i-use-the-here-package-when-i-m-already-using-projects/)!
After loading the package, run the following in the console before starting the project:
*set_here()*, which will ensure that the gender practice project is the root directory for all associated code. To check that this worked, go to the folder that has the gender-practice.Rproj and make sure that there is a .here file in the same folder as the .Rproj file.  

 
There are two options for replicating the results and compiling the full paper after forking this project (note: for both of these options, this process will likely take several hours the first time the code is run - after which the most computationally intensive code chunks will be cached, so the code will take far less time after running thereafter): 

1) To automate the compilation process using the Knitr, first run the "00_load-raw-data-and-clean.R" file in the "source" directory. Then, you can go to the "full_paper.Rmd" document within the "paper" directory. Open this file and knit the document (Ctrl+Shift+K on	Windows & Linux or Command+Shift+K on macOS). 

2) To automate the compilation process using the Makefile in the main directory, you will need to have GNU Make downloaded, which can be used to run the Makefile that compiles the whole project (or parts of the project as needed). See [Jenny Bryan's incredible course, with one of the more comprehensible explanations of Makefiles I could find](https://stat545.com/automation-overview.html) for more details on makefiles and to find more resources on using makefiles. One of the benefits of this option is that certain parts of the analyses can be replicated without needing to re-compile all of the documents at once.  

I also recommend reading the section on Makefiles from "Reproducible Research with R and RStudio" from Christopher Gandrud for a beginner-friendly explanation of what they do and some basic syntax. 

Once GNU Make is downloaded, check that it will be used to compile the product by going to the 'Build' >> 'Configure Build Tools' at the top of the screen in RStudio. Under the dropdown for Project build tools, click 'Makefile' and make sure that the "Makefile directory" is set to "(Project Root)." If there are any issues with this, try the link above to learn more about GNU Make or the various resources on that page. 

Running the makefile using *make all* in the RStudio Terminal will re-run all code from start to finish to produce the final product. If the terminal is not preferable, another option to compile the final product is to click "Build" at the top of RStudio and run "Build all."

To run specific parts of the analyses, enter *make help* into the terminal, which will list commands and their respective output for some of the major parts of the analyses (e.g., results documents, methods documents) 

## Logistics:

All variables names and descriptions can be found in the files called "vars-and-labels" in respective (e.g., pilot, study 1, or study 2) data directory

Excluded participants for each study can be found in data - "excluded.csv" files in respective (e.g., either pilot, study 1, or study 2) data directory 

## Coding scheme:

Reference categories: 

Gender = men <br><br>
Competition choice = piece-rate 

