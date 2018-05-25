src=$1
tgt=$2
lang=${1}-${2}

export DATA_PREP=$DATA/$lang

python ../preprocess.py \
  -train_src $DATA_PREP/train.$lang.$src \
  -train_tgt $DATA_PREP/train.$lang.$tgt \
  -train_xe_src $DATA_PREP/train.$lang.$src \
  -train_xe_tgt $DATA_PREP/train.$lang.$tgt \
  -train_pg_src $DATA_PREP/train.$lang.$src \
  -train_pg_tgt $DATA_PREP/train.$lang.$tgt \
  -valid_src $DATA_PREP/valid.$lang.$src \
  -valid_tgt $DATA_PREP/valid.$lang.$tgt \
  -test_src $DATA_PREP/test.$lang.$src \
  -test_tgt $DATA_PREP/test.$lang.$tgt \
  -save_data $DATA_PREP/processed_all
