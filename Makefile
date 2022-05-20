.DEFAULT_GOAL := andi.analyzer.hfst

# generate generator
andi.generator.hfst: andi.lexd
	lexd $< | hfst-txt2fst -o $@

# test generator
test.pass.txt: tests.csv
	awk -F, '$$3 == "pass" {print $$1 ":" $$2}' $^ | sort -u > $@
check: andi.generator.hfst test.pass.txt
	bash compare.sh $< test.pass.txt

# genearte analizer
andi.analyzer.hfst: check
	rm test.*
	hfst-invert andi.generator.hfst -o $@

# generate transliterator
cy2la.transliterator.hfst: correspondence.hfst # для генерации
	hfst-repeat -f 1 $< -o $@
correspondence.hfst: correspondence
	hfst-strings2fst -j correspondence -o $@

# combine analyzer and generator with transliteration
andi.analyzer.tr.hfst: andi.generator.tr.hfst
	hfst-invert $< -o $@
andi.generator.tr.hfst: andi.generator.hfst cy2la.transliterator.hfst
	hfst-compose $^ -o $@
	rm correspondence.hfst
	rm cy2la.transliterator.hfst

# clean all .hfst files
clean:
	rm *.hfst


