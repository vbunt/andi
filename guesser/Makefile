# clean all .hfst files
clean:
	rm *.hfst
	rm ani.guess.lexd

ani.guess.lexd: guess.verbs.lexd guess.nouns.lexd guess.misc.lexd guess.verbs.lexicon.lexd guess.nouns.lexicon.lexd
	cat $^ > ani.guess.lexd

ani.twol.hfst: ani.twol
	hfst-twolc $< -o $@

andi.guess.hfst: ani.guess.lexd
	lexd $< | hfst-txt2fst -o $@

andi.guesser.hfst: andi.guess.hfst ani.twol.hfst
	hfst-compose-intersect $^ | hfst-invert -o guess.analyzer.hfst

	hfst-summarize -v guess.analyzer.hfst \
	| grep -A1 'sigma set:' \
	| tail -1 \
	| sed 's/, /\n/g' \
	| grep -E '<Type.+>'\
	| sed 's/<Type\(.\+\)>/&\t[GUESS_CATEGORY=\1]/'\
	| hfst-substitute -F - -o target.subst.hfst guess.analyzer.hfst
	hfst-guessify -v  target.subst.hfst > andi.guesser.hfst
#	hfst-fst2fst -O -i andi.guesser.hfst -o andi.guesser.hfstol
	rm target.subst.hfst
	rm guess.analyzer.hfst
	rm andi.guess.hfst

