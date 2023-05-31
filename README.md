# Andi Morphology

## Background
[Andi](https://en.wikipedia.org/wiki/Andi_language) is an endangered language from the Nakh-Daghestanian family.
This repository contains a prototype for a Andi morphological analyzer. It is a part of a larger project by the students of the [School of Linguistics](https://ling.hse.ru/en/) at the NRU HSE that aims to provide digital tools for endangered languages. See the [thesis](https://drive.google.com/file/d/11wgWTGjU7Xqrpsw3RshvA8KHPopdnqRG/view?usp=sharing) for a detailed description.

You can cite the thesis using the form below:
- Buntiakova, V. (2023). *Morphological Parser of Andi in lexd and twol* \[Unpublished Bachelor's thesis]. NRU HSE.

The project is distributed under the [GNU General Public License v3.0](https://github.com/vbunt/andi/blob/master/LICENSE).

## Sources

### Grammar

The current work is based on the linguistic description of Andi by Kaye et al. (2023) and Salimov (2010) and the Andi dictionary by Kibrik and Kodzasov (1988; 1990). The digitized version of the dictionary is available at https://github.com/vbunt/andi-dicts.

### Texts

I used "Tales of the world in Andi" by Alisultanova, the Gospel of Luke in Andi and a short story "A fox, a tit and a quail" from Salimov's (2010) grammar.

The texts can be found in the [corpora directory](https://github.com/vbunt/andi/tree/master/coverage/corpus). They have been lemmatized and strippted of punctuation.

## Usage

To use or extend the analyzer, pull the repository and use the makefile commands described below.

[lexd](https://github.com/apertium/lexd) and [hfst](https://github.com/hfst/hfst) are required to build the project. You can get them by adding Apertium to your apt repositories.
```bash
curl -sS https://apertium.projectjj.com/apt/install-nightly.sh | sudo bash
apt install lexd
apt install hfst
```

### Making the analyzer

```bash
make andi.analyser.hfst
```

### Running the analyzer

Analyse a token:
```bash
echo 'бекІулидду' | hfst-lookup and.noun.analyzer.hfst
```

View statistics:

```bash
make andi.analyzer.hfstol
mv andi.analyzer.hfstol ~/coverage
cd coverage
make check-coverage
```

Current performance: Naive Coverage ~44%

### Making the guesser
```bash
cd guesser
make andi.guesser.hfst
```

### Running the guesser
For coverage and accuracy, see [this](https://github.com/vbunt/andi/blob/master/guesser/guesser_coverage.ipynb) notebook and [this](https://github.com/vbunt/andi/blob/master/guesser/guesser_accuracy.ipynb) notebook.

To guess a token:
```bash
echo "бекІулидду" | hfst-guess andi.guesser.hfst
```

