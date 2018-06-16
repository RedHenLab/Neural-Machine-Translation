from __future__ import print_function
import sys,os

input_dir=sys.argv[1]
files=os.listdir(input_dir)


fields = set(["TOP", "COL", "UID", "PID", "ACQ", "DUR", "VID", "TTL", "URL", "TTS", "SRC", "CMT", "LAN", "TTP", "HED", "OBT", "LBT", "END", "CC1", "CC2"])

f1=open("french.txt",'a')
f2=open("english.txt",'a')

for input_file in files:
	with open(os.path.join(input_dir,input_file)) as f:
		content=f.readlines()
	content=[x.strip() for x in content]
	f.close()
	c1=0
	c2=0
	for i in range(len(content)-1):
		line1=content[i]
		l1=line1.split('|')
		line2=content[i+1]
		l2=line2.split('|')
		if (l1[0] not in fields and (l1[2]=="CC1" or l1[2]=="CC2")) and  (l2[0] not in fields and (l2[2]=="CC1" or l2[2]=="CC2")):
			if l1[2]=="CC1" and l2[2]=="CC2":
				print(l1[3],file=f1)
				print(l2[3],file=f2)
				c1+=1
				c2+=1
		i+=1
	if c1!=c2:
		print(input_file)

f1.close()
f2.close()


