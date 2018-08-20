GHC = ghc

TEXFILES = DeBruijn.tex HOAS.tex IdInt.tex Lambda.tex Main.tex Simple.tex Unique.tex

.SUFFIXES: .lhs .tex

.lhs.tex:
	awk -f bird2code.awk $< > $*.tex

# Tested with GHC 8.4.3.
LC:	*.lhs
	$(GHC) -O2 -Wall Main.lhs -o LC

LC-stack: *.lhs
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
