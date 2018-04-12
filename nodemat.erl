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
-export([start/0, printMat/4, multiply/9, multiplyRC/10, multserver/0, domultiply/7, startmultserver/0, getSubMatrix/9]). 
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
  N = R/sqrt(P),
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
  
start() ->
    R1 = 8,
    C1 = 8,
    R2 = 3,
    C2 = 3,
    P = 4,    
    M1 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64],
    M2 = [1,2,3,4,5,6,7,8,9],
    printMat(M1,R1,C1,1),
    I = 2,
    J = 2,
    N = R1/sqrt(P),   
    Aut = getSubMatrix(M1,R1,C1,I,J,P, (I-1)*N, (J-1)*N, []),
    io:fwrite("~w~n",[Aut]).
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