#!/bin/bash
#SBATCH -A research
#SBATCH -n 10
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
python ../translate.py -data ../data/en-hi/processed_all-train.pt -load_from model_25_reinforce.pt -test_src test.en-hi.hi

