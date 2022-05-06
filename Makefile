.DEFAULT_GOAL := clean_some


nouns.generator.hfst: nouns.lexd
	lexd $< | hfst-txt2fst -o $@

adjectives.generator.hfst: adjectives.lexd
	lexd $< | hfst-txt2fst -o $@

adverbs.generator.hfst: adverbs.lexd
	lexd $< | hfst-txt2fst -o $@

numbers.generator.hfst: numbers.lexd
	lexd $< | hfst-txt2fst -o $@


# тут их наверное как-то можно все сразу в один слепить
# но я не настолько разобралась в командах для терминала :/
nouns_and_adjectives.generator.hfst: nouns.generator.hfst adjectives.generator.hfst
	hfst-disjunct $^ -o $@

numbers_and_adverbs.generator.hfst: numbers.generator.hfst adverbs.generator.hfst
	hfst-disjunct $^ -o $@

andi.generator.hfst: nouns_and_adjectives.generator.hfst numbers_and_adverbs.generator.hfst
	hfst-disjunct $^ -o $@

# andi.analyzer.hfst: andi.generator.hfst
# 	hfst-invert $< -o $@


# la2cy.transliterater.hfst: cy2la.transliterater.hfst # для анализа
# 	hfst-invert $< -o $@
cy2la.transliterater.hfst: correspondence.hfst # для генерации
	hfst-repeat -f 1 $< -o $@
correspondence.hfst: correspondence
	hfst-strings2fst -j correspondence -o $@

andi.analyzer.tr.hfst: andi.generator.tr.hfst
	hfst-invert $< -o $@
andi.generator.tr.hfst: andi.generator.hfst cy2la.transliterater.hfst
	hfst-compose $^ -o $@

test.pass.txt: tests.csv
	awk -F, '$$3 == "pass" {print $$1 ":" $$2}' $^ | sort -u > $@
check: andi.generator.hfst test.pass.txt
	bash compare.sh $< test.pass.txt


clean_some:  check
	rm *[!i].*.hfst
	rm test.*

clean:
	rm *.hfst


