% -----------------------------------------------------------------------------+
%                                                                              |
%  tree.pl                                                                     |
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
:-module(tree,[
           root_node/2,
           rootNodeId/2,
           treeDepth/2,
           treePath/2,
           nodeDepth/2,
           nodePath/2,
           nodeGoal/2,
           globalRootVariables/2,
           fullNodePath/3,
           subtreelist/2,
           getDepthOfNode/3,
           getPidOfNode/3,
           getLocOfNode/3,
           getFirstChildOfNode/3,
           getNextChildOfNode/3,
           getPrevChildOfNode/3,
           getSubTree/3,
           getNode/3,
           fullSubst/3
          ]).

% --------------------------------------------------------------------
% Tree-analysing.
% --------------------------------------------------------------------

% --------------------------------------------------------------------
% root_tree/2
% --------------------------------------------------------------------
root_node(tree(Node,_),Node).

% --------------------------------------------------------------------
% rootNodeId/2
% --------------------------------------------------------------------
rootNodeId(tree(node(RootNodeId,_,_,_,_,_),_),RootNodeId).

% --------------------------------------------------------------------
% treeDepth/2
% --------------------------------------------------------------------
treeDepth(tree(node(_,_,_,_,[loc(_,Depth)|_],_),_),Depth).

% --------------------------------------------------------------------
% treePath/2
% --------------------------------------------------------------------
treePath(tree(node(_,_,_,_,[_,Path|_],_),_),Path).
treePath(tree(node(_,_,_,_,[_],_),_),[]).

% --------------------------------------------------------------------
% nodeDepth/2
% --------------------------------------------------------------------
nodeDepth(node(_,_,_,_,[loc(_,Depth)|_],_),Depth).

% --------------------------------------------------------------------
% nodePath/2
% --------------------------------------------------------------------
nodePath(node(_,_,_,_,[_,Path|_],_),Path).
nodePath(node(_,_,_,_,[_],_),[]).

% --------------------------------------------------------------------
% globalRootVariables/2
% --------------------------------------------------------------------
globalRootVariables(Tree,Variables):-
    root_node(Tree,Node),
    nodePath(Node,Path),
    lastElementOfList(Path,p(_,Variables,_)).

% --------------------------------------------------------------------
% nodeVars/2
% --------------------------------------------------------------------
nodeVars(node(_,_,_,_,_,Vars),Vars).

% --------------------------------------------------------------------
% nodeUnificator/2
% --------------------------------------------------------------------
nodeUnificator(node(_,_,_,Unif,_,_),Unif).

% --------------------------------------------------------------------
% nodeGoal/2
% --------------------------------------------------------------------
nodeGoal(node(_,goal(Goal),_,_,_,_),Goal).

% --------------------------------------------------------------------
% subtreelist/2
% --------------------------------------------------------------------
subtreelist(Tree,SubTreeList):-
    Tree=tree(_,SubTreeList).

% --------------------------------------------------------------------
% getDepthOfNode/3
% --------------------------------------------------------------------
getDepthOfNode(NodeId,Tree,Depth):-
    getNode(NodeId,Tree,node(_,_,_,_,[loc(_,Depth)|_],_)).

% --------------------------------------------------------------------
% getPidOfNode/3
% --------------------------------------------------------------------
getPidOfNode(NodeId,Tree,Pid1):-
    getNode(NodeId,Tree,node(_,_,_,_,[loc(Pid0,_)|_],_)),
    Pid0=pid(Id,Re),
    Pid1=id(Id,Re).

% --------------------------------------------------------------------
% getLocOfNode/3
% --------------------------------------------------------------------
getLocOfNode(NodeId,Tree,Loc):-
    getNode(NodeId,Tree,node(_,_,_,_,[Loc|_],_)).

% --------------------------------------------------------------------
% getFirstChildOfNode/3
% --------------------------------------------------------------------
getFirstChildOfNode(NodeId,Tree,FirstChildId):-
    getSubTree(NodeId,Tree,tree(_,[tree(node(FirstChildId,_,_,_,_,_),_)|_])).
getFirstChildOfNode(NodeId,Tree,NodeId):-
    getSubTree(NodeId,Tree,tree(_,[])).

% --------------------------------------------------------------------
% getNextChildOfNode/3
% --------------------------------------------------------------------
getNextChildOfNode(NodeId,Tree,NextChildId):-
    getPidOfNode(NodeId,Tree,Pid),
    getSubTree(Pid,Tree,tree(_,SubTreeList)),
    getNextIdInList(NodeId,SubTreeList,NextChildId).

% --------------------------------------------------------------------
% nextIdInList/3
% --------------------------------------------------------------------
getNextIdInList(NodeId,[tree(node(NodeId,_,_,_,_,_),_),tree(node(NextId,_,_,_,_,_),_)|_],NextId).
getNextIdInList(NodeId,[],NodeId).
getNextIdInList(NodeId,[_|Ts],NextId):-
    getNextIdInList(NodeId,Ts,NextId).

% --------------------------------------------------------------------
% getPrevChildOfNode/3
% --------------------------------------------------------------------
getPrevChildOfNode(NodeId,Tree,PrevChildId):-
    getPidOfNode(NodeId,Tree,Pid),
    getSubTree(Pid,Tree,tree(_,SubTreeList)),
    getPrevIdInList(NodeId,SubTreeList,PrevChildId).

% --------------------------------------------------------------------
% prevIdInList/3
% --------------------------------------------------------------------
getPrevIdInList(NodeId,[tree(node(PrevId,_,_,_,_,_),_),tree(node(NodeId,_,_,_,_,_),_)|_],PrevId).
getPrevIdInList(NodeId,[],NodeId).
getPrevIdInList(NodeId,[_|Ts],PrevId):-
    getNextIdInList(NodeId,Ts,PrevId).

% --------------------------------------------------------------------
% fullNodePath/3
% --------------------------------------------------------------------
fullNodePath(NodeId,Tree,NodePath):-
    getNode(NodeId,Tree,Node),
    nodePath(Node,[]),
    nodeGoal(Node,Goal),
    nodeVars(Node,Vars),
    nodeUnificator(Node,Unif),
    getPidOfNode(NodeId,Tree,Pid),
    fullNodePath(Pid,Tree,Path0),
    NodePath=[p(goal(Goal),Vars,Unif)|Path0].
fullNodePath(NodeId,Tree,NodePath):-
    getNode(NodeId,Tree,Node),
    nodePath(Node,NodePath),
    \+NodePath=[].

% --------------------------------------------------------------------
% fullSubst/3
% --------------------------------------------------------------------
fullSubst(NodeId,Tree,Subst):-
    getNode(NodeId,Tree,Node),
    nodePath(Node,[]),
    nodeUnificator(Node,Unif),
    getPidOfNode(NodeId,Tree,Pid),
    fullSubst(Pid,Tree,Subst0),
    Subst=[Unif|Subst0].
fullSubst(NodeId,Tree,Subst):-
    getNode(NodeId,Tree,Node),
    nodeSubst(Node,Subst),
    \+Subst=[].

nodeSubst(Node,Subst):-
    nodePath(Node,Path),
    nodePathSubst(Path,Subst).

nodePathSubst([],[]).
nodePathSubst([P|Ps],[Unif|Subst]):-
    P=p(_,_,Unif),
    nodePathSubst(Ps,Subst).
nodePathSubst([P|Ps],Subst):-
    \+P=p(_,_,_),
    nodePathSubst(Ps,Subst).

% --------------------------------------------------------------------
% getSubTree/3
% --------------------------------------------------------------------
getSubTree(NodeId,Tree,SubTree):-
    rootNodeId(Tree,NodeId),
    SubTree=Tree.
getSubTree(NodeId,Tree,SubTree):-
    \+rootNodeId(Tree,NodeId),
    Tree=tree(_,SubTreeList),
    getSubTree_sub(NodeId,SubTreeList,SubTree).

% --------------------------------------------------------------------
% getSubTree_sub/3
% --------------------------------------------------------------------
getSubTree_sub(_NodeId,[],null).
getSubTree_sub(NodeId,[T|_],SubTree):-
    getSubTree(NodeId,T,SubTree).
getSubTree_sub(NodeId,[_|Ts],SubTree):-
    getSubTree_sub(NodeId,Ts,SubTree).

% --------------------------------------------------------------------
% getNode/3
% --------------------------------------------------------------------
getNode(NodeId,Tree,Node):-
    rootNodeId(Tree,NodeId),
    root_node(Tree,Node).
getNode(NodeId,Tree,Node):-
    \+rootNodeId(Tree,NodeId),
    Tree=tree(_,SubTreeList),
    getNode_sub(NodeId,SubTreeList,Node).

% --------------------------------------------------------------------
% getNode_sub/3
% --------------------------------------------------------------------
getNode_sub(_NodeId,[],null).
getNode_sub(NodeId,[T|_],Node):-
    getNode(NodeId,T,Node).
getNode_sub(NodeId,[_|Ts],Node):-
    getNode_sub(NodeId,Ts,Node).

% --------------------------------------------------------------------
% getFirstChildId/2
% --------------------------------------------------------------------
getFirstChildId(tree(_,[SubTree|_]),FirstChildId):-
    rootNodeId(SubTree,FirstChildId).
getFirstChildId(tree(Tree,[]),FirstChildId):-
    rootNodeId(Tree,FirstChildId).

