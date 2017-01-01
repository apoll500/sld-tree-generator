% -----------------------------------------------------------------------------+
%                                                                              |
%  builtin.pl                                                                  |
%                                                                              |
%  This file is part of "sld-tree-generator". (this program)                   |
%                                                                              |
% -----------------------------------------------------------------------------+
%                                                                              |
%  Copyright (C) 2016 by Andreas Pollhammer                                    |
%                                                                              |
%  Email: apoll500@gmail.com                                                   |
%  Web:   http://www.andreaspollhammer.com                                     |
%                                                                              |
% -----------------------------------------------------------------------------+
%                                                                              |
%  Licensed under GPLv3:                                                       |
%                                                                              |
%  This program is free software: you can redistribute it and/or modify        |
%  it under the terms of the GNU General Public License as published by        |
%  the Free Software Foundation, either version 3 of the License, or           |
%  (at your option) any later version.                                         |
%                                                                              |
%  This program is distributed in the hope that it will be useful,             |
%  but WITHOUT ANY WARRANTY; without even the implied warranty of              |
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
%  GNU General Public License for more details.                                |
%                                                                              |
%  You should have received a copy of the GNU General Public License           |
%  along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
%                                                                              |
% -----------------------------------------------------------------------------+
intern_call(A):-A.
intern_cut:-true.
intern_write(A):-true.
intern_listing:-true.
intern_listing(A):-true.

% Verify Type of a Term

intern_var(Term):-var(Term).
intern_nonvar(Term):-nonvar(Term).
intern_integer(Term):-integer(Term).
intern_float(Term):-float(Term).
intern_rational(Term):-rational(Term).
intern_rational(Term,Numerator,Denominator):-rational(Term,Numerator,Denominator).
intern_number(Term):-number(Term).
intern_atom(Term):-atom(Term).
intern_blob(Term,Type):-blob(Term,Type).
intern_string(Term):-string(Term).
intern_atomic(Term):-atomic(Term).
intern_compound(Term):-compound(Term).
intern_ground(Term):-ground(Term).
intern_cyclic_term(Term):-cyclic_term(Term).
intern_acyclic_term(Term):-acyclic_term(Term).
intern_(Term):-(Term).
intern_(Term):-(Term).
intern_(Term):-(Term).
intern_(Term):-(Term).
intern_(Term):-(Term).

% Comparison and Unification of Terms

% - Standard Order of Terms

intern_term_eq(Term1,Term2):-Term1==Term2.
intern_term_neq(Term1,Term2):-Term1\==Term2.
intern_term_lt(Term1,Term2):-Term1@<Term2.
intern_term_le(Term1,Term2):-Term1@=<Term2.
intern_term_gt(Term1,Term2):-Term1@>Term2.
intern_term_ge(Term1,Term2):-Term1@>=Term2.

% - Special unification and comparison predicates

intern_unify_with_occurs_check(Term1,Term2):-
    unify_with_occurs_check(Term1,Term2).

intern_variantOf(Term1,Term2):-
    Term1=@=Term2.

intern_not_variantOf(Term1,Term2):-
    Term1\=@=Term2.

intern_subsumes_term(Genric,Specific):-
    subsumes_term(Genric,Specific).
    
intern_term_subsumer(Special1,Special2,General):-
    term_subsumer(Special1,Special2,General).

intern_unifiable(X,Y,Unifier):-
    unifiable(X,Y,Unifier).
    
% - more

intern_unify(Term1,Term2):-
    Term1=Term2.
    
intern_not_unify(Term):-
    \+Term.
    
intern_not_unify(Term1,Term2):-
    Term1\=Term2.
    
intern_compare(Order,Term1,Term2):-
    compare(Order,Term1,Term2).

intern_save_unifyable(Term1,Term2):-
    ?=(Term1,Term2).

% Meta-Call Predicates

% Built-in list operations

intern_is_list(Term):-is_list(Term).
intern_length(List,Int):-length(List,Int).
intern_sort(List,Sorted):-sort(List,Sorted).
intern_msort(List,Sorted):-msort(List,Sorted).
intern_keysort(List,Sorted):-keysort(List,Sorted).

% Arithmetic

% - Special purpose integer arithmetic

% - General purpose arithmetic

intern_lt(A,B):-A<B.    
intern_le(A,B):-A=<B.    
intern_gt(A,B):-A>B.
intern_ge(A,B):-A>=B.
intern_eq(A,B):-A=:=B.
intern_neq(A,B):-A=\=B.
intern_is(A,B):-A is B.

intern_or(A,_B):-A.
intern_or(_A,B):-B.

intern_ifthen(If,Then):-If,!,Then.
