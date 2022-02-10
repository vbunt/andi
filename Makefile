.DEFAULT_GOAL := numbers.analyzer.hfst

# generate generators for all dialects
numbers_gagatli.generator.hfst: numbers_gagatli.lexd
	lexd $< | hfst-txt2fst -o $@

numbers_zilo.generator.hfst: numbers_zilo.lexd
	lexd $< | hfst-txt2fst -o $@

numbers_rikvani.generator.hfst: numbers_rikvani.lexd
	lexd $< | hfst-txt2fst -o $@

# compose generators into one

numbers.generator.hfst: numbers_gz.generator.hfst numbers_rikvani.generator.hfst
	hfst-disjunct $^ -o $@

numbers_gz.generator.hfst: numbers_gagatli.generator.hfst numbers_zilo.generator.hfst
	hfst-disjunct $^ -o $@

# generate analizer
numbers.analyzer.hfst: numbers.generator.hfst
	hfst-invert $< -o $@

# generate transliteraters
la2cy.transliterater.hfst: cy2la.transliterater.hfst
	hfst-invert $< -o $@
cy2la.transliterater.hfst: correspondence.hfst
	hfst-repeat -f 1 $< -o $@
correspondence.hfst: correspondence
	hfst-strings2fst -j correspondence -o $@

# generate analizer and generator for transcription
numbers.analyzer.tr.hfst: numbers.generator.tr.hfst
	hfst-invert $< -o $@
numbers.generator.tr.hfst: numbers.generator.hfst cy2la.transliterater.hfst
	hfst-compose $^ -o $@

# remove all hfst files
clean:
	rm *.hfst