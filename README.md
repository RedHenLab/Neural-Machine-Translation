# Neural-Machine-Translation
neural machine translation system for tv news
Data Preprocessing:
1) To preprocess train data, use the command "python3 preprocess.py filename language-code".
2) The file preprocess.py will clean(remove punctuations, normalization if needed, removing non-printable characters) and tokenize(using mosestokenizer package) the the train file.
3) To process test data, use the command "python3 tokenize.py filename language-code". This file will be needed for handling input news transcripts.
