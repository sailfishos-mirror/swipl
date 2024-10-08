/*  Part of SWI-Prolog

    Author:        Jan Wielemaker
    E-mail:        J.Wielemaker@vu.nl
    WWW:           http://www.swi-prolog.org
    Copyright (c)  2008-2024, University of Amsterdam
                              VU University Amsterdam
			      SWI-Prolog Solutions b.v.
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions
    are met:

    1. Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.

    2. Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in
       the documentation and/or other materials provided with the
       distribution.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
    FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
    COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
    ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
    POSSIBILITY OF SUCH DAMAGE.
*/

:- module(test_unify, [test_unify/0]).
:- use_module(library(plunit)).

/** <module> Test Prolog unifying

This module is a Unit test for Prolog unification oddities.  If basic
unification is wrong you won't get as far as running this test :-)

@author	Jan Wielemaker
*/

test_unify :-
	run_tests([ unify,
		    can_compare,
		    unifiable
		  ]).

:- begin_tests(unify).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
blam([]).
blam([L|L]) :- blam(L).

test(blam, X == [[[]], []]) :-
	blam(X),
	length(X, 2), !.

unify_ar0(A) :-
	A = f().

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p(X,Y):-				% Bug#436
  U=U,
  V=V,
  findall(_C,
          q(X,Y,U,V),
          _Cs).

q(_,_,_,_).

test(unify_self, true) :-
	p(_,_).

:- style_check(-no_effect).
unify_fv(X) :-
	(   X == a
	->  Y = _			% mapped to true, but must init Y
	;   Y = x
	),
	garbage_collect,		% verify consistency
	copy_term(Y,_).			% use and verify Y
:- style_check(+no_effect).

test(unify_fv, true) :-
	unify_fv(a).
test(unify_arity_0, X == f()) :-
	unify_ar0(X).

test(cycle_1) :-                       % Kuniaki Mukai
    X = f(Y), Y=f(X), X=Y.
test(cycle_2) :-                       % Kuniaki Mukai
    X = f(X), Y=f(Y), X=f(Y).

:- end_tests(unify).

:- begin_tests(can_compare).

v(_).

test(ground, true) :-
	?=(a,b).
test(ground, true) :-
	?=(a,a).
test(ground, fail) :-
	v(X),
	?=(a,X).

:- end_tests(can_compare).

:- begin_tests(unifiable).

test(unifiable_1, S == [X=1]) :-
    unifiable(X, 1, S).
test(unifiable_2) :-
    unifiable(a(X,X), a(Y,Z), S),
    S == [Z=X, Y=X].
test(gc_1) :-
    trim_stacks,
    (   between(2, 10, N),
        Len is 1<<N,
        numlist(1, Len, L1),
        attvar_list(Len, L2),
        unifiable(L1, L2, _Unifier),
        fail
    ;   true
    ).

attvar_list(0, []) :- !.
attvar_list(N, [H|T]) :-
    freeze(H, integer(H)),
    N2 is N - 1,
    attvar_list(N2, T).

:- end_tests(unifiable).
