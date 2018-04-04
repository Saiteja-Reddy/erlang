-module(variables). 
-export([start/0]). 

start() -> 
   X = 40, 
   Y = 50, 
   Z = 0.00223,
   Result = X + Y, 
   io:fwrite("~w\n",[Result]),
   io:fwrite("~f\n",[Z]).

% erlc  variables.erl 
% erl -noshell -s variables start -s init stop


%  All variables need to start with the upper case character !!!
%  One key thing to note in Erlang is that variables are immutable, which means that in order for the value of the variable to change, it needs to be destroyed and recreated again.