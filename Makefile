all: data/wide.csv data/long.csv

.PHONY: all clean help
.DELETE_ON_ERROR:
.SECONDARY:

help: Makefile
	@sed -n 's/^##//p' $<


## data/wide.csv: create wide dataset

data/wide.csv: source/00_load-raw-data-and-clean.R 
	Rscript $<
	
## data/long.csv: create long dataset

data/long.csv: source/00_load-raw-data-and-clean.R 
	Rscript $<

## data/vars-and-labels.csv: create file with variable labels and associated descriptions 

data/vars-and-labels.csv: source/00_load-raw-data-and-clean.R 
	Rscript $<

pilot/source/02_plots.R: pilot/data/clean.csv 
	
pilot/figs/%.png: pilot/source/02_plots.R
	Rscript $<

pilot/paper_sections/results.docx: pilot/paper_sections/results.Rmd pilot/data/clean.csv \
	pilot/source/01_preregistered-analyses.R pilot/source/03_exploratory-analyses.R \
	pilot/figs/%.png
	Rscript -e 'rmarkdown::render("$<")'


# paper 

paper/pilot.docx: paper/pilot.Rmd pilot/paper_sections/methods.docx pilot/paper_sections/results.docx
	Rscript -e 'rmarkdown::render("$<")'

paper/study1.docx: paper/study1.Rmd study1/paper_sections/methods.docx study1/paper_sections/results.docx
	Rscript -e 'rmarkdown::render("$<")'

paper/study2.docx: paper/study2.Rmd study2/paper_sections/methods.docx study2/paper_sections/results.docx
	Rscript -e 'rmarkdown::render("$<")'

paper/draft_paper.docx: paper/draft_paper.Rmd paper/pilot.docx paper/study1.docx \
	paper/study2.docx
	Rscript -e 'rmarkdown::render("$<")'

clean: 
	rm -f */long.csv */wide.csv */vars-and-labels.csv .Rhistory */.Rhistory
	
