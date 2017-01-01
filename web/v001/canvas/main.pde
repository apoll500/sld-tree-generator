/*******************************************************************************
*                                                                              *
*  main.pde                                                                    *
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
//This is no comment!
//If set to true, this gives the canvas focus to all
//keyboard events directed to the frame of the canvas.
/* @pjs globalKeyEvents="false"; */

//--------------------------------------------------------
// Golable Variablen:
//--------------------------------------------------------
//Alle globalen JS-Variablen sind in JS-Dateien deklariert.

//--------------------------------------------------------
// Canvas Setup.
//--------------------------------------------------------
void setup()
{
    setProcessing(this);
    size(screenx-rframew,screeny);
    strokeWeight(1);
    frameRate(30);
    globalGraphicParameter=new GlobalParameter();
    globalGraphicParameter.fontA=loadFont("arial");
	global_DOM_main_canvas=document.getElementById("main_canvas");
    js_event_handling_setup();
    js_start();
}

//--------------------------------------------------------
// die Haupt-Zeichenfunktion
//--------------------------------------------------------
void draw()
{
    background(globalGraphicParameter.main_bgcolor);
    globalGraphicParameter.setTextSize();
    if(globalRootTree)
    {
        globalRootTree.draw();
        globalRootTree.draw_nodes();
        //Infoframe popin -------------------------------
        if(globalGraphicParameter.iwin.visible)
        {
            globalGraphicParameter.iwin.draw();
        }
        if(globalSelectedSubtree)globalSelectedSubtree.node.draw_info();
    }
	if(global_DOM_main_canvas!=document.activeElement)
	{
		fill(50,50,50,200);
		rect(0,0,screenx,screeny);
	}
}
