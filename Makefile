GHC = ghc

TEXFILES = DeBruijn.tex HOAS.tex IdInt.tex Lambda.tex Main.tex Simple.tex Unique.tex

.SUFFIXES: .lhs .tex

.lhs.tex:
	awk -f bird2code.awk $< > $*.tex

LC:	*.lhs
#	$(GHC) -package mtl -O2 -Wall --make Main.lhs -o LC
	stack build --copy-bins --local-bin-path .

top.pdf: top.tex $(TEXFILES)
	pdflatex top.tex && pdflatex top.tex

.PHONY: timing
timing:	LC
	time ./LC S < timing.lam
	time ./LC U < timing.lam
	time ./LC H < timing.lam
	time ./LC D < timing.lam
	time ./LC C < timing.lam

.PHONY:	clean
clean:
	rm -f *.hi *.o LC top.pdf top.log top.aux $(TEXFILES)
