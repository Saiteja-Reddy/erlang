-module(multiple_if). 
-export([start/0]). 

start() -> 
   A = 5, 
   B = 6, 
   if 
      A == B -> 
         io:fwrite("A is equal to B"); 
      A < B -> 
         io:fwrite("A is less than B"); 
      true -> 
         io:fwrite("False") 
   end.

% erlc  multiple_if.erl 
% erl -noshell -s multiple_if start -s init stop