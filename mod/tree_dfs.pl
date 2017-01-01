% -----------------------------------------------------------------------------+
%                                                                              |
%  tree_dfs.pl                                                                 |
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
:-module(tree_dfs,[subTree/5,
            subTree/6]).

:-use_module('subtree_concat').
:-use_module('first_child').
:-use_module('next_child').
:-use_module('null_child').
        
% ------------------------------------------------------------------------------
% Erzeugt den sld-Baum bis zur Tiefe MaxDepth.
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% subTree/5
% ------------------------------------------------------------------------------
% start
subTree(Node,R,RI,Tree,MaxDepth):-
    subTree(Node,R,RI,Tree,MaxDepth,0).

% ------------------------------------------------------------------------------
% subTree/6
% ------------------------------------------------------------------------------
subTree(Node,R,RI,Tree,MaxDepth,Request):-
    garbage_collect,
    firstChild(Node,Child,R,RI,0,1,MaxDepth,Request),
    subTreeN_concat(Node,'',down,Tree0),
    subTreeN_concat(Child,Tree0,down,Tree1),
    subTree(Child,Tree1,[[Node,0],['eol',0]],R,RI,Tree2,'start',1,MaxDepth,Request),
    term_to_atom(Tree,Tree2).

% ------------------------------------------------------------------------------
% subTree/10
% ------------------------------------------------------------------------------
% ende
subTree(_Node,Tree,[],_,_,Tree,_,_,_MaxDepth,_Request).

% nach unten (first child)
subTree(Node,Tree,NPath,R,RI,Tree1,S,ID,MaxDepth,Request):-
    \+S=='up',
    %ID<1000,
    ID2 is ID+1,
    firstChild(Node,Child,R,RI,ID,ID2,MaxDepth,Request),
    subTreeN_concat(Child,Tree,down,Tree0),
    subTree(Child,Tree0,[[Node,ID]|NPath],R,RI,Tree1,'down',ID2,MaxDepth,Request).
    
% nach rechts
subTree(Node,Tree,NPath,R,RI,Tree1,S,ID,MaxDepth,Request):-
    S='up',
    ID>=1000,
    ID2 is ID+1,
    NPath=[[PNode,PID],[_,_]|_],
    nextChild(Node,PNode,_,R,RI,PID,ID2,Request),
    nullChild(PNode,Child,PID,ID2,Request),
    subTreeN_concat(Child,Tree,right0,Tree0),
    subTree(Child,Tree0,NPath,R,RI,Tree1,'right',ID2,MaxDepth,Request).

% nach rechts
subTree(Node,Tree,NPath,R,RI,Tree1,_S,ID,MaxDepth,Request):-
    %S='right',
    ID>=1000,
    ID2 is ID+1,
    NPath=[[PNode,PID],[_,_]|_],
    nextChild(Node,PNode,_,R,RI,PID,ID2,Request),
    nullChild(PNode,Child,PID,ID2,Request),
    subTreeN_concat(Child,Tree,right1,Tree0),
    subTree(Child,Tree0,NPath,R,RI,Tree1,'right',ID2,MaxDepth,Request).
    
% nach rechts
subTree(Node,Tree,NPath,R,RI,Tree1,S,ID,MaxDepth,Request):-
    S='up',
    %ID<1000,
    ID2 is ID+1,
    NPath=[[PNode,PID],[_,_]|_],
    nextChild(Node,PNode,Child,R,RI,PID,ID2,Request),
    subTreeN_concat(Child,Tree,right0,Tree0),
    subTree(Child,Tree0,NPath,R,RI,Tree1,'right',ID2,MaxDepth,Request).

% nach rechts
subTree(Node,Tree,NPath,R,RI,Tree1,_S,ID,MaxDepth,Request):-
    %S='right',
    %ID<1000,
    ID2 is ID+1,
    NPath=[[PNode,PID],[_,_]|_],
    nextChild(Node,PNode,Child,R,RI,PID,ID2,Request),
    subTreeN_concat(Child,Tree,right1,Tree0),
    subTree(Child,Tree0,NPath,R,RI,Tree1,'right',ID2,MaxDepth,Request).
    
% nach oben
subTree(_Node,Tree,NPath,R,RI,Tree1,S,ID,MaxDepth,Request):-
    S='up',
    %ID<1000,
    NPath=[[PNode,PID]|NP],
    PID>0,
    subTreeN_concat('-',Tree,up,Tree0),
    subTree(PNode,Tree0,NP,R,RI,T1,'up',ID,MaxDepth,Request),
    Tree1=T1.
    
subTree(_Node,Tree,NPath,R,RI,Tree1,_S,ID,MaxDepth,Request):-
    %ID<1000,
    NPath=[[PNode,PID]|NP],
    PID>0,
    subTreeN_concat('-',Tree,up2,Tree0),
    subTree(PNode,Tree0,NP,R,RI,T1,'up',ID,MaxDepth,Request),
    Tree1=T1.
    
subTree(_Node,Tree,NPath,_R,_IR,Tree1,S,_ID,_MaxDepth,_Request):-
    S='up',
    NPath=[[_PNode,PID]|_NP],
    PID=0,
    subTreeN_concat('-',Tree,up,Tree1).
    
subTree(_Node,Tree,NPath,_R,_IR,Tree1,_S,_ID,_MaxDepth,_Request):-
    NPath=[[_PNode,PID]|_NP],
    PID=0,
    subTreeN_concat('-',Tree,up2,Tree1).
