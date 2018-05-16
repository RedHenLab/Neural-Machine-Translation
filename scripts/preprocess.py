##python code to clean and tokenize a file
from __future__ import print_function
import string
import re,sys,os,codecs
from unicodedata import normalize
from mosestokenizer import *
lang='en'
# load document into memory
def load_doc(filename):
	# open the file as read only
	file = codecs.open(filename, 'r', encoding='utf-8')
	# read all text
	text = file.read()
	# close the file
	file.close()
	return text

# split a loaded document into sentences
def to_sentences(doc):
	return doc.strip().split('\n')

# clean a list of lines
def clean_lines(lines):
	cleaned = list()
	# prepare regex for character filtering
	re_print = re.compile('[^%s]' % re.escape(string.printable))
	tokenize=MosesTokenizer(lang)
	for line in lines:
		# normalize unicode characters
		#line = normalize('NFD', line).encode('ascii', 'ignore')
		#line = line.decode('UTF-8')
		#remove punctuation
		translation_table=str.maketrans("","",string.punctuation)
		line = line.translate(translation_table)
		# tokenize usig moses tokenizer
		line=tokenize(line)
		# convert to lower case
		line = [word.lower() for word in line]
		# store it as a string
		cleaned.append(' '.join(line))
	return cleaned

# save a list of clean sentences to file
def save_clean_sentences(sentences, filename):
	fout=open(filename,'a')
	for line in sentences:	
		print(line, file=fout)
	fout.close()
	print('Saved: %s' % filename)

if __name__=="__main__":
	# load tokenized data for cleaning
	filename = sys.argv[1]
	lang=sys.argv[2]
	doc = load_doc(filename)
	sentences = to_sentences(doc)
	sentences = clean_lines(sentences)
	save_clean_sentences(sentences, filename+'.processed') 
