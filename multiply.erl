%% Doesn't check matrix sizes match but 
%% not restricted to square matrices.
%%
%% Represent matrix as tuple of tuples.
%% Doesn't use destructive assignment so building a
%% matrix creates an awful lot of temporary lists.
%%
%% Usage: start from command line with
%%     erlc multiply.erl
%%     erl -noinput -s multiply main 1

-module(multiply). 
-export([main/1]). 
-import(lists, [reverse/1]).


sumprod(0, _, _, Sum, _, _) -> Sum;
sumprod(I, C, R, Sum, M1, M2) -> 
    NewSum = Sum + (element(I,element(R,M1)) * element(C,element(I,M2))),
    sumprod(I-1, C, R, NewSum, M1, M2).


rowmult(_, 0, _, L, _, _) -> list_to_tuple(L);
rowmult(I, C, R, L, M1, M2) -> 
    SumProd = sumprod(I, C, R, 0, M1, M2),
    rowmult(I, C-1, R, [SumProd|L], M1, M2).


mmult(_, _, 0, MM, _, _) -> list_to_tuple(MM);
mmult(I, C, R, MM, M1, M2) ->
    NewRow = rowmult(I, C, R, [], M1, M2),
    mmult(I, C, R-1, [NewRow|MM], M1, M2).

mmult(M1, M2) -> 
    Inner = size(M2), % could optimize more by hardcoding the sizes
    NRows = size(M1), 
    mmult(Inner, NRows, NRows,[], M1, M2).


repeatmmult(1, M1, M2) -> mmult(M1, M2);
repeatmmult(NTimes, M1, M2) -> 
    mmult(M1, M2),
    repeatmmult(NTimes-1, M1, M2).


mkrow(0, L, Count) -> {list_to_tuple(reverse(L)), Count};
mkrow(N, L, Count) -> mkrow(N-1, [Count|L], Count+1).


mkmatrix(0, _, _, M) -> list_to_tuple(reverse(M));
mkmatrix(NR, NC, Count, M) ->
    {Row, NewCount} = mkrow(NC, [], Count),
    mkmatrix(NR-1, NC, NewCount, [Row|M]).

mkmatrix(NR, NC) -> mkmatrix(NR, NC, 1, []).


main([Arg]) ->
    NTimes = list_to_integer(atom_to_list(Arg)),
    Size = 3,
    M1 = mkmatrix(Size, Size),
    io:fwrite("~w ~n", [M1]),
    % M2 = mkmatrix(Size, Size),
    % MM = repeatmmult(NTimes, M1, M2),
    % Val1 = element(1,element(1, MM)), 
    % Val2 = element(4,element(3, MM)), % get col 4 out of row 3
    % Val3 = element(3,element(4, MM)), % get col 3 out of row 4
    % Val4 = element(5,element(5, MM)), 
    % io:fwrite("~w ~w ~w ~w~n", [Val1, Val2, Val3, Val4]),
    halt(0).            


