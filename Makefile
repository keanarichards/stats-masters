all: paper/full_paper.pdf

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

## figs/%.png: create all figures associated with paper, as .png files  

figs/%.png: source/02_plots.R data/wide.csv data/long.csv
	Rscript $<

# paper 

paper/00_intro.pdf: paper/00_intro.Rmd 
	Rscript -e 'rmarkdown::render("$<")'

paper/01_methods.pdf: paper/01_methods.Rmd data/wide.csv data/long.csv
	Rscript -e 'rmarkdown::render("$<")'

paper/02_results.pdf: paper/02_results.Rmd data/wide.csv data/long.csv figs/%.png
	Rscript -e 'rmarkdown::render("$<")'

paper/03_discussion.pdf: paper/03_discussion.Rmd
	Rscript -e 'rmarkdown::render("$<")'

paper/04_appendix.pdf: paper/04_appendix.Rmd figs/%.png
	Rscript -e 'rmarkdown::render("$<")'

paper/full_paper.pdf: paper/full_paper.Rmd data/wide.csv data/long.csv figs/%.png paper/00_intro.Rmd \
paper/01_methods.Rmd paper/02_results.Rmd paper/03_discussion.Rmd paper/04_appendix.Rmd
	Rscript -e 'rmarkdown::render("$<")'

clean: 
	rm -f */long.csv */wide.csv */vars-and-labels.csv .Rhistory */.Rhistory \
	*/*.html */*.pdf */*.tex */*.out */*.aux */*.png
