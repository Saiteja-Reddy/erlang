c(nodemat).
Ms = spawn(two@Pandora,nodemat, cijmultserver, []).
Ms1 = spawn(three@Pandora,nodemat, cijmultserver, []).
Procs = [Ms,Ms1].
R1 = 8,
C1 = 8,
R2 = 8,
C2 = 8,
P = 4,    
M1 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64],
M2 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64],
nodemat:runDistMatmul(M1,M2,R1,R2,C1,C2, P, nodes(), Procs, 1, 1, 0, [0,0]).


nodemat:runDistMatmul(M1,M2,R1,R2,C1,C2, P, nodes(), Procs, 1, 0).  


c(nodemat).
Ms = spawn(two@Pandora,nodemat, cijmultserver, []).
Ms1 = spawn(three@Pandora,nodemat, cijmultserver, []).
Procs = [Ms,Ms1].
Ms2 = spawn(four@Pandora,nodemat, cijmultserver, []).
Ms3 = spawn(five@Pandora,nodemat, cijmultserver, []).
BProcs = [Ms2,Ms3].
R1 = 8,
C1 = 8,
R2 = 8,
C2 = 8,
P = 4,    
M1 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64],
M2 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64].
nodemat:init_clear(R1,R2,C1,C2, P, nodes()).
nodemat:runDistMatmul(M1,M2,R1,R2,C1,C2, P, nodes(), Procs,BProcs, 1, 0).
nodemat:fin_done().


