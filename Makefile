.DEFAULT_GOAL := nouns


# nouns
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

nouns:test.clean


# adjectives
adjectives.generator.hfst: adjectives.lexd
	lexd $< | hfst-txt2fst -o $@
adjectives.analyzer.hfst: adjectives.generator.hfst
	hfst-invert $< -o $@
adjectives: adjectives.analyzer.hfst


# adverbs
adverbs.generator.hfst: adverbs.lexd
	lexd $< | hfst-txt2fst -o $@
adverbs.analyzer.hfst: adverbs.generator.hfst
	hfst-invert $< -o $@
adverbs: adverbs.analyzer.hfst


clean:
	rm *.hfst

