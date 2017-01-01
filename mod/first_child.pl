% -----------------------------------------------------------------------------+
%                                                                              |
%  first_child.pl                                                              |
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
:-module(first_child,[firstChild/8]).

% ------------------------------------------------------------------------------
% generating the first child of a node
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% firstChild/8
% ------------------------------------------------------------------------------
firstChild(Node,Child,_R,_RI,PID,ID,MaxDepth,Request):-
        ID>=1000,!,
        nonvar(MaxDepth),
        Node=node(_,goal(Goal),_,_,[loc(_,Depth)|_],UsedVars),
        \+Goal=='-',
        Depth=<MaxDepth,
        \+Goal=='true',
        \+Goal=='false',
        \+Goal=='fail',
        Depth1 is Depth+1,
        Child=node(id(ID,Request),goal('-'),cl(0,variant(true)),[],[loc(pid(PID,Request),Depth1)],UsedVars).
        
firstChild(Node,Child,R,RI,PID,ID,MaxDepth,Request):-
        nonvar(MaxDepth),
        Node=node(_,goal(Goal),_,_,[loc(_,Depth)|_],UsedVars),
        Depth<MaxDepth,
        Depth1 is Depth+1,
        sld_node(Goal,R,RI,UsedVars,Child,PID,ID,Depth1,Request).

% This creates the fail-node at the end of a failing branch.
firstChild(Node,Child,_R,_RI,PID,ID,MaxDepth,Request):-
        nonvar(MaxDepth),
        Node=node(_,goal(Goal),_,_,[loc(_,Depth)|_],UsedVars),
        Depth<MaxDepth,
        \+Goal=='true',
        \+Goal=='false',
        \+Goal=='fail',
        Depth1 is Depth+1,
        Child=node(id(ID,Request),goal('fail'),cl(0,variant(true)),[],[loc(pid(PID,Request),Depth1)],UsedVars).

% This creates the '...'-node at the end of an incomplete branch.
firstChild(Node,Child,_R,_RI,PID,ID,MaxDepth,Request):-
        nonvar(MaxDepth),
        Node=node(_,goal(Goal),_,_,[loc(_,Depth)|_],UsedVars),
        Depth=MaxDepth,
        \+Goal=='true',
        \+Goal=='false',
        \+Goal=='fail',
        Depth1 is Depth+1,
        Child=node(id(ID,Request),goal('-'),cl(0,variant(true)),[],[loc(pid(PID,Request),Depth1)],UsedVars).
