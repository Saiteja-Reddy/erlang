import math
import numpy as np

f = open("output.txt", "r")
temp = f.readline()
temp = f.readline()
temp = temp.split("\n")
temp = temp[0].split("X")
r = int(temp[0])
c = int(temp[1])

temp = f.readline()
temp = temp.split("\n")
temp = temp[0].split("X")
L = int(temp[0])
P = int(temp[1])

mydict = {}

for line in f.readlines():
    temp = line
    temp = temp.split("\n")
    temp = temp[0].split(" - ")
    pos = eval(temp[0])
    arr = eval(temp[1])
    mydict[pos] = np.reshape(arr, (4,4))
    # print(pos,arr)
f.close()

sR = int(r/math.sqrt(P))
sC = sR

nR = int(r/sR)
nC = int(c/sC)

fin = []

for i in range(1,nR+1):
	for a in range(1,sR+1):
		for j in range(1,nC + 1):
			for b in range(1,sC+1):
				pos = (i,j)
				# print(mydict[pos][a-1][b-1], end=" ")
				fin.append(mydict[pos][a-1][b-1])
# print(fin)
text = ""
for i in fin:
	text = text + "," + str(i)  

text = "[" + text[1:] + "]."
# print(text)

f = open("erlin.txt", "w")
f.write(text)
f.close()
print("Done")