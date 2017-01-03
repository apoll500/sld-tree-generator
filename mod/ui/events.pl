% -----------------------------------------------------------------------------+
%                                                                              |
%  events.pl                                                                   |
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
:-module(user_event,[ui_event/1,ui_event/4]).

% ------------------------------------------------------------------------------
% Event-Handling fur durch Benutzer-Interaktion initiierte Events 
% ------------------------------------------------------------------------------

% ------------------------------------------------------------------------------
% ui_event/1
% ------------------------------------------------------------------------------
% Falls eine Liste von Events statt eines einzelnen Events angegeben ist.
ui_event([]).
ui_event([E|Es]):-
    ui_event(E),
    ui_event(Es).

% ------------------------------------------------------------------------------
% ui_event/1
% ------------------------------------------------------------------------------
% Handling single events
ui_event(event(65)):-
    about_txt.
% ui_event(event(99)):-
%        loader:nb_setval(refList,[]),
%        load.

% ------------------------------------------------------------------------------
% ui_event/1
% ------------------------------------------------------------------------------
ui_event(event(asciiTree,goal(Goal),program(Program),depth(Depth),_PC)):-
    load_program_A(Program,_,_),
    sld_tree(Goal,Tree,Depth),
    treePrintText_st(Tree),garbage_collect.
ui_event(event(jsonTree,goal(Goal),program(Program),depth(Depth),PC)):-
    load_program_A(Program,_,_),
    sld_tree(Goal,PC,Tree,Depth),
    treeToJson(Tree,Json),write(Json),garbage_collect.
ui_event(event(jsonParentTree,tree(Tree),node(CurrentNode),program(Program),depth(Depth),PC)):-
    load_program_A(Program,_,_),
    sld_tree_up(CurrentNode,PC,Tree,Depth,NewTree),
    treeToJson(NewTree,Json),write(Json),garbage_collect.
ui_event(event(jsonSubTree,tree(Tree),node(CurrentNode),program(Program),depth(Depth),PC)):-
    load_program_A(Program,_,_),
    sld_tree(CurrentNode,PC,Tree,Depth,NewTree),
    treeToJson(NewTree,Json),write(Json),garbage_collect.
ui_event(event(getClauseList,program(Program),_PC)):-
    load_program_A(Program,_,RefList),
    print_all_clauses_txt(RefList),garbage_collect.
ui_event(event(prologAnswer,tree(Tree),node(CurrentNode),_PC)):-
    fullSubst(CurrentNode,Tree,Subst),
    globalRootVariables(Tree,Variables),
    solution(Variables,Subst,Solution),
    write(Solution),garbage_collect.

% ------------------------------------------------------------------------------
% ui_event/4
% ------------------------------------------------------------------------------
% B: neu berechnen ab hier
ui_event(event(66,Tree,CurrentNode),Depth,NewTree,NewCurrentNode):-
    nl,
    sld_tree(CurrentNode,0,Tree,Depth,NewTree),
    rootNodeId(NewTree,NewCurrentNode),
    NewCurrentNode=id(NodeId,_),
    treePrintText_ex(NewTree,NodeId).
% D: print path of current node
ui_event(event(68,Tree,CurrentNode),_Depth,Tree,CurrentNode):-
    nl,
    fullNodePath(CurrentNode,Tree,FullPath),
    write(FullPath),nl.
% S: print substitution of current node
ui_event(event(83,Tree,CurrentNode),_Depth,Tree,CurrentNode):-
    nl,
    fullSubst(CurrentNode,Tree,Subst),
    write(Subst),nl.
% A: print solution
ui_event(event(65,Tree,CurrentNode),_Depth,Tree,CurrentNode):-
    nl,
    fullSubst(CurrentNode,Tree,Subst),
    globalRootVariables(Tree,Variables),
    solution(Variables,Subst,Solution),
    treeConvertVars(Solution,Solution1),
    write(Solution1),nl.
% P: print tree
ui_event(event(80,Tree,CurrentNode),_Depth,Tree,CurrentNode):-
    nl,
    CurrentNode=id(NodeId,_),
    treePrintText_ex(Tree,NodeId).
ui_event(event(69,Tree,CurrentNode),_Depth,Tree,CurrentNode):-
    nl,
    CurrentNode=id(NodeId,_),
    printTree_compact(Tree,NodeId).
% J: print tree
ui_event(event(74,Tree,CurrentNode),_Depth,Tree,CurrentNode):-
    nl,
    tree_to_json(Tree,Json),write(Json),nl.
% R: print root
ui_event(event(82,Tree,CurrentNode),_Depth,Tree,CurrentNode):-
    nl,
    root_node(Tree,RootNode),
    treeConvertVars(RootNode,RootNode1),
    write(RootNode1),nl.
% T: print term
ui_event(event(84,Tree,CurrentNode),_Depth,Tree,CurrentNode):-
    nl,
    print_tree(Tree).
% U: up
ui_event(event(85,Tree,id(0,0)),Depth,NewTree,NewCurrentNode):-
    nl,
    sld_tree_up(id(0,0),0,Tree,Depth,NewTree),
    rootNodeId(NewTree,NewCurrentNode),
    NewCurrentNode=id(NodeId,_),
    treePrintText_ex(NewTree,NodeId).
ui_event(event(85,Tree,CurrentNode),Depth,NewTree,NewCurrentNode):-
    \+CurrentNode=id(0,0),
    nl,
    getPidOfNode(CurrentNode,Tree,ParentNode),%write(CurrentNode),write(ParentNode),nl,
    sld_tree(ParentNode,0,Tree,Depth,NewTree),
    rootNodeId(NewTree,NewCurrentNode),
    NewCurrentNode=id(NodeId,_),
    treePrintText_ex(NewTree,NodeId).
%
ui_event(event(_,Tree,CurrentNode),_Depth,Tree,CurrentNode):-
    % unhandled event.
    format('(unknown event)~n').
%ui_event(_,_,_,_):-
%        format('(unknown event)~n').
%ui_event(_):-
%        format('(unknown event)~n').

% ------------------------------------------------------------------------------
% UI-Events:
% ------------------------------------------------------------------------------
about_txt:-
    format('sld-tree-generator:\nProgramm zum Anzeigen von SLD-Baeumen\n\n').
