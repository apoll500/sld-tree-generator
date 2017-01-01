% -----------------------------------------------------------------------------+
%                                                                              |
%  loader.pl                                                                   |
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
:-module(loader,[
         load_program/1,
         load_program/3,
         load_program_intern/1,
         load_program_intern/3,
         load_program_A/3,
         clause_ref/3,
         print_all_clauses/1,
         print_all_clauses/0,
         print_all_clauses_html/1,
         print_all_clauses_txt/1,
         delete_clauses/0,
         print_all_clauses_intern/0
        ]).

:-nb_setval(refList,[]).
:-nb_setval(refList_intern,[]).

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% Einlesen des Eingabeprogramms
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% --------------------------------------------------------------------
% Programm Klauseln aus Datei einlesen.
% --------------------------------------------------------------------
load_program(Filename):-
    load_program(Filename,_,_).

load_program(Filename,ClauseCount):-
    load_program(Filename,ClauseCount,_).

load_program(Filename,ClauseCount,RefList):-
    delete_clauses,
    open(Filename,read,Stream),
    load_clauses(Stream,ClauseCount,1,RefList),
    nb_setval(refList,RefList),
    close(Stream).

load_program_intern(Filename):-
    load_program_intern(Filename,_,_).

load_program_intern(Filename,ClauseCount):-
    load_program_intern(Filename,ClauseCount,_).

load_program_intern(Filename,ClauseCount,RefList):-
    delete_clauses_intern,
    open(Filename,read,Stream),
    load_clauses_intern(Stream,ClauseCount,100000,RefList),
    nb_setval(refList_intern,RefList),
    close(Stream).
	
load_program_A(Program,ClauseCount,RefList):-
    open('mod/builtin.pl',read,Stream0),
    load_clauses_intern(Stream0,_ClauseCount0,100000,RefList_i),
    nb_setval(refList_intern,RefList_i),
    close(Stream0),
    %delete_clauses,
    atom_to_chars(Program,ProgC),
    open_chars_stream(ProgC,Stream),
    load_clauses(Stream,ClauseCount,1,RefList),
    nb_setval(refList,RefList),
    close(Stream).

% --------------------------------------------------------------------
% Klausel aus dem Input Stream einlesen.
% --------------------------------------------------------------------
% +Stream:      Input Stream.
% -ClauseCount: Anzahl eingelesener Klauseln.
% -RefList:     Referenzenliste aller eingelesenen Klauseln.
% --------------------------------------------------------------------
load_clauses(Stream,ClauseCount,CID,RefList):-
    \+at_end_of_stream(Stream),
    read_term(Stream,Term,[variable_names(VN)]),
    term_variables(Term,ListOfVariableNames),
    Term\==end_of_file,
    wa:assertz(Term,Ref),
    solve(VN),
    CID1 is CID+1,
    load_clauses(Stream,C1,CID1,R1),
    !,
    ClauseCount is C1+1,
    RefList=[[Ref,ListOfVariableNames,CID]|R1].
load_clauses(_Stream,ClauseCount,_,RefList):-
    %at_end_of_stream(Stream),
    RefList=[],
    ClauseCount=0.

load_clauses_intern(Stream,ClauseCount,CID,RefList):-
    \+at_end_of_stream(Stream),
    read_term(Stream,Term,[variable_names(VN)]),
    term_variables(Term,ListOfVariableNames),
    Term\==end_of_file,
    wi:assertz(Term,Ref),
    solve(VN),
    CID1 is CID+1,
    load_clauses_intern(Stream,C1,CID1,R1),
    !,
    ClauseCount is C1+1,
    RefList=[[Ref,ListOfVariableNames,CID]|R1].
load_clauses_intern(_Stream,ClauseCount,_,RefList):-
    %at_end_of_stream(Stream),
    RefList=[],
    ClauseCount=0.
	
% --------------------------------------------------------------------
% Alle Klauseln loeschen.
% --------------------------------------------------------------------
delete_clauses:-
    nb_getval(refList,RefList),
    delete_clauses(RefList),
    nb_setval(refList,[]).
    
delete_clauses([]).
delete_clauses([[Ref,_VN,_ID]|Refs]):-
    wa:erase(Ref),
    delete_clauses(Refs).

delete_clauses_intern:-
    nb_getval(refList_intern,RefList),
    delete_clauses_intern(RefList),
    nb_setval(refList_intern,[]).
    
delete_clauses_intern([]).
delete_clauses_intern([[Ref,_VN,_ID]|Refs]):-
    wi:erase(Ref),
    delete_clauses_intern(Refs).
% --------------------------------------------------------------------
% Klausel-Referenz zu Klausel-ID ermitteln.
% --------------------------------------------------------------------
clause_ref([],_ID,'not found').%:-write(ID),write(' ID not found.'),nl.
clause_ref([[Ref,_CVars,ID]|_Rs],ID,Ref).
clause_ref([[_CRef,_CVars,CID]|Rs],ID,Ref):-
    \+CID==ID,
    clause_ref(Rs,ID,Ref).

% --------------------------------------------------------------------
% Alle Klauseln ausgeben.
% --------------------------------------------------------------------
print_all_clauses:-
    nb_getval(refList,RefList),
    print_all_clauses(RefList).

print_all_clauses([]).
print_all_clauses([[Ref,VN,CC]|Refs]):-
    wa:clause(Head,Body,Ref),
    write(CC),write(')'),nl,
    write('\t'),write(Head),write(':-'),nl,
    write('\t'),write('\t'),write(Body),nl,
    write('\t'),write('VariableNames: '),write(VN),nl,nl,
    print_all_clauses(Refs).

print_all_clauses_intern:-
    nb_getval(refList_intern,RefList),
    print_all_clauses_intern(RefList).
    
print_all_clauses_intern([]).
print_all_clauses_intern([[Ref,VN,CC]|Refs]):-
    wi:clause(Head,Body,Ref),
    write(CC),write(')'),nl,
    write('\t'),write(Head),write(':-'),nl,
    write('\t'),write('\t'),write(Body),nl,
    write('\t'),write('VariableNames: '),write(VN),nl,nl,
    print_all_clauses_intern(Refs).
    
% --------------------------------------------------------------------
% Alle Klauseln ausgeben. TXT
% --------------------------------------------------------------------
print_all_clauses_txt([[Ref,VN,CC]|Refs]):-
        print_all_clauses_txt([[Ref,VN,CC]|Refs],'',0).

print_all_clauses_txt([],_,_).
print_all_clauses_txt([[Ref,VN,CC]|Refs],LastName,LastArity):-
    wa:clause(Head,Body,Ref),
    functor(Head,Name,Arity),
    print_br_txt(Name,Arity,LastName,LastArity),
    term_variables(Head:-Body,Variables),
    restoreVariables(Variables,VN),
    write('$'),
    write(CC),write(')'),
    write('      '),write(Head),
    print_body_txt_first(Body),
    nl,nl,
    print_all_clauses_txt(Refs,Name,Arity).

print_br_txt(Name,Arity,LastName,LastArity):-
    Name=LastName,
    Arity=LastArity.
print_br_txt(Name,Arity,LastName,_LastArity):-
    \+Name=LastName,
    %nl,
    write('      % '),
    write(Name),write('/'),write(Arity),
    %write(' -----------------------------------------------------------------------'),
    nl,nl.
print_br_txt(Name,Arity,_LastName,LastArity):-
    \+Arity=LastArity,
    %nl,
    write('      % '),
    write(Name),write('/'),write(Arity),
    %write(' -----------------------------------------------------------------------'),
    nl,nl.

print_body_txt_first(true):-
    write('.').
print_body_txt_first(Body):-
    write(':-'),nl,
    print_body_txt(Body),
    write('.').

print_body_txt((G1,R)):-
    write('      '),write('      '),write(G1),write(','),nl,
    print_body_txt(R).
print_body_txt(Body):-
    \+getFGTest(Body),
    write('      '),write('      '),write(Body).

% --------------------------------------------------------------------
% Alle Klauseln ausgeben. HTML
% --------------------------------------------------------------------
print_all_clauses_html([[Ref,VN,CC]|Refs]):-
    print_all_clauses_html([[Ref,VN,CC]|Refs],'',0).

print_all_clauses_html([],_,_).
print_all_clauses_html([[Ref,VN,CC]|Refs],LastName,LastArity):-
    wa:clause(Head,Body,Ref),
    functor(Head,Name,Arity),
    print_br_html(Name,Arity,LastName,LastArity),
    term_variables(Head:-Body,Variables),
    restoreVariables(Variables,VN),
    write('<span class="cl_number">'),
    write(CC),write(')'),
    write('</span>'),
    write('<br>'),
    write('&nbsp;&nbsp;&nbsp;&nbsp;'),write(Head),write(':-'),write('<br>'),
    print_body_html(Body),
    %write('\t'),write('\t'),write(Body),
    write('.'),write('<br>'),
    print_all_clauses_html(Refs,Name,Arity).

print_br_html(Name,Arity,LastName,LastArity):-
    Name=LastName,
    Arity=LastArity.
print_br_html(Name,Arity,LastName,_LastArity):-
    \+Name=LastName,
    write('<br>'),write('<br>'),
    write('&nbsp;&nbsp;&nbsp;&nbsp;'),
    write('<span class="comment">'),
    write('% '),write(Name),write('/'),write(Arity),
    write('</span>'),
    write('<br>').
print_br_html(Name,Arity,_LastName,LastArity):-
    \+Arity=LastArity,
    write('<br>'),write('<br>'),
    write('&nbsp;&nbsp;&nbsp;&nbsp;'),
    write('<span class="comment">'),
    write('% '),write(Name),write('/'),write(Arity),
    write('</span>'),
    write('<br>').

print_body_html((G1,R)):-
    write('&nbsp;&nbsp;&nbsp;&nbsp;'),
    write('&nbsp;&nbsp;&nbsp;&nbsp;'),write(G1),write(','),write('<br>'),
    print_body_html(R).
print_body_html(Body):-
    \+getFGTest(Body),
    write('&nbsp;&nbsp;&nbsp;&nbsp;'),
    write('&nbsp;&nbsp;&nbsp;&nbsp;'),write(Body).

getFGTest((_,_)).

restoreVariables([],[]).
restoreVariables([V|Vs],[N|Ns]):-
    V=N,
    restoreVariables(Vs,Ns).
    
