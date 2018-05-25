src=$1
tgt=$2
lang=${1}-${2}

export DATA_PREP=$DATA/$lang

python ../preprocess.py \
  -train_src $DATA_PREP/train.$lang.$src.processed \
  -train_tgt $DATA_PREP/train.$lang.$tgt.processed \
  -train_xe_src $DATA_PREP/train.$lang.$src.processed \
  -train_xe_tgt $DATA_PREP/train.$lang.$tgt.processed \
  -train_pg_src $DATA_PREP/train.$lang.$src.processed \
  -train_pg_tgt $DATA_PREP/train.$lang.$tgt.processed \
  -valid_src $DATA_PREP/valid.$lang.$src.processed \
  -valid_tgt $DATA_PREP/valid.$lang.$tgt.processed \
  -test_src $DATA_PREP/test.$lang.$src.processed \
  -test_tgt $DATA_PREP/test.$lang.$tgt.processed \
  -save_data $DATA_PREP/processed_all
