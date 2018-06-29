##python code to tokenize a file
from __future__ import print_function
from itertools import izip
import string
import re,sys,os,codecs
file1=sys.argv[1]
file2=sys.argv[2]
fout1=open(file1+".cleaned",'a')
fout2=open(file2+".cleaned",'a')
with open(file1) as f1, open(file2) as f2:
	text1=f1.read().split('\n')
	text2=f2.read().split('\n')
	for x,y in izip(text1,text2):
		x=x.strip()
		y=y.strip()
		x=x.decode("utf-8").replace(u"\uFDD3",'').encode("utf-8")
		y=y.decode("utf-8").replace(u"\uFDD3",'').encode("utf-8")
		if len(x)>=1 and len(y)>=1:
			print(x,file=fout1)
			print(y,file=fout2)
f1.close()
f2.close()
