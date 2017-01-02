% -----------------------------------------------------------------------------+
%                                                                              |
%  download.pl                                                                 |
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
:-use_module(library(ssl)).
:-use_module(library(http/http_open)).
:-use_module(library(http/http_ssl_plugin)).

download:-
    File='https://raw.githubusercontent.com/processing-js/processing-js/v1.4.8/processing.js',
    write('downloading '),write(File),write(' ...'),
    http_open(File,In,[]),
    open('extern/processing/processing.js',write,_Fd,[alias(output)]),
    copy_stream_data(In,output),
    write(' OK'),nl,
    close(output),
    close(In).
    
:-download.
