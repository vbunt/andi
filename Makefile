.DEFAULT_GOAL := andi.analyzer.hfstol

# 
ani.lexd: $(wildcard ani_*.lexd)
	cat ani_*.lexd > ani.lexd

ani.twol.hfst: ani.twol
	hfst-twolc $< -o $@

# to get rid of { } for twol. not used here but does exist
brackets.twol.hfst: brackets.twol
	hfst-twolc $< -o $@

# for letter variants: я/йа, лІ/лълъ, І/1/I/i
var.transliterator.hfst: variants
	hfst-strings2fst -j variants -o var.hfst
	hfst-repeat -f 1 var.hfst -o var.transliterator.hfst
	rm var.hfst

# generate generator
andi.generator.hfst: ani.lexd ani.twol.hfst var.transliterator.hfst
	lexd $< | hfst-txt2fst -o andi_.generator.hfst
	hfst-compose-intersect andi_.generator.hfst ani.twol.hfst -o andi__.generator.hfst
	hfst-compose andi__.generator.hfst var.transliterator.hfst -o $@
	rm andi__.generator.hfst
	rm andi_.generator.hfst
	rm ani.twol.hfst
	rm var.transliterator.hfst

# test generator
test.pass.txt: tests.csv
	awk -F, '$$3 == "pass" {print $$1 ":" $$2}' $^ | sort -u > $@
check: andi.generator.hfst test.pass.txt
	bash compare.sh $< test.pass.txt

# generate analizer
andi.analyzer.hfst: check
	rm test.*
	hfst-invert andi.generator.hfst -o $@

andi.analyzer.hfstol: andi.analyzer.hfst
	hfst-fst2fst -O -i $< -o $@

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


