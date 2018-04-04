% hello world program
-module(hello).
% import function used to import the io module
-import(io,[fwrite/1]).
% export function used to ensure the start function can be accessed.
-export([start/0]).

start() ->
   fwrite("Hello, world!\n").


% erlc  hello.erl 
% erl -noshell -s hello start -s init stop