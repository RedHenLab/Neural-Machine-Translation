from __future__ import print_function
import sys,os
import datetime

input_file=sys.argv[1]
fields = set(["TOP", "COL", "UID", "PID", "ACQ", "DUR", "VID", "TTL", "URL", "TTS", "SRC", "CMT", "LAN", "TTP", "HED", "OBT", "LBT", "END", "CC1"])

with open(input_file) as f:
        content=f.readlines()
content=[x.strip() for x in content]
f.close()

with open("tmp.txt.pred") as f:
        pred_content=f.readlines()
pred_content=[x.strip() for x in pred_content]
f.close()

f1=open(input_file+".pred",'a')
sent_index=0
credit_flag=0
for line in content:
	l=line.split('|')
	if l[0] in fields:
		print(line,file=f1)
		if l[0]=="LAN":
			lang=l[1]		
	elif l[0] not in fields:
		if not credit_flag:
			timestamp=datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
			source_program="Neural Machine Translation 1.0, translate.sh"
			source_person="Vikrant Goyal"
			print(lang+"_01" + '|' + timestamp + '|' + "Source_Program=" + source_program + '|' + "Source_Person=" + source_person ,file=f1)
			credit_flag=1
		l[2]=lang+"_01"
		l[3]=pred_content[sent_index]
		print(l[0]+'|'+l[1]+'|'+l[2]+'|'+l[3],file=f1)	
		sent_index+=1
f1.close()
