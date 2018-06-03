from __future__ import print_function
import sys,os

input_file=sys.argv[1]

with open(input_file) as f:
	content=f.readlines()
content=[x.strip() for x in content]
f.close()

fields = set(["TOP", "COL", "UID", "PID", "ACQ", "DUR", "VID", "TTL", "URL", "TTS", "SRC", "CMT", "LAN", "TTP", "HED", "OBT", "LBT", "END", "CC1"])

f1=open("tmp.txt",'a')
for line in content:
	l=line.split('|')
	if l[0]	not in fields:
		sent=l[3]
		print(sent,file=f1)
f1.close()

