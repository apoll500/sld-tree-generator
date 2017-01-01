% -----------------------------------------------------------------------------+
%                                                                              |
%  treeConvertVars.pl                                                          |
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
:-module(treeConvertVars,[treeConvertVars/2]).


% --------------------------------------------------------------------
% Alle Variablen der Form variable('Name',Index) umschreiben in 'NAME.INDEX'.
% --------------------------------------------------------------------

% --------------------------------------------------------------------
% treeConvertVars/2
% --------------------------------------------------------------------
treeConvertVars(T,_):-
    var(T).%Fall sollte nicht vorkommen.
treeConvertVars(T,Q):-
    atomic(T),Q=T.
treeConvertVars(T,Q):-
    compound(T),
    T=..[variable,VName,VIndex],
    (VIndex==0->Q=VName;atomic_list_concat([VName,'.',VIndex],Q)).
treeConvertVars(T,Q):-
    compound(T),
    T=..[TL|TLs],
    \+TL==variable,
    trl(TLs,QLs),
    Q=..[TL|QLs].

% --------------------------------------------------------------------
% trl/2
% --------------------------------------------------------------------
trl([],[]).
trl([T|Ts],Q):-
    treeConvertVars(T,Q0),
    trl(Ts,Qs),
    Q=[Q0|Qs].
