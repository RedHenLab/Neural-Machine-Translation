# Multilingual Neural Machine Translation System for TV News

_This is my [Google summer of Code 2018](https://summerofcode.withgoogle.com/projects/#6685973346254848) Project with [the Distributed Little Red Hen Lab](http://www.redhenlab.org/)._

The aim of this project is to build a Multilingual Neural Machine Translation System, which would be capable of translating Red Hen Lab's TV News Transcripts from different source languages to English. 

The system uses Reinforcement Learning(Advantage-Actor-Critic algorithm) on the top of neural encoder-decoder architecture and outperforms the results obtained by simple Neural Machine Translation which is based upon maximum log-likelihood training. Our system achieves state-of-the-art results on the standard WMT(Workshop on Machine Translation) test datasets. 

This project is inspired by the approaches mentioned in the paper [An Actor-Critic Algorithm for Sequence Prediction](https://arxiv.org/pdf/1607.07086).

## Getting Started

### Prerequisites

* Python-2.7
* Pytorch-0.2
* Tensorflow-gpu
* Numpy
* CUDA

### Installation & Setup Instructions on CASE HPC

* First of all, please make a note of the path of the directory in which this repository will be cloned.

* The directory structure of the working system should be as follows:
  * singularity
  * data
  * models
  * Neural-Machine-Translation
  * myenv

* The **singularity** directory should contain a singularity image(rh_xenial_20180308.img) which is to be copied from the home directory of **Michael Pacchioli's CASE HPC account**. This singularity image contains some modules like CUDA and CUDANN needed for the system. 

* The **data** directory consists cleaned & processed datasets of respective language pairs. The subdirectories of this directory should be named like **de-en** where **de** & **en** are the language codes for **German** & **English**. So for any general language pair whose source language is **$src** and the target language is **$tgt**, the language data subdirectory should be named as **$src-$tgt** and it should contain the following files(train, validation & test):
  * train.$src-$tgt.$src.processed
  * train.$src-$tgt.$tgt.processed
  * valid.$src-$tgt.$src.processed
  * valid.$src-$tgt.$tgt.processed
  * test.$src-$tgt.$src.processed
  * test.$src-$tgt.$tgt.processed

* The **models** directory consists of trained models for the respective language pairs and also follows the same structure of subdirectories as **data** directory. For example, **models/de-en** will contains trained models for the **German-English** language pair.

* If the you are in the working system directory, then please open a terminal & enter the following commands to install dependencies.
  ```bash
  $ git clone https://github.com/RedHenLab/Neural-Machine-Translation.git
  $ virtualenv myenv
  $ source myenv/bin/activate
  $ pip install -r Neural-Machine-Translation/requirements.txt
  ```
* **Note** that the virtual environment(myenv) created using virtualenv command mentioned above, should be of **Python2** .


## Acknowledgements

* [Google Summer of Code 2017](https://summerofcode.withgoogle.com/)
* [Red Hen Lab](http://www.redhenlab.org/)
* [OpenNMT-py](https://github.com/OpenNMT/OpenNMT-py)
* [An Actor-Critic Algorithm for Sequence Prediction](https://arxiv.org/pdf/1607.07086)
* [Europarl](http://www.statmt.org/europarl/)
* [Moses](https://github.com/moses-smt/mosesdecoder)
