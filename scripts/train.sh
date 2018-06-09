#!/bin/bash
#SBATCH -N 1
#SBATCH -c 12
#SBATCH --mem-per-cpu=2G
#SBATCH -p gpu -C gpuk40 --gres=gpu:1
#SBATCH --time=10-00:30:00
#SBATCH --mail-type=ALL
#SBATCH --output=slurm-train.out
#SBATCH --job-name="nmt-train"

if [[ $# != 2 ]] ; then
    echo 'Error, command should be: <sbatch train.sh src-lang-code tgt-lang-code>'
    exit 1
fi

src=$1
tgt=$2
lang=${1}-${2}

export HOME=$(pwd)/../..
export DATA=$HOME/data
export DATA_PREP=$DATA/$lang
export MODELS=$HOME/models/$lang
export SCRIPT=$HOME/Neural-Machine-Translation/scripts

if [ ! -d "$HOME/models" ]; then
	mkdir $HOME/models
fi

module load singularity/2.5.1
cd $HOME/singularity
singularity shell -w --nv rh_xenial_20180308.img

cd $SCRIPT
source $HOME/myenv/bin/activate

##Creates data in a format required by train.py
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

##Train a model(might take days for training)
python $HOME/Neural-Machine-Translation/train.py -data $DATA_PREP/processed_all-train.pt -layers 4 -word_vec_size 512 -brnn -batch_size 128 -dropout 0.3 -save_dir $MODELS -start_reinforce 15 -critic_pretrain_epochs 4 -end_epoch 25
