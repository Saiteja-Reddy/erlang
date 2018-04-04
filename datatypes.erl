-module(datatypes).
-export([start/0]).
-export([next/0]).
-import(lists,[nth/2]). 
-export([bit_string/0]).
-export([tuple/0]).
-export([map/0]).
-export([list/0]).

start() ->
   io:fwrite("~w",[1+1]). % add

next() ->
   io:fwrite(2 =< 3). %boolean

bit_string() ->
   Bin1 = <<10,20,40>>,
   X = binary_to_list(Bin1),
   io:fwrite("~w\n",[X]).  % bitstring

tuple() -> 
   P = {john,24,{june,25}} , 
   io:fwrite("~w is size\n",[tuple_size(P)]). % tuple

map() -> 
   M1 = #{name=>john,age=>25}, 
   io:fwrite("~w is map size\n",[map_size(M1)]). % map

list() -> 
   L = [10,20,30],
   io:fwrite("~w is length of list\n",[length(L)]),
   io:fwrite("~p is 2nd element\n",[nth(2,L)]). % list

% erlc  datatypes.erl 
% erl -noshell -s datatypes tuple -s init stop