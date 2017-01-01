% -----------------------------------------------------------------------------+
%                                                                              |
%  sld_node.pl                                                                 |
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
:-module(sld_node,[sld_node/9,
           maxDepth/1,
           to_unbounded_term/2,
           to_unbounded_term/3,
           test_goal/2]).

% ------------------------------------------------------------------------------
% Erstes Ziel aus einer Anfrage (Konjunktionsterm) ermitteln.
% ------------------------------------------------------------------------------
getFirstGoal((Goal,RestTerm),Goal,RestTerm).
getFirstGoal(Goal,Goal1,'true'):-
    \+getFGTest(Goal),
    Goal1=Goal.

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
getFGTest((_,_)).

% ------------------------------------------------------------------------------
% Testet ob ein Goal mit einer Programm-Klausel unifizierbar ist.
% ------------------------------------------------------------------------------
test_goal(GoalTerm,Ref):-
    getFirstGoal(GoalTerm,Goal,_),
    wa:clause(Head,_,Ref),
    unifiable(Goal,Head,_).

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
test_goal_intern(GoalTerm,Ref):-
    firstGoal_to_intGoal(GoalTerm,GoalNeu),
    wi:clause(Head,_,Ref),
    unifiable(GoalNeu,Head,_).

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
firstGoal_to_intGoal(GoalTerm,GoalInt):-
    getFirstGoal(GoalTerm,Goal,_),
    goal_to_intGoal(Goal,GoalInt).

% ------------------------------------------------------------------------------
% Comparison and Unification of Terms
% - Standard Order of Terms
goal_to_intGoal(Goal,GoalInt):-
    Goal=..L,L=['=='|As],
    L2=[intern_term_eq|As],GoalInt=..L2.
goal_to_intGoal(Goal,GoalInt):-
    Goal=..L,L=['\\=='|As],
    L2=[intern_term_neq|As],GoalInt=..L2.
goal_to_intGoal(Goal,GoalInt):-
    Goal=..L,L=['@<'|As],
    L2=[intern_term_lt|As],GoalInt=..L2.
goal_to_intGoal(Goal,GoalInt):-
    Goal=..L,L=['@=<'|As],
    L2=[intern_term_le|As],GoalInt=..L2.
goal_to_intGoal(Goal,GoalInt):-
    Goal=..L,L=['@>'|As],
    L2=[intern_term_gt|As],GoalInt=..L2.
goal_to_intGoal(Goal,GoalInt):-
    Goal=..L,L=['Q>='|As],
    L2=[intern_term_ge|As],GoalInt=..L2.
% - Special unification and comparison predicates
goal_to_intGoal(Goal,GoalInt):-
    Goal=..L,L=['=@='|As],
    L2=[intern_variantOf|As],GoalInt=..L2.
goal_to_intGoal(Goal,GoalInt):-
    Goal=..L,L=['\\=@='|As],
    L2=[intern_not_variantOf|As],GoalInt=..L2.
% - more
goal_to_intGoal(Goal,GoalInt):-
    Goal=..L,L=['='|As],
    L2=[intern_unify|As],GoalInt=..L2.
goal_to_intGoal(Goal,GoalInt):-
    Goal=..L,L=['\\='|As],
    L2=[intern_not_unify|As],GoalInt=..L2.
goal_to_intGoal(Goal,GoalInt):-
    Goal=..L,L=['\\+'|As],
    L2=[intern_not_unify|As],GoalInt=..L2.
goal_to_intGoal(Goal,GoalInt):-
    Goal=..L,L=['?='|As],
    L2=[intern_save_unifyable|As],GoalInt=..L2.
% Control Predicates
goal_to_intGoal(Goal,GoalInt):-
    Goal=..L,L=[';'|As],
    L2=[intern_or|As],GoalInt=..L2.
goal_to_intGoal(Goal,GoalInt):-
    Goal=..L,L=['|'|As],
    L2=[intern_or|As],GoalInt=..L2.
goal_to_intGoal(Goal,GoalInt):-
    Goal=..L,L=['->'|As],
    L2=[intern_ifthen|As],GoalInt=..L2.
% Arithmetic
% - Special purpose integer arithmetic
% - General purpose arithmetic
goal_to_intGoal(Goal,GoalInt):-
    Goal=..L,L=['<'|As],
    L2=[intern_lt|As],GoalInt=..L2.
goal_to_intGoal(Goal,GoalInt):-
    Goal=..L,L=['=<'|As],
    L2=[intern_le|As],GoalInt=..L2.
goal_to_intGoal(Goal,GoalInt):-
    Goal=..L,L=['>'|As],
    L2=[intern_gt|As],GoalInt=..L2.
goal_to_intGoal(Goal,GoalInt):-
    Goal=..L,L=['>='|As],
    L2=[intern_ge|As],GoalInt=..L2.
goal_to_intGoal(Goal,GoalInt):-
    Goal=..L,L=['=\\='|As],
    L2=[intern_neq|As],GoalInt=..L2.
goal_to_intGoal(Goal,GoalInt):-
    Goal=..L,L=['=:='|As],
    L2=[intern_eq|As],GoalInt=..L2.% all others
% others
goal_to_intGoal(Goal,GoalInt):-
    Goal=..L,L=['!'|As],
    L2=[intern_cut|As],GoalInt=..L2.% all others
goal_to_intGoal(Goal,GoalInt):-
    Goal=..L,L=[F|As],
    atomic_list_concat([intern_,F],F2),%write(F2),nl,
    L2=[F2|As],GoalInt=..L2.
    
% ------------------------------------------------------------------------------
% Alle Variablen der Form variable(Name,Index) umschreiben in ungebundene Variablen.
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
to_unbounded_term(Term,UTerm):-
    trterm(Term,VARTerm),
    rewrite_term(VARTerm,UTerm).

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
to_unbounded_term(Term,UTerm,BindingsAtom):-
    trterm(Term,VARTerm),
    rewrite_term(VARTerm,UTerm,Bindings),
    term_to_atom(Bindings,BindingsAtom).

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
to_unbounded_term2(Term,UTerm,Bindings):-
    trterm(Term,VARTerm),
    rewrite_term(VARTerm,UTerm,Bindings).

% ------------------------------------------------------------------------------
% Maximale Tiefe aller berechneten Knoten.
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
maxDepth(D):-
    var(D),
    maxDepth(D,1).
maxDepth(D):-
    nonvar(D).

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
maxDepth(D,N):-
    nth_clause(node_depth(_,_),N,Ref),
    clause(node_depth(_NodeId,Depth),_Body,Ref),
    write('(Depth: '),
    N1 is N+1,
    maxDepth(D0,N1),
    D is max(D0,Depth).
maxDepth(D,N):-
    \+nth_clause(node_depth(_,_),N,_Ref),
    D=0.

% ------------------------------------------------------------------------------
% Generieren eines Knotens
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
sld_node(GoalTerm,Refs,IRefs,VNames,NodeTerm,PID,ID,Depth,Request):-
    %write('------ '),write(GoalTerm),nl,
    to_unbounded_term(GoalTerm,GoalTerm_0),
    sld_node_1(GoalTerm_0,GoalTerm,Refs,IRefs,VNames,NodeTerm,PID,ID,Depth,Request).

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
sld_node_1(_GoalTerm_0,_GoalTerm,[],[],_VNames,'fail',_PID,_ID,_Depth,_Request):-false.
sld_node_1(GoalTerm_0,GoalTerm,[],[[Ref,_,_]|Refs],VNames,NodeTerm,PID,ID,Depth,Request):-
    \+test_goal_intern(GoalTerm_0,Ref),
    sld_node_1(GoalTerm_0,GoalTerm,[],Refs,VNames,NodeTerm,PID,ID,Depth,Request).
sld_node_1(GoalTerm_0,GoalTerm,[],[[Ref,VN,CID]|_Refs],VNames,NodeTerm,PID,ID,Depth,Request):-
    test_goal_intern(GoalTerm_0,Ref),%write('-> '),write(CID),nl,
    !,sld_node_2_intern(GoalTerm,Ref,VN,CID,VNames,NodeTerm,PID,ID,Depth,Request).
sld_node_1(GoalTerm_0,GoalTerm,[[Ref,_,_]|Refs],IRefs,VNames,NodeTerm,PID,ID,Depth,Request):-
    \+test_goal(GoalTerm_0,Ref),
    sld_node_1(GoalTerm_0,GoalTerm,Refs,IRefs,VNames,NodeTerm,PID,ID,Depth,Request).
sld_node_1(GoalTerm_0,GoalTerm,[[Ref,VN,CID]|_Refs],_IRefs,VNames,NodeTerm,PID,ID,Depth,Request):-
    test_goal(GoalTerm_0,Ref),%write('-> '),write(CID),nl,
    !,sld_node_2(GoalTerm,Ref,VN,CID,VNames,NodeTerm,PID,ID,Depth,Request).

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
sld_node_2(GoalTerm,Ref,VN,CID,VNames,Node,PID,ID,Depth,Request):-
    garbage_collect,
    % Klausel abfragen.
    wa:clause(Head,Body,Ref),Clause=(Head:-Body),
    sld_node_clause(GoalTerm,Clause,VN,CID,VNames,Node,PID,ID,Depth,Request).

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
sld_node_2_intern(GoalTerm,Ref,VN,CID,VNames,Node,PID,ID,Depth,Request):-
    garbage_collect,
    % Klausel abfragen.
    wi:clause(Head,Body,Ref),Clause=(Head:-Body),
    sld_node_clause_intern(GoalTerm,Clause,VN,CID,VNames,Node,PID,ID,Depth,Request).

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
sld_node_call(Goal,Unifier,Result):-
    tconcat(Goal,true,Goal2),
    to_unbounded_term(Goal2,GoalUnb,GoalBind),
    term_variables(GoalUnb,Vars),
    list_to_atomiclist(Vars,VarsAtom),
    atom_to_term(GoalBind,GB2,GBB),
    solve(GBB),
    (call(GoalUnb)->Result=true;Result=false),
    listBindUnify(Vars,VarsAtom,GB2,Unifier).

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
sld_node_clause_intern(GoalTerm,Clause,VN,CID,VNames,Node,PID,ID,Depth,Request):-
    
    % ungebundene Variablen einsetzen.
    to_unbounded_term(GoalTerm,GTU,GBc),                    
    to_unbounded_term(GoalTerm,GTU2,GBc2),                  
    
    % Variablen umbenennen in Kausel.
    repvars(Clause,VN,VNames,VNamesNew),
    
    % ungebundene Variablen einsetzen.
    to_unbounded_term(Clause,CU,CBc),CU=(HU:-BU),           
    to_unbounded_term(Clause,CU2,CBc2),CU2=(HU2:-_),        

    % erstes Goal bestimmen.
    getFirstGoal(GTU,GUo,GRestU),
    getFirstGoal(GTU2,GU2o,_),

    goal_to_intGoal(GUo,GU),
    goal_to_intGoal(GU2o,GU2),

    !,sld_node_unify(GU,HU,GU2,HU2,U1,U1c),!,
    
    reconstruct_clause(GBc,CBc,GTU,CU),
    reconstruct_unifier(GBc2,CBc2,GTU2,CU2,U1c,U1),

    (BU=call(T0)->sld_csub(T0,Result,Unifier2);sld_cstd(BU,Result,Unifier2)),

    append(U1,Unifier2,Unifier),
    
    concat_resolvente(Result,GRestU,Resol),
    
    % Apply Unifier2.
    to_unbounded_term2(Resol,Resol2,Resol2B),
    to_unbounded_term2(Unifier2,Unifier22,Unifier22B),
    solve(Unifier22B),
    solve(Resol2B),
    repvaru(Resol2,Unifier22,Resol4),
    
    make_node(ID,Resol4,CID,Clause,Unifier,PID,Depth,VNamesNew,Node,Request).

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
sld_csub(Result,Result,[]).

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
sld_cstd(BU,Result,Unifier2):-
    sld_node_call(BU,Unifier2,Result).
   
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
sld_rsub(ID,T1,GRestU,CID,Clause,U1,PID,Depth,VNamesNew,Node,Request):-
    % Resolvente zusammensetzen.
    tconcat(T1,GRestU,Resol),%write(GRestU),nl,
    make_node(ID,Resol,CID,Clause,U1,PID,Depth,VNamesNew,Node,Request).
    
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
sld_rstd(Unifier2,Result,ID,GRestU,CID,Clause,U1,PID,Depth,VNamesNew,Node,Request):-
    append(U1,Unifier2,Unifier),
    % Resolvente zusammensetzen.
    tconcat(Result,GRestU,Resol),%write(GRestU),nl,
    make_node(ID,Resol,CID,Clause,Unifier,PID,Depth,VNamesNew,Node,Request).

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
sld_node_clause(GoalTerm,Clause,VN,CID,VNames,Node,PID,ID,Depth,Request):-
    
    % ungebundene Variablen einsetzen.
    to_unbounded_term(GoalTerm,GTU,GBc),                    
    to_unbounded_term(GoalTerm,GTU2,GBc2),                  
    
    % Variablen umbenennen in Kausel.
    repvars(Clause,VN,VNames,VNamesNew),
    
    % ungebundene Variablen einsetzen.
    to_unbounded_term(Clause,CU,CBc),CU=(HU:-BU),           
    to_unbounded_term(Clause,CU2,CBc2),CU2=(HU2:-_),        

    % erstes Goal bestimmen.
    getFirstGoal(GTU,GU,GRestU),                            
    getFirstGoal(GTU2,GU2,_),

    !,sld_node_unify(GU,HU,GU2,HU2,U1,U1c),
    
    reconstruct_clause(GBc,CBc,GTU,CU),
    reconstruct_unifier(GBc2,CBc2,GTU2,CU2,U1c,U1),
    concat_resolvente(BU,GRestU,Resol),
    make_node(ID,Resol,CID,Clause,U1,PID,Depth,VNamesNew,Node,Request).

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
reconstruct_clause(GBc,CBc,GTU,CU):-
    atom_to_term(GBc,GB1,GBB),                              
    atom_to_term(CBc,CB1,CBB),
    solve(GBB),solve(CBB),                                  
    term_variables(GTU,VarsGT),                             
    term_variables(CU,VarsC),
    fillvars(VarsGT,GB1),                                   
    fillvars(VarsC,CB1).

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
reconstruct_unifier(GBc2,CBc2,GTU2,CU2,U1c,U1):-
    % Unifikator rekonstruieren.
    atom_to_term(GBc2,GB12,GBB2),
    atom_to_term(CBc2,CB12,CBB2),
    solve(GBB2),solve(CBB2),
    term_variables(GTU2,VarsGT2),
    term_variables(CU2,VarsC2),
    fillvars2(VarsGT2,GB12),
    fillvars2(VarsC2,CB12),
    atom_to_term(U1c,U2,UB),solve(UB),
    term_variables(U1,VarsU),
    fillvars2(VarsU,U2).
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
concat_resolvente(false,_RestGoalUnboundedTerm,fail).
concat_resolvente(NextUnboundedTerm,RestGoalUnboundedTerm,Resolvente):-
    %tconcat(RestGoalUnboundedTerm,NextUnboundedTerm,Resolvente),
    tconcat(NextUnboundedTerm,RestGoalUnboundedTerm,Resolvente).
    
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
make_node(ID,Resol,CID,Clause,U1,PID,Depth,VNamesNew,Node,Request):-
    Node=node(id(ID,Request),goal(Resol),cl(CID,variant(Clause)),U1,[loc(pid(PID,Request),Depth)],VNamesNew).
    
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
sld_node_unify(GU,HU,GU2,HU2,U1,U1c):-
    % Testen, ob unifizierbar.
    !,unifiable(GU2,HU2,U1),!,         
    term_to_atom(U1,U1c),
    % Unifizieren durch prolog.
    doUnify(GU,HU).
    
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
xx_sld_node_unify(GU,HU,GU2,HU2,U1,U1c):-
    % Testen, ob unifizierbar.
    !,unifiable(GU2,HU2,U1),!,term_to_atom(U1,U1c),         
    % Unifizieren durch prolog.
    doUnify(GU,HU).
    
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
doUnify(A,B):-
    unify_with_occurs_check(A,B).

% --------------------------------------------------------------------
% +V: Variablen [_G001,_G002,'variable(\'Name\',Index)'...]
% +B: Bindings  ['VARIABLE__NAME_INDEX'='_G001',...]
% _G001 wird unifiziert mit 'variable(\'Name\',Index)'.
% --------------------------------------------------------------------
fillvars([],_).
fillvars([V|Vs],B):-
    fillvar(V,B),
    fillvars(Vs,B).

fillvar(_,[]).
fillvar(V,[B|_]):-
    term_to_atom(V,VA),
    B=..['=',Name,I],
    VA==I,
    atomic_list_concat(L,'_',Name),
    fillvar_hlp(V,L).
fillvar(V,[B|Bs]):-
    term_to_atom(V,VA),
    B=..['=',_Name,I],
    \+VA==I,
    fillvar(V,Bs).

fillvar_hlp(V,L):-
    L=['VARIABLE',_|Ls],
    append(OName0,[Index],Ls),
    atomic_list_concat(OName0,'_',OName),
    atomic_list_concat([variable,'(','\'',OName,'\'',',',Index,')'],A),
    V=A.
fillvar_hlp(V,L):-
    \+L=['VARIABLE',_|_],
    L=[N|_],
    V=N.

% --------------------------------------------------------------------
% +V: Variablen [_G001,_G002,'variable(\'Name\',Index)'...]
% +B: Bindings  ['VARIABLE__NAME_INDEX'='_G001',...]
% _G001 wird unifiziert mit variable('Name',Index).
% --------------------------------------------------------------------
fillvars2([],_).
fillvars2([V|Vs],B):-
    fillvar2(V,B),
    fillvars2(Vs,B).

fillvar2(_,[]).
fillvar2(V,[B|_]):-
    term_to_atom(V,VA),
    B=..['=',Name,I],
    VA==I,
    atomic_list_concat(L,'_',Name),
    fillvar2_hlp(V,L).
fillvar2(V,[B|Bs]):-
    term_to_atom(V,VA),
    B=..['=',_Name,I],
    \+VA==I,
    fillvar2(V,Bs).

fillvar2_hlp(V,L):-
    L=['VARIABLE',_|Ls],
    append(OName0,[Index],Ls),
    atomic_list_concat(OName0,'_',OName),
    atomic_list_concat([variable,'(','\'',OName,'\'',',',Index,')'],A),
    term_to_atom(T,A),
    V=T.
fillvar2_hlp(V,L):-
    \+L=['VARIABLE',_|_],
    L=[N|_],
    V=N.

    
  

repvaru(Term,_,Term):-
    cyclic_term(Term).
repvaru(Term,U,Term2):-
    acyclic_term(Term),
    compound(Term),%write(Term),nl,
    Term=..[F|Args],
    repvaru_args(Args,U,Terms),
    Term2=..[F|Terms].
repvaru(Term,_,Term):-
    var(Term).
repvaru(Term,_,Term):-
    atomic(Term),%write(' atomic '),write(Term),nl,
    \+atom(Term).
repvaru(Term,U,Term2):-
    atom(Term),%write(' atom   '),write(Term),nl,
    repvaru_atom(Term,U,Term2).
    
repvaru_args([],_,[]).
repvaru_args([A|As],U,[V|Vs]):-
    repvaru(A,U,V),
    repvaru_args(As,U,Vs).

repvaru_atom(Term,[],VarTerm):-%-write('>>>'),write(Term),nl,
    atomic_list_concat(L,'_',Term),
    L=['VARIABLE',_|Ls],
    append(OName0,[Index],Ls),
    atomic_list_concat(OName0,'_',OName),
    atomic_list_concat([variable,'(','\'',OName,'\'',',',Index,')'],A),%write(A),nl,
    term_to_atom(VarTerm,A).
repvaru_atom(Term,[],Term).%:-write('>>> >>> '),write(Term),nl.
repvaru_atom(Term,[Name=_|Us],VarTerm):-
    \+Name=Term,
    repvaru_atom(Term,Us,VarTerm).
repvaru_atom(Name,[Name=Value|_],Value).%:-write(Name),write(' = '),write(Value),write('<<<'),nl.

% --------------------------------------------------------------------
% Variablen im Goal umschreiben zu variable(Name,0).
% --------------------------------------------------------------------
repvars0(Goal,VN,VL,VL1):-
    term_variables(Goal,VH),
    sol0(VH,VN,VL,VL1).

sol0([],_,_,[]).
sol0(_,[],_,[]).
sol0([V|Vs],[N|Ns],VL,VL1):-
    V=variable(N,0),
    sol0(Vs,Ns,VL,VL2),
    VL1=[V|VL2].

% --------------------------------------------------------------------
% Variablen in der Klausel umschreiben zu variable(Name,Index).
% --------------------------------------------------------------------
repvars(Clause,VN,VL,VL1):-
    term_variables(Clause,VH),
    sol(VH,VN,VL,VL0),
    checkvi(VL,VL0,A),
    add_missing(VL0,A,VL1).

checkvi([],_,[]).
checkvi([V|VL],VL0,VL1):-
    V=variable(N,I),
    getcnt(N,VL0,C0),
    C is max(C0,I),
    Vm=variable(N,C),
    checkvi(VL,VL0,VLs),
    VL1=[Vm|VLs].

add_missing([],A,A).
add_missing([V|VL],A,VL1):-
    V=variable(N,_I),
    getcnt(N,A,C),
    C=0,
    add_missing(VL,A,VLs),
    VL1=[V|VLs].
add_missing([V|VL],A,VL1):-
    V=variable(N,_I),
    getcnt(N,A,C),
    \+C=0,
    add_missing(VL,A,VLs),
    VL1=VLs.

sol([],_,_,VL1):-VL1=[].
sol(_,[],_,VL1):-VL1=[].
sol([V|Vs],[N|Ns],VL,VL1):-
    getcnt(N,VL,C),
    %(C=0->C1 is C+1;C1=0),
    C1 is C+1,
    V=variable(N,C1),
    sol(Vs,Ns,VL,VL2),
    VL1=[V|VL2].

getcnt(_,[],Cnt):-Cnt=0.
getcnt(Name,[V|Vs],Cnt):-
    \+unifiable(variable(Name,_),V,_),
    getcnt(Name,Vs,Cnt).
getcnt(Name,[V|_],Cnt):-
    unifiable(variable(Name,_),V,_),
    variable(Name,Cnt)=V.

% --------------------------------------------------------------------
% Alle Variablen der Form variable('Name',Index) umschreiben in 'VARIABLE__NAME_INDEX'.
% --------------------------------------------------------------------
trterm(T,_Q):-
    var(T).%,write('Fehler in trterm/2: Alle Variablen sollten ersetzt sein. ... Offenbar wurden die ungebundenen Variablen nicht unifiziert! '),nl.
trterm(T,Q):-
    atomic(T),Q=T.
trterm(T,Q):-
    compound(T),
    T=..[variable,VName,VIndex],
    atomic_list_concat(['VARIABLE__',VName,'_',VIndex],Q).
trterm(T,Q):-
    compound(T),
    T=..[TL|TLs],
    \+TL==variable,
    trterml(TLs,QLs),
    Q=..[TL|QLs].

trterml([],[]).
trterml([T|Ts],Q):-
    trterm(T,Q0),
    trterml(Ts,Qs),
    Q=[Q0|Qs].

% --------------------------------------------------------------------
% 
% --------------------------------------------------------------------
rewrite_term(T,Q,B):-
    with_output_to(atom(A),write(T)),
    atom_to_term(A,Q,B).

rewrite_term(T,Q):-
    with_output_to(atom(A),write(T)),
    term_to_atom(Q,A).

rewrite_atom(T,A):-
    with_output_to(atom(A),write(T)).

% --------------------------------------------------------------------
% 
% --------------------------------------------------------------------
tcontoa(true,true,Z):-
    with_output_to(atom(Z),write(true)).
tcontoa(T,true,Z):-
    with_output_to(atom(Z),write(T)).
tcontoa(true,Q,Z):-
    with_output_to(atom(Z),write(Q)).
tcontoa(T,Q,Z):-
    with_output_to(atom(Z),(write('('),write(T),write(')'),write(','),write('('),write(Q),write(')'))).

% --------------------------------------------------------------------
% Terme konkatenieren T,Q -> (T,Q).
% --------------------------------------------------------------------
tconcat(T,Q,Z):-
    tcontoa(T,Q,Z0),
    term_to_atom(Z,Z0).

