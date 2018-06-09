#!/bin/bash
#SBATCH -N 1
#SBATCH -c 12
#SBATCH --mem-per-cpu=2G
#SBATCH -p gpu -C gpuk40 --gres=gpu:1
#SBATCH --time=10-00:30:00
#SBATCH --mail-type=ALL
#SBATCH --output=slurm-translate.out
#SBATCH --job-name="nmt-translate"

if [[ $# != 3 ]] ; then
    echo 'Error, command should be: <sbatch translate.sh src-lang-code tgt-lang-code path-of-inputTranscript>'
    exit 1
fi

src=$1
tgt=$2
input_file=$3
lang=${1}-${2}

export HOME=$(pwd)/../..
export DATA=$HOME/data
export DATA_PREP=$DATA/$lang
export MODELS=$HOME/models/$lang
export SCRIPT=$HOME/Neural-Machine-Translation/scripts

module load singularity/2.5.1
cd $HOME/singularity
singularity shell -w --nv rh_xenial_20180308.img

cd $SCRIPT
source $HOME/myenv/bin/activate

python $SCRIPT/parse.py $input_file
#python $SCRIPT/moses_tokenize.py $SCRIPT/tmp.txt de
python $HOME/Neural-Machine-Translation/translate.py -data $DATA_PREP/processed_all-train.pt -load_from $MODELS/model_25_reinforce.pt -test_src $SCRIPT/tmp.txt
sed -r 's/(@@ )|(@@ ?$)//g' tmp.txt.pred
python $SCRIPT/output.py $input_file
rm $SCRIPT/tmp.txt*
