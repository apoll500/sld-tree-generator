% -----------------------------------------------------------------------------+
%                                                                              |
%  subtree_concat.pl                                                           |
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
:-module(dubtree_concat,[subTreeN_concat/4]).

% ------------------------------------------------------------------------------
% subTreeN_concat/4
% ------------------------------------------------------------------------------
subTreeN_concat(ChildTerm,TreeAtom,down,NewTreeAtom):-
    term_to_atom(ChildTerm,ChildA),
    atomic_list_concat([TreeAtom,'tree(',ChildA,',['],NewTreeAtom).

subTreeN_concat(_ChildTerm,TreeAtom,up,NewTreeAtom):-
    atomic_list_concat([TreeAtom,'])'],NewTreeAtom).
    
subTreeN_concat(_ChildTerm,TreeAtom,up2,NewTreeAtom):-
    atomic_list_concat([TreeAtom,'])])'],NewTreeAtom).
    
subTreeN_concat(ChildTerm,TreeAtom,right0,NewTreeAtom):-
    term_to_atom(ChildTerm,ChildA),
    atomic_list_concat([TreeAtom,',tree(',ChildA,',['],NewTreeAtom).
    
subTreeN_concat(ChildTerm,TreeAtom,right1,NewTreeAtom):-
    term_to_atom(ChildTerm,ChildA),
    atomic_list_concat([TreeAtom,']),tree(',ChildA,',['],NewTreeAtom).
