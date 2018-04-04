-module(if_statement). 
-export([start/0]). 

start() -> 
   A = 5, 
   B = 6, 
   
   if 
      A == B -> 
         io:fwrite("True"); 
      true -> 
         io:fwrite("False") 
   end.

% erlc  if_statement.erl 
% erl -noshell -s if_statement start -s init stop