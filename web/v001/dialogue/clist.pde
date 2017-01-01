/*******************************************************************************
*                                                                              *
*  clist.pde                                                                   *
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
// Golable Variablen:
//--------------------------------------------------------
Term cltext=null;

//--------------------------------------------------------
// Canvas Setup.
//--------------------------------------------------------
void setup()
{
    strokeWeight(1);
    frameRate(2);
    parent.theClistProcessingObject=this;
    getClauseList();
    size(window.innerWidth,200);
}

//--------------------------------------------------------
// Die Haupt-Zeichenfunktion
//--------------------------------------------------------
void draw()
{
    if(!parent.globalGraphicParameter || !cltext)return;
    globalGraphicParameter=parent.globalGraphicParameter;
    size(max(cltext.max_x,window.innerWidth),max(cltext.lasty-10,25));
    if(globalGraphicParameter.draw_goal_box)
    {
        background(globalGraphicParameter.color_goal_box.getR(),globalGraphicParameter.color_goal_box.getG(),globalGraphicParameter.color_goal_box.getB(),globalGraphicParameter.color_goal_box.getA());
    }
    else
    {
        background(globalGraphicParameter.main_bgcolor);
    }
    globalGraphicParameter.sizep=2;
    //float fontsize=globalGraphicParameter.fontSize();
    //if(fontsize>18){fontsize=18;textFont(globalGraphicParameter.fontA,fontsize);}
    //if(fontsize<14){fontsize=14;textFont(globalGraphicParameter.fontA,fontsize);}
	
	fill(50,50,50,200);
	rect(5,10,1.55*globalGraphicParameter.fontSize(),1200);
		
    textFont(globalGraphicParameter.fontA,globalGraphicParameter.fontSize());
    cltext.draw(10,globalGraphicParameter.fontSize()*1.5);
}

void setList(String clauseList)
{
    cltext=new Term(clauseList);
}
