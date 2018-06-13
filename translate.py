import argparse
import os
import numpy as np
import random
import time

import torch
import torch.nn as nn
from torch import cuda
from torch.autograd import Variable

import lib

parser = argparse.ArgumentParser()

## Data options
parser.add_argument("-data", required=True,
                    help="Path to the *-train.pt file from preprocess.py")
parser.add_argument("-batch_size", default=32, help="Batch Size")
parser.add_argument("-save_dir", help="Directory to save predictions")
parser.add_argument("-load_from", required=True, help="Path to load a trained model.")
parser.add_argument("-test_src", required=True, help="Path to the file to be translated.")

# GPU
parser.add_argument("-gpus", default=[0], nargs="+", type=int,
                    help="Use CUDA")
parser.add_argument("-log_interval", type=int, default=100,
                    help="Print stats at this interval.")
parser.add_argument("-seed", type=int, default=3435,
                     help="Seed for random initialization")

opt = parser.parse_args()
print(opt)

# Set seed
torch.manual_seed(opt.seed)
np.random.seed(opt.seed)
random.seed(opt.seed)

opt.cuda = len(opt.gpus)

if opt.save_dir and not os.path.exists(opt.save_dir):
    os.makedirs(opt.save_dir)

if torch.cuda.is_available() and not opt.cuda:
    print("WARNING: You have a CUDA device, so you should probably run with -gpus 1")

if opt.cuda:
    	cuda.set_device(opt.gpus[0])
   	torch.cuda.manual_seed(opt.seed)

def makeTestData(srcFile,dicts):	
	print("Processing %s ..." % srcFile)
	srcF = open(srcFile,'r')
	text = srcF.read()
	srcF.close()
	lines=text.strip().split('\n')
	src=[]
	tgt=[]
	srcDicts = dicts["src"]
	count=0
	for line in lines:
		srcWords = line.split()
		src += [srcDicts.convertToIdx(srcWords,
		                          lib.Constants.UNK_WORD)]
		count += 1
	print("... %d sentences prepared for testing" % count)
	tgt=src
	return src,tgt,range(len(src))

def predict(model,dicts,data,pred_file):
	model.eval()
	all_preds=[]
	max_length=50
	for i in range(len(data)):
		batch=data[i]
		targets=batch[1]
		attention_mask=batch[0][0].data.eq(lib.Constants.PAD).t()
		model.decoder.attn.applyMask(attention_mask)
		preds = model.translate(batch, max_length)
		preds = preds.t().tolist()
		targets=targets.data.t().tolist()
		#hack
	    	indices=batch[2]
	    	new_batch=zip(preds,targets)
	    	new_batch,indices=zip(*sorted(zip(new_batch,indices),key=lambda x: x[1]))
	    	preds,targets=zip(*new_batch)
            	###
		all_preds.extend(preds)

	with open(pred_file, "w") as f:
            for sent in all_preds:
                sent = lib.Reward.clean_up_sentence(sent, remove_unk=False, remove_eos=True)
                sent = [dicts["tgt"].getLabel(w) for w in sent]
                x=" ".join(sent)+'\n'
		f.write(x)
	f.close()

def main():
	print('Loading train data from "%s"' % opt.data)

	dataset = torch.load(opt.data)
	dicts = dataset["dicts"]

	if opt.load_from is None:
		print("REQUIRES PATH TO THE TRAINED MODEL\n")
	else:
		print("Loading from checkpoint at %s" % opt.load_from)
		checkpoint = torch.load(opt.load_from)
		model = checkpoint["model"]
		optim = checkpoint["optim"]

	# GPU.
	if opt.cuda:
		model.cuda(opt.gpus[0])
		
    	# Generating Translations for test set
	print('Creating test data\n')
	src,tgt,pos=makeTestData(opt.test_src,dicts)
	res={}
	res["src"]=src
	res["tgt"]=tgt
	res["pos"]=pos
	test_data  = lib.Dataset(res, opt.batch_size, opt.cuda, eval=False)
	pred_file = opt.test_src+".pred"
	predict(model,dicts,test_data,pred_file)
	print('Generated translations successfully\n')

if __name__ == "__main__":
    main()
