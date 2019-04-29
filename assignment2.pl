correspond(E1, L1, E2, L2) :- nth0(X, L1, E1), nth0(X, L2, E2).

:- use_module(library(clpfd)).

list_to_matrix(_, [], []).
list_to_matrix(S, L, [R|M]):- make_row(S, L, R, T), list_to_matrix(S, T, M).

make_row(0, T, [], T).
make_row(S, [E|L], [E|R], T):- N is S-1, make_row(N, L, R, T).

interleave([], []).
interleave(Ls, L) :- \+ var(L), length(Ls, LLs), list_to_matrix(LLs, L, MX), transpose(MX, Ls).
interleave(Ls, L) :- var(L), transpose(Ls, TL), flatten(TL, L).

checkIt(Var, Val, E, Val) :- atom(E), E = Var.
checkIt(Var, _, E, E) :- atom(E), E \= Var.
checkIt(_, _, E, E) :- number(E).
checkIt(Var, Val, E, E1) :- compound(E), partial_eval(E, Var, Val, E1).

partial_eval(Expr0, Var, Val, Expr) :- compound_name_arguments(Expr0,Cal,Expr0L), maplist(checkIt(Var, Val), Expr0L, Result), compound_name_arguments(Expr1L, Cal, Result), maplist(number, Result), Expr is Expr1L.
partial_eval(Expr0, Var, Val, Expr) :- compound_name_arguments(Expr0,Cal,Expr0L), maplist(checkIt(Var, Val), Expr0L, Result), compound_name_arguments(Expr1L, Cal, Result), \+ maplist(number, Result), Expr = Expr1L.
