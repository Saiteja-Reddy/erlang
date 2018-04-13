%% Doesn't check matrix sizes match but 
%% not restricted to square matrices.
%%
%% Represent matrix as tuple of tuples.
%% Doesn't use destructive assignment so building a
%% matrix creates an awful lot of temporary lists.
%%
%% Usage: start from command line with
%%     erlc mat.erl
%%     erl -noinput -s mat start

-module(nodemat). 
-export([reverse_create/1, start/0, printMat/4, multiply/9, multiplyRC/10, multserver/0, domultiply/7, startmultserver/0, getSubMatrix/9, addMatrix/6, getCElement/11]). 
-import(lists, [reverse/1, nth/2]).
-import(math, [sqrt/1]).

printMat(M,R,C,X) -> 
    io:fwrite("~w ", [nth(X,M)]),
   if 
      (X rem R == 0) and (C*R /= X) -> 
         io:fwrite("~n"),
         printMat(M,R,C,X+1);
    (X rem R == 0) and (C*R == X) ->
        io:fwrite("~n~n"),
        ok;
      true -> 
        printMat(M,R,C,X+1)
   end.

multiply(M1,M2,R1,R2,C1,C2,MM, X,Y) ->
   if 
      (X == R1 + 1) ->
        reverse(MM);
      (Y == C2 + 1) -> 
         multiply(M1,M2,R1,R2,C1,C2, MM, X+1,1);
      true -> 
         Out = multiplyRC(M1,M2,R1,R2,C1,C2, X, Y, 1, 0),
         multiply(M1,M2,R1,R2,C1,C2,[Out|MM], X,Y+1)
   end.

multiplyRC(M1,M2,R1,R2,C1,C2, X,Y,C, Sum) ->
   if 
      (C == C1 + 1) -> 
         Sum;
      true -> 
        multiplyRC(M1,M2,R1,R2,C1,C2, X,Y,C+1, Sum+nth((X-1)*C2+C,M1)*nth((C-1)*C2+Y,M2))
   end.    

multserver() ->
  receive 
    {From, {M1,M2,R1,R2,C1,C2}} ->
      Aut = multiply(M1,M2,R1,R2,C1,C2, [], 1,1),
      From ! {self(),Aut, node()},
      multserver();
    {From, done} ->
      From ! {self(),"Closed Mult Server"};
      _ -> 
      io:format("Unexpected Message!"),
      multserver()
    end.

domultiply(Pid, M1,M2,R1,R2,C1,C2) ->
  Pid ! {self(), {M1,M2,R1,R2,C1,C2}},
  receive 
    {Pid, Msg, FromNode} -> {Msg, FromNode}
    % add delay here
  end.

getSubMatrix(M, R, C, I, J, P, X, Y, SM) -> % assume I = J, P = no. of Processors
  N = round(R/sqrt(P)),
  XL = (I-1)*N,
  XR = (I)*N-1,
  YL = (J-1)*N,
  YR = (J)*N-1,     
     if 
        (X == XR + 1) ->
          reverse(SM);
        (Y > YR) ->
           getSubMatrix(M, R, C, I, J, P, X+1, YL, SM);       
        true -> 
           A = nth(round(X)*C+round(Y)+1,M),
           getSubMatrix(M, R, C, I, J, P, X, Y+1, [A|SM])
     end.

startmultserver() ->
  spawn(?MODULE, multserver, []).

addMatrix(M1,M2,C,R,X,SM) ->
   RM = [nth(X,M1) + nth(X,M2) | SM],
   if 
      (X rem R == 0) and (C*R /= X) -> 
         addMatrix(M1,M2,C,R,X+1,RM);
    (X rem R == 0) and (C*R == X) ->
        reverse(RM);
      true -> 
        addMatrix(M1,M2,C,R,X+1,RM)
   end.

% do  contention-free formula here
getCElement(M1,M2, R1, C1, R2, C2, P, I, J, K, Sum) -> % assume I = J, P = no. of Processors
     KL = round(sqrt(P)),
     if 
        (K == KL) ->
          Sum;       
        true -> 
           R = I,
           S = ((I+J+K) rem KL) + 1,
           N = R1/sqrt(P),
           A = getSubMatrix(M1, R1, C1, R, S, P, (R-1)*N, (S-1)*N , []),
           R1 = ((I+J+K) rem KL) + 1,
           S1 = J,
           B = getSubMatrix(M2, R2, C2, R1, S1, P, (R1-1)*N, (S1-1)*N , []),
           MultAB = multiply(A,B,N,N,N,N,[], 1,1),
           Net = addMatrix(Sum,MultAB, N,N,1, []),
           getCElement(M1,M2,R1,C1,R2,C2, P, I, J, K+1, Net)           
     end.

reverse_create( 0 ) -> [];
reverse_create( N ) when N > 0 -> reverse_create( N-1 ) ++ [0].
  
start() ->
    R1 = 8,
    C1 = 8,
    R2 = 8,
    C2 = 8,
    P = 4,    
    M1 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64],
    M2 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64],
    printMat(M1,R1,C1,1),


    % Aut = getCElement(M1,M2, R1, C1, R2, C2, P, 1, 1, 0, []),
    % io:fwrite("~w~n",[Aut]).

    KL = round(sqrt(P)),
    N = round(R1/sqrt(P)),   

    Sum = reverse_create(N*N),
    % io:fwrite("~w Here~n",[Sum]),

    I = 1,
    J = 2,
    Aut = getSubMatrix(M1,R1,C1,I,J,P, (I-1)*N, (J-1)*N, []),
    printMat(Aut,N,N,1),

    I1 = 2,
    J1 = 1,
    Aut1 = getSubMatrix(M2,R1,C1,I1,J1,P, (I1-1)*N, (J1-1)*N, []),
    printMat(Aut1,N,N,1),


    MultAB = multiply(Aut,Aut1,N,N,N,N,[], 1,1),
    printMat(MultAB,N,N,1),

    Sum1 = addMatrix(Sum,MultAB, N,N,1, []),

    I2 = 1,
    J2 = (2 + 1) rem KL,
    Aut2 = getSubMatrix(M1,R1,C1,I2,J2,P, (I2-1)*N, (J2-1)*N, []),
    printMat(Aut2,N,N,1),

    I3 = (2 + 1) rem KL,
    J3 = 1,
    Aut3 = getSubMatrix(M2,R1,C1,I3,J3,P, (I3-1)*N, (J3-1)*N, []),
    printMat(Aut3,N,N,1),

    MultAB1 = multiply(Aut2,Aut3,N,N,N,N,[], 1,1),
    printMat(MultAB1,N,N,1),

    Sum2 = addMatrix(Sum1,MultAB1, N,N,1, []),
    printMat(Sum2, N,N,1).

    % I2 = 1,
    % J2 = 1,
    % N = R2/sqrt(P),   
    % Aut2 = getSubMatrix(M2,R1,C1,I2,J2,P, (I2-1)*N, (J2-1)*N, []),
    % io:fwrite("~w~n",[Aut2]),
    % I3 = 1+1,
    % J3 = 1,
    % Aut3 = getSubMatrix(M1,R1,C1,I3,J3,P, (I3-1)*N, (J3-1)*N, []),
    % io:fwrite("~w~n",[Aut3]).

    % printMat(M2,R2,C2,1),
    % Aut = multiply(M1,M2,R1,R2,C1,C2, [], 1,1),
    % io:fwrite("~w~n",[Aut]).
    % halt(0).   


% Test Commands
% Ms = nodemat:startmultserver().
% nodemat:domultiply(Ms, [1,0,0,4,5,6,7,8,9], [1,2,3,4,5,6,7,8,9], 3, 3, 3, 3).

%Internode Commands
% c(nodemat).
% net_kernel:connect_node(two@Pandora).
% Ms = spawn(two@Pandora,nodemat, multserver, []).
% nodemat:domultiply(Ms, [1,0,0,4,5,6,7,8,9], [1,2,3,4,5,6,7,8,9], 3, 3, 3, 3).