#!/bin/bash
#SBATCH -A research
#SBATCH -n 30
#SBATCH --gres=gpu:1
#SBATCH --mem-per-cpu=2048
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=END
module load cuda/8.0
module load cudnn/7-cuda-8.0
source ../../myenv/bin/activate
export BANDIT_HOME=~/translation
export DATA=$BANDIT_HOME/data
export SCRIPT=$BANDIT_HOME/scripts
#mkdir -p /scratch/$USER
#bash make_data.sh hi en
#bash pretrain.sh en-hi ../models
#python ../train.py -data ../data/en-hi/processed_all-train.pt -load_from ../models/model_20_reinforce.pt -save_dir ../results -start_reinforce -1 -end_epoch 30 -critic_pretrain_epochs 2 -pert_func bin -pert_param 1
#***Current Benchmark set***#
python ../translate.py -train_data ../data/en-hi/processed_all-train.pt -load_from model_9.pt -test_src test.en-hi.hi
#python ../train.py -data ../data/en-hi/processed_all-train.pt -layers 4 -word_vec_size 1024 -brnn -batch_size 32 -dropout 0.2 -save_dir /scratch/$USER/models -start_reinforce 20 -critic_pretrain_epochs 4 -end_epoch 40 
#python ../train.py -data ../data/en-hi/processed_all-train.pt -load_from /scratch/$USER/models/model_40_reinforce.pt -eval -save_dir ../rescue
#rsync -aP /scratch/$USER/models/model_40* ada:/share1/$USER/hi-en_models
#rm -rf /scratch/$USER

