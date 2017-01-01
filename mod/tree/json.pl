% -----------------------------------------------------------------------------+
%                                                                              |
%  json.pl                                                                     |
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
:-module(json,[
               treeToJson/2,
               tree_to_json/2
              ]).

              
% --------------------------------------------------------------------
% JSON Notation zu einem Baum erzeugen.
% --------------------------------------------------------------------

treeToJson(Tree,Json):-
    tree_to_json(Tree,JsonTree,-1),
    term_to_atom(Tree,TreeAtom),
    atomic_list_concat(['{"PrologTerm":"',TreeAtom,'",',JsonTree,'}'],Json).

% --------------------------------------------------------------------
% tree_to_json/2
% --------------------------------------------------------------------
tree_to_json(Tree,Json):-
    tree_to_json(Tree,Json,0).

tree_to_json(tree(RootNode,SubTrees),Json,ObjectCounter):-
    ObjectCounter<0,
    node_to_json(RootNode,RootNodeJson,0),
    tree_to_json(SubTrees,SubTreesJson,0),
    atomic_list_concat(['"Tree":{',RootNodeJson,',"SubTrees":{',SubTreesJson,'}}'],Json).
tree_to_json(tree(RootNode,SubTrees),Json,ObjectCounter):-
    node_to_json(RootNode,RootNodeJson,0),
    tree_to_json(SubTrees,SubTreesJson,0),
    atomic_list_concat(['"Tree[',ObjectCounter,']":{',RootNodeJson,',"SubTrees":{',SubTreesJson,'}}'],Json).
tree_to_json([],Json,_ObjectCounter):-
    atomic_list_concat(['"this":null'],Json).
tree_to_json([T],Json,ObjectCounter):-
    tree_to_json(T,TJson,ObjectCounter),
    atomic_list_concat([TJson],Json).
tree_to_json([T|Ts],Json,ObjectCounter):-
    ObjectCounter1 is ObjectCounter+1,
    tree_to_json(T,TJson,ObjectCounter),
    tree_to_json(Ts,TsJson,ObjectCounter1),
    atomic_list_concat([TJson,',',TsJson],Json).

node_to_json(Node,Json,ObjectCounter):-
    Node=node(Id,goal(G),cl(Cid,C),U,E,V),
    (Id=id(Id0,Re0)->Id1 is Id0+Re0*10000;Id1=Id),
    pair_to_json('Id',Id1,JId,ObjectCounter),
    goal_to_json(G,JGoal,ObjectCounter),
    pair_to_json('Cid',Cid,JCid,ObjectCounter),
    C=variant(C1),
    clause_to_json(C1,JC,ObjectCounter),
    pair_to_json('Unificator',U,JU,ObjectCounter),
    pair_to_json('Properties',E,JE,ObjectCounter),
    pair_to_json('Variables',V,JV,ObjectCounter),
    atomic_list_concat(['"Node":{',JId,',',JGoal,',',JCid,',',JC,',',JU,',',JE,',',JV,'}'],Json).

goal_to_json(Goal,Json,ObjectCounter):-
    term_to_atom(Goal,GA),
    pair_to_json('Goal',GA,Json,ObjectCounter).

term_to_json(Term,Json,ObjectCounter):-
    term_to_atom(Term,TA),
    pair_to_json('Term',TA,Json,ObjectCounter).

clause_to_json(Clause,Json,ObjectCounter):-
    term_to_atom(Clause,CA),
    pair_to_json('Clause',CA,Json,ObjectCounter).

tojson(variable(Name,Index),Json,ObjectCounter):-
    ObjectCounter<0,
    pair_to_json('Name',Name,JsonPairName,ObjectCounter),
    pair_to_json('Index',Index,JsonPairIndex,ObjectCounter),
    atomic_list_concat(['"Variable":{',JsonPairName,',',JsonPairIndex,'}'],Json).
tojson(variable(Name,Index),Json,ObjectCounter):-
    pair_to_json('Name',Name,JsonPairName,ObjectCounter),
    pair_to_json('Index',Index,JsonPairIndex,ObjectCounter),
    atomic_list_concat(['"Variable[',ObjectCounter,']":{',JsonPairName,',',JsonPairIndex,'}'],Json).
tojson(variable(Name,Index)=Term,Json,ObjectCounter):-
    tojson(variable(Name,Index),VJson,-1),
    term_to_json(Term,TJson,ObjectCounter),
    atomic_list_concat(['"Substitution[',ObjectCounter,']":{',VJson,',',TJson,'}'],Json).
tojson(loc(Pid,Depth),Json,ObjectCounter):-
    (Pid=pid(Pid0,Re0)->Pid1 is Pid0+Re0*10000;Pid1=Pid),
    pair_to_json('Pid',Pid1,PidJson,ObjectCounter),
    pair_to_json('Depth',Depth,DepthJson,ObjectCounter),
    atomic_list_concat(['"Location":{',PidJson,',',DepthJson,'}'],Json).
tojson(p(G,V,U),Json,ObjectCounter):-
    goal_to_json(G,GJson,ObjectCounter),
    pair_to_json('Variables',V,VJson,ObjectCounter),
    pair_to_json('Unificator',U,UJson,ObjectCounter),
    atomic_list_concat(['"PathNode[',ObjectCounter,']":{',GJson,',',VJson,',',UJson,'}'],Json).
tojson([[p(G,V,U)|Vs]|Es],Json,ObjectCounter):-
    ObjectCounter1 is ObjectCounter+1,
    tojson([p(G,V,U)|Vs],VJson,ObjectCounter),
    tojson(Es,EsJson,ObjectCounter1),
    (EsJson='{"this":null}'->atomic_list_concat(['"Path":{',VJson,'}'],Json);atomic_list_concat(['"Path":{',VJson,'},',EsJson],Json)).
tojson([],Json,_ObjectCounter):-
    atomic_list_concat(['{"this":null}'],Json).
tojson([V],Json,ObjectCounter):-
    tojson(V,JsonValue,ObjectCounter),
    atomic_list_concat([JsonValue],Json).
tojson([V|Vs],Json,ObjectCounter):-
    ObjectCounter1 is ObjectCounter+1,
    tojson(V,JsonValue,ObjectCounter),
    tojson(Vs,JsonArray,ObjectCounter1),
    atomic_list_concat([JsonValue,',',JsonArray],Json).
tojson([[V|Vs]|Es],Json,ObjectCounter):-
    ObjectCounter1 is ObjectCounter+1,
    tojson([V|Vs],VJson,ObjectCounter),
    tojson(Es,EsJson,ObjectCounter1),
    atomic_list_concat(['{',VJson,'},',EsJson],Json).
tojson(Value,Json,_ObjectCounter):-
    number(Value),
    atomic_list_concat([Value],Json).
tojson(Value,Json,_ObjectCounter):-
    atomic_list_concat(['"',Value,'"'],Json).

pair_to_json(Name,[V|Vs],Json,ObjectCounter):-
    tojson([V|Vs],VJson,ObjectCounter),
    atomic_list_concat(['"',Name,'":{',VJson,'}'],Json).
pair_to_json(Name,Value,Json,ObjectCounter):-
    tojson(Value,JsonValue,ObjectCounter),
    atomic_list_concat(['"',Name,'":',JsonValue],Json).
