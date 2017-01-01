% -----------------------------------------------------------------------------+
%                                                                              |
%  treePrint.pl                                                                |
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
:-module(treePrint,[print_tree/1,
            treePrintText/1,
            treePrintText_st/1,
            treePrintText_ex/1,
            treePrintText/2,
            treePrintText_st/2,
            treePrintText_ex/2,
            printTree_compact/1,
            printTree_compact/2]).

:-dynamic vline/2.

% --------------------------------------------------------------------
% Baum ausgeben.
% --------------------------------------------------------------------

% --------------------------------------------------------------------
% print_tree1/1
% --------------------------------------------------------------------
print_tree(T):-
    treeConvertVars(T,T1),
    write(T1),nl.

% --------------------------------------------------------------------
% Baum formatiert ausgeben mit Einrueckung und Linien.
% Kompakte Version mit Unicode-Zeichen
% --------------------------------------------------------------------

printTree_compact(T):-
    printTree_compact(T,-1).

printTree_compact(T,C):-
    treeConvertVars(T,T1),
    retractall(vline(_,_)),
    preprint_tree3(T1,0),
    printTree_compact(T1,0,C),!,
    retractall(vline(_,_)).

printTree_compact(tree(node(id(ID,_),goal(G),cl(0,variant(true)),_U,_P,_N),T),D,C):-
    \+G='-',
    write('     ?- '),write(G),write('.'),mark(ID,C),nl,
    D1 is D+1,
    printTree_compact_printSubtrees(T,D1,C).
printTree_compact(tree(node(id(ID,_),goal('-'),cl(0,variant(true)),_U,_P,_N),T),D,C):-
    identic(0,D,ID),
    put(9494),put(9472),put(9472),put(9472),put(9472),
    write('...'),mark(ID,C),nl,
    D1 is D+1,
    printTree_compact_printSubtrees(T,D1,C).
printTree_compact(tree(node(id(ID,_),goal(G),cl(CID,variant(_V)),_U,_,_N),T),D,C):-
    CID>0,
    identic(0,D,ID),
    moveLeft,
    Dx is D,IDx is ID,
    test_vline(Dx,IDx,B),
    (B=1->put(9504);put(9494)),
    put(9472),put(9472),put(9472),put(9472),write(' ?- '),write(G),write('.'),
    mark(ID,C),nl,
    D1 is D+1,
    printTree_compact_printSubtrees(T,D1,C).

identic(_,0,_).
identic(X,D,ID):-
    D>0,
    X1 is X+1,
    tab(5),
    test_vline(X1,ID,B),
    (B=1->put(9475);put(' ')),
    D1 is D-1,
    identic(X1,D1,ID).


% --------------------------------------------------------------------
% print_trees3/3
% --------------------------------------------------------------------
printTree_compact_printSubtrees([],_,_).
printTree_compact_printSubtrees([T|Ts],D,C):-
    printTree_compact(T,D,C),
    printTree_compact_printSubtrees(Ts,D,C).


% --------------------------------------------------------------------
% Baum formatiert ausgeben mit Einrueckung und Linien.
% Version mit ASCII-Zeichen.
% --------------------------------------------------------------------

% --------------------------------------------------------------------
% treePrintText/1
% --------------------------------------------------------------------
treePrintText(T):-
    treePrintText(T,-1).

treePrintText_st(T):-
    treePrintText_st(T,-1).

treePrintText_ex(T):-
    treePrintText_ex(T,-1).

% --------------------------------------------------------------------
% treePrintText/2
% --------------------------------------------------------------------
treePrintText(T,C):-
    treePrintText_ex(T,C).

treePrintText_st(T,C):-
    treeConvertVars(T,T1),
    retractall(vline(_,_)),
    preprint_tree3(T1,0),
    print_tree3(T1,0,C),!,
    retractall(vline(_,_)).

treePrintText_ex(T,C):-
    treeConvertVars(T,T1),
    retractall(vline(_,_)),
    preprint_tree3(T1,0),
    print_tree3_ex(T1,0,C),!,
    retractall(vline(_,_)).

% --------------------------------------------------------------------
% print_tree3/3
% --------------------------------------------------------------------
print_tree3(tree(node(id(ID,_),goal(G),cl(0,variant(true)),_U,_P,_N),T),D,C):-
    \+G='-',
    identi(0,D,ID),write('root ?- '),write(G),write('.'),mark(ID,C),nl,
    D1 is D+1,
    print_trees3(T,D1,C).
print_tree3(tree(node(id(ID,_),goal('-'),cl(0,variant(true)),_U,_P,_N),T),D,C):-
    identi(0,D,ID),write('\\'),nl,
    identi(0,D,ID),write(' \\'),nl,
    identi(0,D,ID),write('  ...'),mark(ID,C),nl,
    D1 is D+1,
    print_trees3(T,D1,C).
print_tree3(tree(node(id(ID,_),goal(G),cl(CID,variant(V)),U,_,N),T),D,C):-
    CID>0,
    identi(0,D,ID),write('\\'),nl,
    identi(0,D,ID),write(' \\'),write('Klausel ('),write(CID),write('): '),write(V),nl,
    identi(0,D,ID),write('  \\'),write('Unifikator: '),write(U),nl,
    identi(0,D,ID),write('   \\'),write('Verwendete Variablen: '),write(N),nl,
    identi(0,D,ID),write('    \\'),nl,
    identi(0,D,ID),write('     ?- '),write(G),write('.'),
    %write(' '),write(ID),write(' '),write(A),write(' '),write(B),
    mark(ID,C),nl,
    D1 is D+1,
    print_trees3(T,D1,C).

% --------------------------------------------------------------------
% print_trees3/3
% --------------------------------------------------------------------
print_trees3([],_,_).
print_trees3([T|Ts],D,C):-
    print_tree3(T,D,C),
    print_trees3(Ts,D,C).

% --------------------------------------------------------------------
% mark/2
% --------------------------------------------------------------------
mark(ID,ID):-
    write(' <------(selected)').
mark(_,_).

% --------------------------------------------------------------------
% identi/3
% --------------------------------------------------------------------
identi(_,0,_).
identi(X,D,ID):-
    D>0,
    tab(5),X1 is X+1,
    test_vline(X1,ID,B),
    (B=1->write('|');write(' ')),
    D1 is D-1,
    identi(X1,D1,ID).

% --------------------------------------------------------------------
% Baum formatiert ausgeben mit Einrueckung und Linien.
% Version mit Unicode-Zeichen und Farben.
% --------------------------------------------------------------------

% --------------------------------------------------------------------
% print_tree3_ex/3
% --------------------------------------------------------------------
print_tree3_ex(tree(node(id(ID,_),goal(G),cl(0,variant(true)),_U,_P,_N),T),D,C):-
    \+G='-',
    identi0_ex(0,D,ID),
    color(3),
    write('root '),
    color(2),
    write('?- '),write(G),write('.'),mark_ex(ID,C),nl,
    color(7),
    D1 is D+1,
    print_trees3_ex(T,D1,C).
print_tree3_ex(tree(node(id(ID,_),goal('-'),cl(0,variant(true)),_U,_P,_N),T),D,C):-
    identi0_ex(0,D,ID),put(9586),nl,
    identi0_ex(0,D,ID),write(' '),put(9586),nl,
    identi0_ex(0,D,ID),write('  ...'),mark_ex(ID,C),nl,
    put(27),put('['),write('37'),put('m'),
    color(7),
    D1 is D+1,
    print_trees3_ex(T,D1,C).
print_tree3_ex(tree(node(id(ID,_),goal(G),cl(CID,variant(V)),U,_,N),T),D,C):-
    CID>0,
    identi0_ex(0,D,ID),put(9586),nl,
    identi0_ex(0,D,ID),write(' '),put(9586),color(7),write('Klausel ('),write(CID),write('): '),write(V),nl,
    identi0_ex(0,D,ID),write('  '),put(9586),color(7),write('Unifikator: '),write(U),nl,
    identi0_ex(0,D,ID),write('   '),put(9586),color(7),write('Verwendete Variablen: '),write(N),nl,
    identi0_ex(0,D,ID),write('    '),put(9586),nl,
    identi0_ex(0,D,ID),color(2),write('     ?- '),write(G),write('.'),
    mark_ex(ID,C),nl,
    color(7),
    D1 is D+1,
    print_trees3_ex(T,D1,C).

% --------------------------------------------------------------------
% print_trees3_ex/3
% --------------------------------------------------------------------
print_trees3_ex([],_,_).
print_trees3_ex([T|Ts],D,C):-
    print_tree3_ex(T,D,C),
    print_trees3_ex(Ts,D,C).

% --------------------------------------------------------------------
% mark_ex/2
% --------------------------------------------------------------------
mark_ex(ID,ID):-
    color(1),
    write(' <------(selected)').
mark_ex(_,_).

% --------------------------------------------------------------------
% identi/3
% --------------------------------------------------------------------
identi0_ex(X,D,ID):-
    color(3),
    identi_ex(X,D,ID).

identi_ex(_,0,_).
identi_ex(X,D,ID):-
    D>0,
    tab(5),X1 is X+1,
    test_vline(X1,ID,B),
    (B=1->put(9474);write(' ')),
    D1 is D-1,
    identi_ex(X1,D1,ID).

% --------------------------------------------------------------------
% test_vline/3
% --------------------------------------------------------------------
test_vline(X,ID,B):-
    Y is ID+1,
    vline(X0,Y),
    X0=X,
    B=1.
test_vline(X,ID,B):-
    Y is ID+1,
    vline(X0,Y),
    X0<X,
    B=0.
test_vline(X,ID,B):-
    Y is ID+1,
    vline(X0,Y),
    X0>X,
    test_vline(X,Y,B).
test_vline(_X,ID,B):-
    Y is ID+1,
    \+vline(_,Y),
    B=0.

% --------------------------------------------------------------------
% preprint_tree3/2
% --------------------------------------------------------------------
preprint_tree3(tree(node(id(ID,_),_,_,_,_,_),T),D):-
    asserta(vline(D,ID),_),
    D1 is D+1,
    preprint_trees3(T,D1).

% --------------------------------------------------------------------
% preprint_trees3/2
% --------------------------------------------------------------------
preprint_trees3([],_).
preprint_trees3([T|Ts],D):-
    preprint_tree3(T,D),
    preprint_trees3(Ts,D).
