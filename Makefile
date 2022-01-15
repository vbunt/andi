.DEFAULT_GOAL := numbers.analyzer.hfst

# generate analizer and generator
numbers.analyzer.hfst: numbers.generator.hfst
	hfst-invert $< -o $@

numbers.generator.hfst: numbers.lexd
	lexd $< | hfst-txt2fst -o $@

# remove all hfst files
clean:
	rm *.hfst