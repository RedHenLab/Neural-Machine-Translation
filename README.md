# Multilingual Neural Machine Translation System for TV News

_This is my [Google summer of Code 2018](https://summerofcode.withgoogle.com/projects/#6685973346254848) Project with [the Distributed Little Red Hen Lab](http://www.redhenlab.org/)._

The aim of this project is to build a Multilingual Neural Machine Translation System, which would be capable of translating Red Hen Lab's TV News Transcripts from different source languages to English. 

The system uses Reinforcement Learning(Advantage-Actor-Critic algorithm) on the top of neural encoder-decoder architecture and outperforms the results obtained by simple Neural Machine Translation which is based upon maximum log-likelihood training. Our system achieves close to state-of-the-art results on the standard WMT(Workshop on Machine Translation) test datasets. 

This project is inspired by the approaches mentioned in the paper [An Actor-Critic Algorithm for Sequence Prediction](https://arxiv.org/pdf/1607.07086).

I have made a GSoC blog, please refer to it for my all GSoC blogposts about the progress made so far.
Blog link: https://vikrant97.github.io/gsoc_blog/

The following languages are supported as the source language & the below are their language codes:
1) **German - de**
2) **French - fr**
3) **Russian - ru**
4) **Czech - cs**
5) **Spanish - es**
6) **Portuguese - pt**
7) **Danish - da**
8) **Swedish - sv**
9) **Chinese - zh**
The target language is English(en).

## Getting Started

### Prerequisites

* Python-2.7
* Pytorch-0.3
* Tensorflow-gpu
* Numpy
* CUDA

### Installation & Setup Instructions on CASE HPC

* Users who want the pipeline to work on case HPC, just copy the directory named **nmt** from the home directory of my hpc acoount i.e **/home/vxg195** & then follow the instructions described for training & translation.

* nmt directory will contain the following subdirectories:
  * singularity
  * data
  * models
  * Neural-Machine-Translation 
  * myenv

* The **singularity** directory contains a singularity image(rh_xenial_20180308.img) which is copied from the home directory of **Mr. Michael Pacchioli's CASE HPC account**. This singularity image contains some modules like CUDA and CUDANN needed for the system. 

* The **data** directory consists of cleaned & processed datasets of respective language pairs. The subdirectories of this directory should be named like **de-en** where **de** & **en** are the language codes for **German** & **English**. So for any general language pair whose source language is **$src** and the target language is **$tgt**, the language data subdirectory should be named as **$src-$tgt** and it should contain the following files(train, validation & test):
  * train.$src-$tgt.$src.processed
  * train.$src-$tgt.$tgt.processed
  * valid.$src-$tgt.$src.processed
  * valid.$src-$tgt.$tgt.processed
  * test.$src-$tgt.$src.processed
  * test.$src-$tgt.$tgt.processed

* The **models** directory consists of trained models for the respective language pairs and also follows the same structure of subdirectories as **data** directory. For example, **models/de-en** will contains trained models for the **German-English** language pair.

* The following commands were used to install dependencies for the project:
  ```bash
  $ git clone https://github.com/RedHenLab/Neural-Machine-Translation.git
$ virtualenv myenv
# Linux/MacOS: Activate the virtual environment
$ source myenv/bin/activate
# Windows: Activate the virtual environment
$ myenv\Scripts\activate
$ pip install -r Neural-Machine-Translation/requirements.txt

  ```
* **Note** that the virtual environment(myenv) created using virtualenv command mentioned above, should be of **Python2** .

## Data Preparation and Preprocessing

Please note that these data preparation steps have to be done manually as we are dealing with a Multilingual system and each language pair might have different sources of data. For instance, I used many different data sources like europarl, newscommentary, commoncrawl & other opern source datasets. One can have a look at shared task on Machine Translation i.e. WMT, to get better datasets. I wrote a bash script which can be used to process & prepare dataset for MT. The following steps can be used to prepare dataset for MT:
1) First copy the raw dataset files in the language($src-$tgt) subdirectory of the data directory in the following format:
  * train.$src-$tgt.$src
  * train.$src-$tgt.$tgt
  * valid.$src-$tgt.$src
  * valid.$src-$tgt.$tgt
  * test.$src-$tgt.$src
  * test.$src-$tgt.$tgt

2) Now create an empty directory named $src-$tgt in the Neural-Machine-Translation/subword_nmt directory. Copy the file named "prepare_data.sh" into the language subdirectory for which we need to prepare the dataset. Then use the following commands to process the dataset for training:
 ```bash
 bash prepare_data.sh $src $tgt
 ```
 After this process, clear the entire language directory & just keep \*.processed files. Your processed dataset is ready!!

## Training

To train a model on CASE HPC one needs to run the train.sh file placed in Neural-Machine-translation/scripts folder. The parameters for training are kept such that a model can be efficiently trained for any newly introduced language pair, but one needs to tune the parameters according to the dataset. The prerequisite for training a model is that the parallel data as described in **Installation** section should be residing in the concerned language pair directory in the data folder. The trained models will be saved in the language pair directory in the models folder. To train a model on CASE HPC, run the following command:
 
 ```bash
 cd Neural-Machine-Translation/scripts
 sbatch train.sh <src-language-code> <target-language-code>
 # For example to train a model for German->English one should type the following command
 sbatch train.sh de en
 ```
After training, the trained model will be saved in language($src-$tgt) subdirectory in the models directory. The saved model would be something like "model_15.pt" and it should be renamed to "model_15_best.pt". 

## Translation
This project supports translation of both normal text file and news transcripts in any supported language pair.
To translate any input news transcript, run the following commands:
 ```bash
 cd Neural-Machine-Translation/scripts
 sbatch translate.sh <src-language-code> <target-language-code> <path-of-news-transcript> 0
 ```
To translate any normal text file, run the following commands:
 ```bash
 cd Neural-Machine-Translation/scripts
 sbatch translate.sh <src-language-code> <target-language-code> <path-of-news-transcript> 1
 ```
**Note that the output translated file will be saved in the same directory containing the input file and with a ".pred" string appended to the name of the input file.**

## Evaluation of the trained model
For evaluation, generate translation of any source test corpora. Now, we need to test its efficiency against the original target test corpus. For this, we use multi-bleu.perl script residing in the scripts directory which measures the corpus BLEU score. Usage instructions:
```bash
perl scripts/multi-bleu.perl $reference-file < $hypothesis-file
```

## Acknowledgements

* [Google Summer of Code 2018](https://summerofcode.withgoogle.com/)
* [Red Hen Lab](http://www.redhenlab.org/)
* [OpenNMT-py](https://github.com/OpenNMT/OpenNMT-py)
* [An Actor-Critic Algorithm for Sequence Prediction](https://arxiv.org/pdf/1607.07086)
* [Europarl](http://www.statmt.org/europarl/)
* [Moses](https://github.com/moses-smt/mosesdecoder)
