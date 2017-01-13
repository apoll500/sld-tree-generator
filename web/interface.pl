% -----------------------------------------------------------------------------+
%                                                                              |
%  interface.pl                                                                |
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
:-module(http_server,[server/1]).

:-use_module(library(http/thread_httpd)).
:-use_module(library(http/http_dispatch)).
:-use_module(library(http/html_write)).
:-use_module(library(http/http_parameters)).
:-use_module(library(uri)).
:-use_module(library(http/http_error)).
:-use_module(library(http/http_client)).

% ------------------------------------------------------------------------------
% Serving files via http
% ------------------------------------------------------------------------------
% This files are available to everyone (not just localhost).

% Website icon
:-http_handler('/favicon.ico',                          http_reply_file('web/favicon.ico',[]),[]).

% Webspace root-directory index.html
:-http_handler('/index.html',                           http_reply_file('web/index.html',[]),[]).
:-http_handler('/',                                     http_reply_file('web/index.html',[]),[]).

% Test-Version (v0000)
:-http_handler('/sld/test/test.html',                   http_reply_file('web/v000/test.html',[]),[]).
:-http_handler('/sld/test/http.js',                     http_reply_file('web/v000/http.js',[]),[]).

% Files for Version 0001 (path /sld/)
:-http_handler('/sld/index.html',                       http_reply_file('web/v001/index.html',[]),[]).
:-http_handler('/sld/',                                 http_reply_file('web/v001/index.html',[]),[]).
:-http_handler('/sld/canvas/main.pde',                  http_reply_file('web/v001/canvas/main.pde',[]),[]).
:-http_handler('/sld/canvas/events.pde',                http_reply_file('web/v001/canvas/events.pde',[]),[]).
:-http_handler('/sld/canvas/animation/animator.pde',    http_reply_file('web/v001/canvas/animation/animator.pde',[]),[]).
:-http_handler('/sld/canvas/animation/properties.pde',  http_reply_file('web/v001/canvas/animation/properties.pde',[]),[]).
:-http_handler('/sld/canvas/math/math.pde',             http_reply_file('web/v001/canvas/math/math.pde',[]),[]).
:-http_handler('/sld/canvas/processing/processing.js',  http_reply_file('extern/processing/processing.js',[]),[]).
:-http_handler('/sld/canvas/treedata/treedata.pde',     http_reply_file('web/v001/canvas/treedata/treedata.pde',[]),[]).
:-http_handler('/sld/canvas/treedata/posnodes.pde',     http_reply_file('web/v001/canvas/treedata/posnodes.pde',[]),[]).
:-http_handler('/sld/canvas/treedata/loadjson.js',      http_reply_file('web/v001/canvas/treedata/loadjson.js',[]),[]).
:-http_handler('/sld/css/styles.css',                   http_reply_file('web/v001/css/styles.css',[]),[]).
:-http_handler('/sld/dialogue/clauses.html',            http_reply_file('web/v001/dialogue/clauses.html',[]),[]).
:-http_handler('/sld/dialogue/clist.pde',               http_reply_file('web/v001/dialogue/clist.pde',[]),[]).
:-http_handler('/sld/dialogue/debug.html',              http_reply_file('web/v001/dialogue/debug.html',[]),[]).
:-http_handler('/sld/dialogue/newgoal.html',            http_reply_file('web/v001/dialogue/newgoal.html',[]),[]).
:-http_handler('/sld/dialogue/program.html',            http_reply_file('web/v001/dialogue/program.html',[]),[]).
:-http_handler('/sld/dialogue/settings.html',           http_reply_file('web/v001/dialogue/settings.html',[]),[]).
:-http_handler('/sld/dialogue/error.html',              http_reply_file('web/v001/dialogue/error.html',[]),[]).
:-http_handler('/sld/help/info.html',                   http_reply_file('web/v001/help/info.html',[]),[]).
:-http_handler('/sld/help/help.html',                   http_reply_file('web/v001/help/help.html',[]),[]).
:-http_handler('/sld/help/keys.html',                   http_reply_file('web/v001/help/keys.html',[]),[]).
:-http_handler('/sld/help/mouse.html',                  http_reply_file('web/v001/help/mouse.html',[]),[]).
:-http_handler('/sld/help/contact.html',                http_reply_file('web/v001/help/contact.html',[]),[]).
:-http_handler('/sld/help/examples.html',               http_reply_file('web/v001/help/examples.html',[]),[]).
:-http_handler('/sld/help/step1.html',                  http_reply_file('web/v001/help/step1.html',[]),[]).
:-http_handler('/sld/help/step2.html',                  http_reply_file('web/v001/help/step2.html',[]),[]).
:-http_handler('/sld/help/step3.html',                  http_reply_file('web/v001/help/step3.html',[]),[]).
:-http_handler('/sld/images/home.png',                  http_reply_file('web/v001/images/home.png',[]),[]).
:-http_handler('/sld/jsmain/http.js',                   http_reply_file('web/v001/jsmain/http.js',[]),[]).
:-http_handler('/sld/jsmain/js_events.js',              http_reply_file('web/v001/jsmain/js_events.js',[]),[]).
:-http_handler('/sld/jsmain/receive.js',                http_reply_file('web/v001/jsmain/receive.js',[]),[]).
:-http_handler('/sld/parser/dfa.js',                    http_reply_file('web/v001/parser/dfa.js',[]),[]).
:-http_handler('/sld/parser/reader.js',                 http_reply_file('web/v001/parser/reader.js',[]),[]).
:-http_handler('/sld/parser/treepars.js',               http_reply_file('web/v001/parser/treepars.js',[]),[]).
:-http_handler('/sld/pwin/pwin.js',                     http_reply_file('web/v001/pwin/pwin.js',[]),[]).
:-http_handler('/sld/pwin/blanc.html',                  http_reply_file('web/v001/pwin/blanc.html',[]),[]).
:-http_handler('/sld/pwin/images/simple/b0x.png',       http_reply_file('web/v001/pwin/images/simple/b0x.png',[]),[]).
:-http_handler('/sld/pwin/images/simple/b1x.png',       http_reply_file('web/v001/pwin/images/simple/b1x.png',[]),[]).
:-http_handler('/sld/pwin/images/simple/b2.png',        http_reply_file('web/v001/pwin/images/simple/b2.png',[]),[]).
:-http_handler('/sld/pwin/images/simple/i0.png',        http_reply_file('web/v001/pwin/images/simple/i0.png',[]),[]).
:-http_handler('/sld/pwin/images/simple/l0.png',        http_reply_file('web/v001/pwin/images/simple/l0.png',[]),[]).
:-http_handler('/sld/pwin/images/simple/r0.png',        http_reply_file('web/v001/pwin/images/simple/r0.png',[]),[]).
:-http_handler('/sld/pwin/images/simple/r0x.png',       http_reply_file('web/v001/pwin/images/simple/r0x.png',[]),[]).
:-http_handler('/sld/pwin/images/simple/t0.png',        http_reply_file('web/v001/pwin/images/simple/t0.png',[]),[]).
:-http_handler('/sld/pwin/images/simple/t1_0.png',      http_reply_file('web/v001/pwin/images/simple/t1_0.png',[]),[]).
:-http_handler('/sld/pwin/images/simple/t1_1.png',      http_reply_file('web/v001/pwin/images/simple/t1_1.png',[]),[]).
:-http_handler('/sld/pwin/images/simple/t2.png',        http_reply_file('web/v001/pwin/images/simple/t2.png',[]),[]).
:-http_handler('/sld/pwin/images/simple/t3.png',        http_reply_file('web/v001/pwin/images/simple/t3.png',[]),[]).
:-http_handler('/sld/pwin/images/simple/t4.png',        http_reply_file('web/v001/pwin/images/simple/t4.png',[]),[]).
:-http_handler('/sld/pwin/images/simple/t5.png',        http_reply_file('web/v001/pwin/images/simple/t5.png',[]),[]).
:-http_handler('/sld/pwin/images/simple/t6.png',        http_reply_file('web/v001/pwin/images/simple/t6.png',[]),[]).
:-http_handler('/sld/pwin/images/simple/t7.png',        http_reply_file('web/v001/pwin/images/simple/t7.png',[]),[]).
:-http_handler('/sld/pwin/images/simple/ibg.png',       http_reply_file('web/v001/pwin/images/simple/ibg.png',[]),[]).
:-http_handler('/sld/pwin/images/circle3.gif',          http_reply_file('web/v001/pwin/images/circle3.gif',[]),[]).

% Documentation
:-http_handler('/sld/docu/webui.pdf',                   http_reply_file('docu/webui.pdf',[]),[]).

% Translations
:-http_handler('/sld/lang/de-at.js',                   http_reply_file('web/v001/lang/de-at.js',[]),[]).
:-http_handler('/sld/lang/en-us.js',                   http_reply_file('web/v001/lang/en-us.js',[]),[]).

% This redirects all requests for /prolog to predicate main.
:-http_handler('/prolog',main,[]).

% ------------------------------------------------------------------------------
% server/1
% ------------------------------------------------------------------------------
% server(Port)
% This starts the http-server on port Port.
% ------------------------------------------------------------------------------
server(Port):-
    http_server(http_dispatch,[port(Port)]).

% ------------------------------------------------------------------------------
% main/1
% ------------------------------------------------------------------------------
% main(Request)
% Handels the http request Request.
% This is the predicate for requests regarding path /prolog.
% ------------------------------------------------------------------------------
main(Request):-
    % Hier ggf. verlangen, dass Aufrufe nur von
    % localhost kommen duerfen.
    member(host(localhost),Request),
    format('Content-type: text/plain~n'),
    format('Connection: close~n~n'),
    get_par_e(Request,EventTerm),
    run_event(EventTerm).

main(_Request):-
    format('fail.').

% ------------------------------------------------------------------------------
% run_event/1
% ------------------------------------------------------------------------------
% run_event(EventTerm)
% Handels user-events (user-interaction).
% EventTerm ... a term representing the user-event.
% ------------------------------------------------------------------------------
run_event(EventTerm):-
    ui_event(EventTerm),
    garbage_collect.

run_event(_EventTerm):-
    format('fail.'),
    garbage_collect.

% ------------------------------------------------------------------------------
% get_par_e/2
% ------------------------------------------------------------------------------
% get_par_e(Request,EventTerm)
% Converts GET and POST parameters into a prolog term.
% Request ..... a http request.
% EventTerm ... a term representing the user-event.
% ------------------------------------------------------------------------------
get_par_e(Request,EventTerm):-
    http_parameters(Request,[e(Event,_)]),
    \+Event=[],
    with_output_to(atom(EventAtom),write(Event)),
    term_to_atom(EventTerm,EventAtom).

get_par_e(Request,EventTerm):-
    http_read_data(Request,EventAtom,[to(atom)]),
    term_to_atom(EventTerm,EventAtom).
