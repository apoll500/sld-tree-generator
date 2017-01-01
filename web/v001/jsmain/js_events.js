/*******************************************************************************
*                                                                              *
*  js_events.js                                                                *
*                                                                              *
*  This file is part of "sld-tree-generator". (this program)                   *
*                                                                              *
*  Copyright (C) 2016 by Andreas Pollhammer                                    *
*                                                                              *
*  Email: apoll500@gmail.com                                                   *
*  Web:   http://www.andreaspollhammer.com                                     *
*                                                                              *
*******************************************************************************/
/*******************************************************************************
*                                                                              *
*  Licensed under GPLv3:                                                       *
*                                                                              *
*  This program is free software: you can redistribute it and/or modify        *
*  it under the terms of the GNU General Public License as published by        *
*  the Free Software Foundation, either version 3 of the License, or           *
*  (at your option) any later version.                                         *
*                                                                              *
*  This program is distributed in the hope that it will be useful,             *
*  but WITHOUT ANY WARRANTY; without even the implied warranty of              *
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               *
*  GNU General Public License for more details.                                *
*                                                                              *
*  You should have received a copy of the GNU General Public License           *
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.       *
*                                                                              *
*******************************************************************************/
//--------------------------------------------------------
// Globale Variablen:
//--------------------------------------------------------

var global_js_event;

//--------------------------------------------------------
// Setup:
//--------------------------------------------------------

function js_event_handling_setup()
{
    global_js_event=new theProcessingObject.JSEventHandler();
}

//--------------------------------------------------------
// Input-Events erzeugt von JS/HTML:
//--------------------------------------------------------

function mainwin_resize()
{
    screenx=window.innerWidth;
    screeny=window.innerHeight-47;
    global_js_event.onResize();
}
