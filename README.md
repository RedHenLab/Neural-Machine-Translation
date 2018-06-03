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

## Acknowledgements

* [Google Summer of Code 2017](https://summerofcode.withgoogle.com/)
* [Red Hen Lab](http://www.redhenlab.org/)
* [OpenNMT-py](https://github.com/OpenNMT/OpenNMT-py)
* [An Actor-Critic Algorithm for Sequence Prediction](https://arxiv.org/pdf/1607.07086)
* [Europarl](http://www.statmt.org/europarl/)
* [Moses](https://github.com/moses-smt/mosesdecoder)
