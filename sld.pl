% -----------------------------------------------------------------------------+
%                                                                              |
%  sld.pl                                                                      |
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
:-set_prolog_flag(gc,false).

setup:-
    \+exists_file('extern/processing/processing.js'),
    ['extern/download'].
setup.

:-setup.

% ------------------------------------------------------------------------------
% loading modules
% ------------------------------------------------------------------------------
% eigene Module
:-use_module('mod/loader').
:-use_module('mod/tree_dfs').
:-use_module('mod/tree/tree').
:-use_module('mod/sld_node').
:-use_module('mod/helpers').
:-use_module('mod/terminal').
:-use_module('mod/ui/kbmode').
:-use_module('mod/ui/events').
:-use_module('mod/tree/treeConvertVars').
:-use_module('mod/tree/treePrint').
:-use_module('mod/tree/json').
:-use_module('web/interface').

% ------------------------------------------------------------------------------
% some examples
% ------------------------------------------------------------------------------
%
%   1) Programm laden.
%          ?- [sld].
%
%   2) loading clauses for built-in predicates:
%          ?- loadbi.
%
%   3) Das Eingabeprogramm laden.
%          ?- load_program('test.pl').
%
%   4) SLD-Baeume berechnen.
%          ?- sld_tree('a(1,X)',T),print_tree(T).
%          ?- sld_tree('z(R),z(S),g(R,S)',T),print_tree(T).
%
%   5) Interactive mode:
%          ?- run_goal('a(2,B)',3).
%
r1:-run_goal('a(2,B)',3).
r0:-run_goal('z(R),z(S),g(R,S)',3).

t1:-sld_tree('a(1,B)',T),treePrintText(T).
t2:-sld_tree('a(2,B)',T),treePrintText(T).
t3:-sld_tree('p(2)',T),treePrintText(T).
t4:-sld_tree('p(0)',T),treePrintText(T).
t5:-sld_tree('p(X)',T),treePrintText(T).
t6:-sld_tree('a(X,1)',T),treePrintText(T).
t7:-sld_tree('a(X,2)',T),treePrintText(T).
t8:-sld_tree('a(X,X)',T),treePrintText(T).
t9:-sld_tree('a(X,Y)',T),treePrintText(T).
t0:-sld_tree('z(R),z(S),g(R,S)',T),treePrintText(T).

% ------------------------------------------------------------------------------
% this starts swi-prologs http server
% ------------------------------------------------------------------------------
start:-
    server(5000),
    write('% SWI-Prolog http server started.\n'),
    write('% Please open http://localhost:5000/sld/ in your favourite browser.').

% ------------------------------------------------------------------------------
% loading clauses for built-in predicates
% ------------------------------------------------------------------------------
loadbi:-
    load_program_intern('mod/builtin.pl').

% ------------------------------------------------------------------------------
% run_goal/2
% run_goal(+GoalAtom,+Depth)
%
% Calculates a sld-tree and starts the interactive mode.
% GoalAtom is a atom which contains the query, f.e. 'p(A)'.
% Depth is the maximal number of levels which are calculated.
% ------------------------------------------------------------------------------
run_goal(GoalAtom,Depth):-
    sld_tree(GoalAtom,Tree,Depth),
    run(Tree,id(0,0),Depth).

% ------------------------------------------------------------------------------
% sld_root/2
% sld_root(+GoalAtom,-RootNode)
%
% ------------------------------------------------------------------------------
sld_root(GoalAtom,RootNode):-
    sld_root(GoalAtom,0,RootNode).

sld_root(GoalAtom,Request,RootNode):-
    atom_to_term(GoalAtom,GoalTerm,B),
    varlist(B,L),
    sld_node:repvars0(GoalTerm,L,[],VNames),
    RootNode=node(id(0,Request),goal(GoalTerm),cl(0,variant(true)),[],[loc(pid(0,Request),0),[p(goal(GoalTerm),VNames,[])]],VNames).

% ------------------------------------------------------------------------------
% sld_root/4
% sld_root(+GoalAtom,-RootNode)
%
% ------------------------------------------------------------------------------
sld_root(CurrentNodeId,Request,Tree,NewRootNode):-
    fullNodePath(CurrentNodeId,Tree,FullPath),
    FullPath=[p(goal(Goal),Vars,_)|_],
    \+Goal='-',
    NewRootNode=node(id(0,Request),goal(Goal),cl(0,variant(true)),[],[loc(pid(0,Request),0),FullPath],Vars).

sld_root(CurrentNodeId,Request,Tree,NewRootNode):-
    fullNodePath(CurrentNodeId,Tree,FullPath),
    FullPath=[p(goal(Goal),_,_)|_],
    Goal='-',
    sld_root_up(CurrentNodeId,Request,Tree,NewRootNode).

% ------------------------------------------------------------------------------
% sld_root_up/3
% ------------------------------------------------------------------------------
sld_root_up(CurrentNodeId,Request,Tree,NewRootNode):-
    fullNodePath(CurrentNodeId,Tree,[_|FullPath]),
    FullPath=[p(goal(Goal),Vars,_)|_],
    NewRootNode=node(id(0,Request),goal(Goal),cl(0,variant(true)),[],[loc(pid(0,Request),0),FullPath],Vars).
    
sld_root_up(CurrentNodeId,Request,Tree,NewRootNode):-
    fullNodePath(CurrentNodeId,Tree,FullPath),
    FullPath=[p(goal(Goal),Vars,_)],
    NewRootNode=node(id(0,Request),goal(Goal),cl(0,variant(true)),[],[loc(pid(0,Request),0),FullPath],Vars).

% ------------------------------------------------------------------------------
% Baum als verschachtelten Term berechnen
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% sld_tree/2
% ------------------------------------------------------------------------------
sld_tree(GoalAtom,Tree):-
    sld_root(GoalAtom,RootNode),
    nb_getval(refList,R),
    nb_getval(refList_intern,RI),
    subTree(RootNode,R,RI,Tree,_).

% ------------------------------------------------------------------------------
% sld_tree/3
% ------------------------------------------------------------------------------
sld_tree(GoalAtom,Tree,Depth):-
    sld_tree(GoalAtom,0,Tree,Depth).

sld_tree(GoalAtom,Request,Tree,Depth):-
    sld_root(GoalAtom,Request,RootNode),
    nb_getval(refList,R),
    nb_getval(refList_intern,RI),
    subTree(RootNode,R,RI,Tree,Depth,Request),
    (var(Depth)->node:maxDepth(Depth);true).

% ------------------------------------------------------------------------------
% sld_tree/4
% ------------------------------------------------------------------------------
%sld_tree(CurrentNodeId,Request,Tree,Depth,NewTree):-
%        sld_tree(CurrentNodeId,0,Tree,Depth,NewTree).
    
% ------------------------------------------------------------------------------
% sld_tree/5
% ------------------------------------------------------------------------------
sld_tree(CurrentNodeId,Request,Tree,Depth,NewTree):-
    sld_root(CurrentNodeId,Request,Tree,RootNode),
    nb_getval(refList,R),
    nb_getval(refList_intern,RI),
    subTree(RootNode,R,RI,NewTree,Depth,Request),
    (var(Depth)->node:maxDepth(Depth);true).

% ------------------------------------------------------------------------------
% sld_tree_up/4
% ------------------------------------------------------------------------------
sld_tree_up(CurrentNodeId,Request,Tree,Depth,NewTree):-
    sld_root_up(CurrentNodeId,Request,Tree,RootNode),
    nb_getval(refList,R),
    nb_getval(refList_intern,RI),
    subTree(RootNode,R,RI,NewTree,Depth,Request),
    (var(Depth)->node:maxDepth(Depth);true).

% ------------------------------------------------------------------------------
% check_goal/2
% ------------------------------------------------------------------------------
check_goal(Node,[[Ref,_,_]|_Refs]):-
    Node=node(_,goal(Goal),_,_,_,_),
    test_goal(Goal,Ref).

check_goal(Node,[[_Ref,_,_]|Refs]):-
    check_goal(Node,Refs).

% ------------------------------------------------------------------------------
% Programm laden und Baum berechnen
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% sld_tree_lp/3
% ------------------------------------------------------------------------------
sld_tree_lp(ProgramFilename,GoalAtom,Tree):-
    load_program(ProgramFilename,_,_),
    sld_tree(GoalAtom,Tree).

% ------------------------------------------------------------------------------
% sld_tree_lp/4
% ------------------------------------------------------------------------------
sld_tree_lp(ProgramFilename,GoalAtom,Tree,Depth):-
    load_program(ProgramFilename,_,_),
    sld_tree(GoalAtom,Tree,Depth).
