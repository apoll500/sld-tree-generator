% -----------------------------------------------------------------------------+
%                                                                              |
%  kbmode.pl                                                                   |
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
:-module(kbmode,[run/1,run/3]).

% ------------------------------------------------------------------------------
% run/1
% ------------------------------------------------------------------------------
% run(GoalAtom)
% This is the entry point for the interactive mode (prolog text-interface)
% GoalAtom is an atom of the goal to run on the previously loaded program.
% ------------------------------------------------------------------------------
run(GoalAtom):-
    sld_tree(GoalAtom,T),
    run(T,0,3).

% ------------------------------------------------------------------------------
% run/2
% ------------------------------------------------------------------------------
% run(Tree,CurrentNode,Depth)
% This is the 'main-loop' for the interactive mode.
% This predicate should be called by run/1.
% ------------------------------------------------------------------------------
run(Tree,CurrentNode,Depth):-
    color(7),
    write('Input command: '),
    inkey(Command),
    bgcolor(0),cls,
    nl,write('Input command: '),
    write(Command),
    kb_event(event(Command,Tree,CurrentNode),Result,Depth,NewTree,NewCurrentNode),
    !,
    (Result==end_program->true;run(NewTree,NewCurrentNode,Depth)).

% --------------------------------------------------------------------
% Single-Event:
% Behandlung eines einzelnen Tastendrucks.
% --------------------------------------------------------------------

% --------------------------------------------------------------------
% kb_event/2
% --------------------------------------------------------------------
kb_event(event(Command,Tree,CurrentNode),Result,Depth,NewTree,NewCurrentNode):-
    command(Command,Result,Tree,CurrentNode,Depth,NewTree,NewCurrentNode).

% --------------------------------------------------------------------
% Interaktiv
% --------------------------------------------------------------------
inkey(C):-
    get_single_char(C).

% --------------------------------------------------------------------
% Interaktiv
% --------------------------------------------------------------------

run_escape_seq([113|_],Tree,CurrentNode,_Result,_Depth,Tree,CurrentNode):-nl.
run_escape_seq([81|_],Tree,CurrentNode,_Result,_Depth,Tree,CurrentNode):-nl.
run_escape_seq([65,91,27|_],Tree,CurrentNode,_Result,_Depth,Tree,NewCurrentNode):-
    getPrevChildOfNode(CurrentNode,Tree,NewCurrentNode),
    write(' (up)'),nl,
    NewCurrentNode=id(NodeId,_),
    treePrintText_ex(Tree,NodeId).
run_escape_seq([66,91,27|_],Tree,CurrentNode,_Result,_Depth,Tree,NewCurrentNode):-
    getNextChildOfNode(CurrentNode,Tree,NewCurrentNode),
    write(' (down)'),nl,
    NewCurrentNode=id(NodeId,_),
    treePrintText_ex(Tree,NodeId).
run_escape_seq([67,91,27|_],Tree,CurrentNode,_Result,_Depth,Tree,NewCurrentNode):-
    getFirstChildOfNode(CurrentNode,Tree,NewCurrentNode),
    write(' (right)'),nl,
    NewCurrentNode=id(NodeId,_),
    treePrintText_ex(Tree,NodeId).
run_escape_seq([68,91,27|_],Tree,CurrentNode,_Result,_Depth,Tree,NewCurrentNode):-
    getPidOfNode(CurrentNode,Tree,NewCurrentNode),
    write(' (left)'),nl,
    NewCurrentNode=id(NodeId,_),
    treePrintText_ex(Tree,NodeId).
run_escape_seq(S,Tree,CurrentNode,Result,Depth,NewTree,NewCurrentNode):-
    write('>>'),
    inkey(C),
    write(C),
    S1=[C|S],%write(S1),
    run_escape_seq(S1,Tree,CurrentNode,Result,Depth,NewTree,NewCurrentNode).

% c -> C
command(C,R,Tree,CurrentNode,Depth,NewTree,NewCurrentNode):-
    C>96,
    C<123,
    C1 is C-32,
    !,
    command(C1,R,Tree,CurrentNode,Depth,NewTree,NewCurrentNode).

% Escape
command(27,R,Tree,CurrentNode,Depth,NewTree,NewCurrentNode):-
    run_escape_seq([27],Tree,CurrentNode,R,Depth,NewTree,NewCurrentNode).

% C
command(67,_R,Tree,CurrentNode,_Depth,Tree,CurrentNode):-
    nl,write('  >> CurrentNode='),write(CurrentNode),nl.

% Help
command(72,_R,Tree,CurrentNode,_Depth,Tree,CurrentNode):-
    nl,
    write('----------------------------------------------'),nl,
    write('Tastatureingaben:'),nl,
    write('----------------------------------------------'),nl,
    write('<p> ....... Baum ausgeben.'),nl,
    write('<e> ....... Baum ausgeben (kompakt).'),nl,
    write('<left> .... zu erstem Kind navigieren.'),nl,
    write('<right> ... zu Elternknoten navigieren.'),nl,
    write('<up> ...... zu vorhergehendem Geschwisterknoten navigieren.'),nl,
    write('<down> .... zu naechstem Geschwisterknoten navigieren.'),nl,
    write('<b> ....... Baum ab ausgewaehltem Knoten neu berechnen.'),nl,
    write('<u> ....... Baum ab Elternknoten des ausgewaehlten Knotens neu berechnen.'),nl,
    write('<t> ....... Term ausgeben.'),nl,
    write('<d> ....... Pfad ausgeben.'),nl,
    write('<c> ....... Knotennummer ausgeben.'),nl,
    write('<r> ....... Wurzelknoten ausgeben.'),nl,
    write('<s> ....... Liste der Substitutionen (bis zum Ausgewaehlten Knoten) ausgeben.'),nl,
    write('<a> ....... Antwortsubstitution zum ausgewaehlten Knoten ausgeben.'),nl,
    write('<q> ....... Programm beenden.'),nl,
    write('<h> ....... help.'),nl,
    write('----------------------------------------------'),nl.

command(Command,_Result,Tree,CurrentNode,Depth,NewTree,NewCurrentNode):-
    \+Command=81,
    ui_event(event(Command,Tree,CurrentNode),Depth,NewTree,NewCurrentNode).

% Programm beenden Q.
command(81,end_program,Tree,CurrentNode,_Depth,Tree,CurrentNode).


