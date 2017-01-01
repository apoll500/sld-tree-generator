% -----------------------------------------------------------------------------+
%                                                                              |
%  next_child.pl                                                               |
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
:-module(next_child,[nextChild/8]).

% ------------------------------------------------------------------------------
% generating the next sibling
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% nextChild/8
% ------------------------------------------------------------------------------
nextChild(Node,PNode,Child,Refs,IRefs,PID,ID,Request):-
    Node=node(_,_,cl(CID,_),_,_,_),
    CID<100000,
    clause_ref(Refs,CID,Ref),
    clause_ref(IRefs,CID,IRef),
    nextChild_1(PNode,Child,Refs,Ref,IRefs,IRef,PID,ID,Request).
    
nextChild(Node,PNode,Child,Refs,IRefs,PID,ID,Request):-
    Node=node(_,_,cl(CID,_),_,_,_),
    CID>99999,
    clause_ref(Refs,CID,Ref),
    clause_ref(IRefs,CID,IRef),
    nextChild_1(PNode,Child,Refs,Ref,IRefs,IRef,PID,ID,Request).

% ------------------------------------------------------------------------------
% nextChild_1/9
% ------------------------------------------------------------------------------
nextChild_1(_,'end_of_nodes',[],_,[],_,_,_,_):-!,fail.

nextChild_1(PNode,Child,[],_,[[IRef,_,_]|IRefs],IRef,PID,ID,Request):-
    PNode=node(id(PID,_),goal(Goal),_,_,[loc(_,Depth)|_],UsedVars),
    Depth1 is Depth+1,
    sld_node(Goal,[],IRefs,UsedVars,Child,PID,ID,Depth1,Request).
    
nextChild_1(PNode,Child,[],Ref,[_|IRefs],IRef,PID,ID,Request):-
    nextChild_1(PNode,Child,[],Ref,IRefs,IRef,PID,ID,Request).
    
nextChild_1(PNode,Child,[[Ref,_,_]|Refs],Ref,IRefs,_IRef,PID,ID,Request):-
    PNode=node(id(PID,_),goal(Goal),_,_,[loc(_,Depth)|_],UsedVars),
    Depth1 is Depth+1,
    sld_node(Goal,Refs,IRefs,UsedVars,Child,PID,ID,Depth1,Request).
    
nextChild_1(PNode,Child,[_|Refs],Ref,IRefs,IRef,PID,ID,Request):-
    nextChild_1(PNode,Child,Refs,Ref,IRefs,IRef,PID,ID,Request).

