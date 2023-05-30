analyser=andi.analyzer.hfstol
guesser=andi.guesser.hfst
.PHONY: check-coverage

check-coverage-stats: corpus $(analyser) stats
	@ cd corpus; find * -name "*.txt" -print0 | xargs -0 ../stats ../$(analyser)

check-unrecog: corpus $(analyser) unrecog
	@ find corpus -name "*.txt" -print0 | xargs -0 ./unrecog $(analyser) > unrecog.txt
	@ find corpus -name "andi-fox-fit.txt" -print0 | xargs -0 ./unrecog $(analyser) > unrecog-fox.txt
	@ find corpus -name "andi-bible-fit.txt" -print0 | xargs -0 ./unrecog $(analyser) > unrecog-bible.txt
	@ find corpus -name "andi-tales-fit.txt" -print0 | xargs -0 ./unrecog $(analyser) > unrecog-tales.txt

check-recog: corpus $(analyser) recog
	@ find corpus -name "*.txt" -print0 | xargs -0 ./recog $(analyser) > recog.txt
	@ find corpus -name "andi-fox-fit.txt" -print0 | xargs -0 ./recog $(analyser) > recog-fox.txt
	@ find corpus -name "andi-bible-fit.txt" -print0 | xargs -0 ./recog $(analyser) > recog-bible.txt
	@ find corpus -name "andi-tales-fit.txt" -print0 | xargs -0 ./recog $(analyser) > recog-tales.txt

check-guesser-stats: corpus $(guesser) guesser_stats
	@ find corpus -name "*.txt" -print0 | xargs -0 ./recog $(guesser) > guessed.txt

check-coverage: corpus $(analyser) stats unrecog
	@ echo aggregate coverage:
	@ (make -s check-coverage-stats; find corpus -name "*.txt" -exec cat {} \; | ./stats -q $(analyser) -) | column -t
	@ echo
	@ echo unrecognised words:
	@ make -s check-coverage-unrecog | tail -n20


%.hfstol: %.hfst
	echo '?::0' | hfst-regexp2fst | hfst-repeat | hfst-compose -F $< - | hfst-minimise -E | hfst-fst2fst -w -o $@

clean:
	rm *.txt