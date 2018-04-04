-module(operators). 
-export([start/0]). 
-export([boolean_op/0]). 
-export([logical_op/0]). 
-export([bitwise_op/0]). 

start() -> 
   X = 40, 
   Y = 50, 
   
   Res1 = X + Y, 
   Res2 = X - Y, 
   Res3 = X * Y, 
   Res4 = X / Y, 
   Res5 = X div Y, 
   Res6 = X rem Y, 
   
   io:fwrite("~w~n",[Res1]), 
   io:fwrite("~w~n",[Res2]), 
   io:fwrite("~w~n",[Res3]), 
   io:fwrite("~w~n",[Res4]), 
   io:fwrite("~w~n",[Res5]), 
   io:fwrite("~w~n",[Res6]).


boolean_op() -> 
   io:fwrite("~w~n",[3==2]), 
   io:fwrite("~w~n",[3/=2]), 
   io:fwrite("~w~n",[3<2]), 
   io:fwrite("~w~n",[3=<2]), 
   io:fwrite("~w~n",[3>2]), 
   io:fwrite("~w~n",[3>=2]).

logical_op() -> 
   io:fwrite("~w~n",[true or false]),  
   io:fwrite("~w~n",[true and false]), 
   io:fwrite("~w~n",[true xor false]), 
   io:fwrite("~w~n",[not false]).

bitwise_op() -> 
   io:fwrite("~w~n",[00111100 band 00001101]), 
   io:fwrite("~w~n",[00111100 bxor 00111100]), 
   io:fwrite("~w~n",[bnot 00111100]), 
   io:fwrite("~w~n",[00111100 bor 00111100]).

% erlc  operators.erl 
% erl -noshell -s operators start -s init stop