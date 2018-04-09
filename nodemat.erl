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
-export([start/0, printMat/4, multiply/9, multiplyRC/10, multserver/0, domultiply/7, startmultserver/0]). 
-import(lists, [reverse/1, nth/2]).

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

startmultserver() ->
  spawn(?MODULE, multserver, []).
  
start() ->
    R1 = 3,
    C1 = 3,
    R2 = 3,
    C2 = 3,    
    M1 = [1,0,0,4,5,6,7,8,9],
    M2 = [1,2,3,4,5,6,7,8,9],
    printMat(M1,R1,C1,1),
    printMat(M2,R2,C2,1),
    Aut = multiply(M1,M2,R1,R2,C1,C2, [], 1,1),
    io:fwrite("~w~n",[Aut]),
    halt(0).   


% Test Commands
% Ms = nodemat:startmultserver().
% nodemat:domultiply(Ms, [1,0,0,4,5,6,7,8,9], [1,2,3,4,5,6,7,8,9], 3, 3, 3, 3).

%Internode Commands
% c(nodemat).
% net_kernel:connect_node(two@Pandora).
% Ms = spawn(two@Pandora,nodemat, multserver, []).
% nodemat:domultiply(Ms, [1,0,0,4,5,6,7,8,9], [1,2,3,4,5,6,7,8,9], 3, 3, 3, 3).