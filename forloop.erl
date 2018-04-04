-module(forloop). 
-export([for/2,start/0]). 

for(0,_) -> 
   []; 
   
   for(N,Term) when N > 0 -> 
   io:fwrite("Hello~n"), 
   for(N-1,Term). 
   
start() -> 
   for(5,1).

% erlc  forloop.erl 
% erl -noshell -s forloop start -s init stop
