-module(matrix). 
-export([start/1, runfunc/1, printval/1, storeval/2]). 

start(X) ->
   spawn(?MODULE, runfunc, [X]). 

runfunc(X) ->
	receive 
		{From, {printval}} ->
			From ! {self(), X},
			runfunc(X);
		{From, {storeval , Value}} ->
			From ! {self(), ok},
			runfunc([Value|X]);
		terminate ->
		ok
	end.

printval(Pid) ->
	Pid ! {self(), {printval}},
	receive
		{Pid, Msg} -> Msg
	end.

storeval(Pid, X) ->
	Pid ! {self(), {storeval, X}},
	receive
		{Pid, Msg} -> Msg
	end.

% erlc  matrix.erl 
% erl -noshell -s matrix start -s init stop
