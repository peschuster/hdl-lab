PS_FILES	:= $(wildcard ./figs/*.ps)
EPS_FILES	:= $(patsubst %.ps, %.eps, $(PS_FILES))
FIGURES		:= $(patsubst %.eps, %.pdf, $(EPS_FILES)) 

figs:				$(FIGURES)
figse:				$(EPS_FILES)
#exercises:			$(EXERCISES)

all: hdl_lab_manual.pdf

manual.pdf	: manual.tex
	pdflatex $<
	pdflatex $<
	make nice
	
.SECONDARY:

./figs/%.eps	: ./figs/%.ps
	gs -sDEVICE=epswrite -dEPSCrop -o $@ $^

./figs/%.pdf	: ./figs/%.eps
	epstopdf $^

.PHONY: nice clean figs

clean: nice
	rm -fr *.pdf

nice:
	rm -f *.aux *.log *.ps *.eps *.dvi *.out
