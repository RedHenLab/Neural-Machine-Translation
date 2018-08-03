#!/bin/bash

src=$1
tgt=$2
lang=$1-$2
script=../../Neural-Machine-Translation/scripts/

python $script/strip.py train.$lang.$src train.$lang.$tgt
perl $script/lowercase.perl < train.$lang.$src.cleaned > train.$lang.$src.cleaned.low
perl $script/lowercase.perl < train.$lang.$tgt.cleaned > train.$lang.$tgt.cleaned.low
perl $script/tokenizer.perl -l $src < train.$lang.$src.cleaned.low > train.$lang.$src.cleaned.low.tok
perl $script/tokenizer.perl -l $tgt < train.$lang.$tgt.cleaned.low > train.$lang.$tgt.cleaned.low.tok
cat train.$lang.$src.cleaned.low.tok train.$lang.$tgt.cleaned.low.tok | ~/Neural-Machine-Translation/subword-nmt/learn_bpe.py -s 32000 > ~/Neural-Machine-Translation/subword-nmt/$lang/bpe.32000
~/Neural-Machine-Translation/subword-nmt/apply_bpe.py -c ~/Neural-Machine-Translation/subword-nmt/$lang/bpe.32000 < train.$lang.$src.cleaned.low.tok > train.$lang.$src.cleaned.low.tok.bpe
~/Neural-Machine-Translation/subword-nmt/apply_bpe.py -c ~/Neural-Machine-Translation/subword-nmt/$lang/bpe.32000 < train.$lang.$tgt.cleaned.low.tok > train.$lang.$tgt.cleaned.low.tok.bpe
mv train.$lang.$src.cleaned.low.tok.bpe train.$lang.$src.processed
mv train.$lang.$tgt.cleaned.low.tok.bpe train.$lang.$tgt.processed


python $script/strip.py valid.$lang.$src valid.$lang.$tgt
perl $script/lowercase.perl < valid.$lang.$src.cleaned > valid.$lang.$src.cleaned.low
perl $script/lowercase.perl < valid.$lang.$tgt.cleaned > valid.$lang.$tgt.cleaned.low
perl $script/tokenizer.perl -l $src < valid.$lang.$src.cleaned.low > valid.$lang.$src.cleaned.low.tok
perl $script/tokenizer.perl -l $tgt < valid.$lang.$tgt.cleaned.low > valid.$lang.$tgt.cleaned.low.tok
~/Neural-Machine-Translation/subword-nmt/apply_bpe.py -c ~/Neural-Machine-Translation/subword-nmt/$lang/bpe.32000 < valid.$lang.$src.cleaned.low.tok > valid.$lang.$src.cleaned.low.tok.bpe
~/Neural-Machine-Translation/subword-nmt/apply_bpe.py -c ~/Neural-Machine-Translation/subword-nmt/$lang/bpe.32000 < valid.$lang.$tgt.cleaned.low.tok > valid.$lang.$tgt.cleaned.low.tok.bpe
mv valid.$lang.$src.cleaned.low.tok.bpe valid.$lang.$src.processed
mv valid.$lang.$tgt.cleaned.low.tok.bpe valid.$lang.$tgt.processed


python $script/strip.py test.$lang.$src test.$lang.$tgt
perl $script/lowercase.perl < test.$lang.$src.cleaned > test.$lang.$src.cleaned.low
perl $script/lowercase.perl < test.$lang.$tgt.cleaned > test.$lang.$tgt.cleaned.low
perl $script/tokenizer.perl -l $src < test.$lang.$src.cleaned.low > test.$lang.$src.cleaned.low.tok
perl $script/tokenizer.perl -l $tgt < test.$lang.$tgt.cleaned.low > test.$lang.$tgt.cleaned.low.tok
~/Neural-Machine-Translation/subword-nmt/apply_bpe.py -c ~/Neural-Machine-Translation/subword-nmt/$lang/bpe.32000 < test.$lang.$src.cleaned.low.tok > test.$lang.$src.cleaned.low.tok.bpe
~/Neural-Machine-Translation/subword-nmt/apply_bpe.py -c ~/Neural-Machine-Translation/subword-nmt/$lang/bpe.32000 < test.$lang.$tgt.cleaned.low.tok > test.$lang.$tgt.cleaned.low.tok.bpe
mv test.$lang.$src.cleaned.low.tok.bpe test.$lang.$src.processed
mv test.$lang.$tgt.cleaned.low.tok.bpe test.$lang.$tgt.processed

rm *tok
rm *cleaned
rm *low

