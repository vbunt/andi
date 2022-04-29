.DEFAULT_GOAL := test.clean

nouns.generator.hfst: nouns.lexd
	lexd $< | hfst-txt2fst -o $@

nouns.analyzer.hfst: nouns.generator.hfst
	hfst-invert $< -o $@

test.pass.txt: tests.csv
	awk -F, '$$3 == "pass" {print $$1 ":" $$2}' $^ | sort -u > $@
check: nouns.generator.hfst test.pass.txt
	bash compare.sh $< test.pass.txt

test.clean: check
	rm test.*

clean:
	rm *.hfst

