/*******************************************************************************
*                                                                              *
*  events.pde                                                                  *
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
// Input Events von JS/HTML:
//--------------------------------------------------------

class JSEventHandler
{
    void onResize()
    {
        size(screenx-rframew,screeny);
		document.getElementById("RFRAME").style.height=screeny+"px";
		document.getElementById("RFRAME").style.width=rframew+"px";
        window.rframe.offsetx=window.innerWidth-rframew;
        window.rframe.offsety=window.innerHeight-screeny;
    }
}

//--------------------------------------------------------
// Input Events von Processing:
//--------------------------------------------------------

//MOUSE-MOVE
void mouseMoved()
{
    //nothing.
}

//MOUSE-CLICK
void mouseClicked()
{
    //nothing.
}

Tree clicked_object=null;
boolean infobox_active=false;

//MOUSE-DOWN
void mousePressed()
{
    switch(mouseButton)
    {
        case LEFT:
            if(globalRootTree)
            {
                boolean ininfo=globalGraphicParameter.iwin.inside(mouseX,mouseY);
                if(globalGraphicParameter.iwin.visible && ininfo)
                {
                    infobox_active=true;
                    return;
                }
                if(!ininfo)
                {
                    globalGraphicParameter.iwin.visible=false;
                }
                
                Tree s=globalRootTree.findFromPoint(mouseX,mouseY);
                if(s)
                {
                    globalSelectedSubtree=s;
                    clicked_object=globalSelectedSubtree;
                    globalSelectedSubstSubtree=null;
                }
                else
                {
                    clicked_object=null;
                    
                    if(globalGraphicParameter.subst_click)
                    {
                        globalSelectedSubstSubtree=globalRootTree.findSubstFromPoint(mouseX,mouseY);
                        if(globalSelectedSubstSubtree)
                        {
                            globalGraphicParameter.iwin.visible=true;
                            globalGraphicParameter.iwin.refX=globalSelectedSubstSubtree.node.uposX+globalSelectedSubstSubtree.node.uwidth;
                            globalGraphicParameter.iwin.refY=globalSelectedSubstSubtree.node.uposY;
                            globalGraphicParameter.iwin.posX=globalSelectedSubstSubtree.node.uposX+globalSelectedSubstSubtree.node.uwidth+100*globalGraphicParameter.scale;
                            globalGraphicParameter.iwin.posY=globalSelectedSubstSubtree.node.uposY-100*globalGraphicParameter.scale;
                        }
                    }
                }
            }
            break;
        case RIGHT:
            break;
        case CENTER:
            break;
    }
}

void mouseReleased()
{
    infobox_active=false;
}

void mouseDragged()
{
    switch(mouseButton)
    {
        case LEFT:
            if(infobox_active)
            {
                globalGraphicParameter.iwin.posX+=mouseX-pmouseX;
                globalGraphicParameter.iwin.posY+=mouseY-pmouseY;
            }
            else if(!globalGraphicParameter.iwin.visible)
            {
                if(clicked_object && globalGraphicParameter.allow_xdrag)
                {
                    globalSelectedSubtree.node.pos.x.setParameter(globalSelectedSubtree.node.pos.x.getParameter()+mouseX-pmouseX);
                }
                else
                {
                    globalGraphicParameter.scrollx+=mouseX-pmouseX;
                    globalGraphicParameter.scrolly+=mouseY-pmouseY;
                }
            }
            break;
        case RIGHT:
            break;
        case CENTER:
            break;
    }
}

//Keyboard input
void keyTyped()
{
    globalGraphicParameter.iwin.visible=false;
    
    switch(key)
    {
        case 'c':
        case 'C':
            if(globalSelectedSubtree && globalSelectedSubtree.node.goal.str!="-")
            {
                globalRootTree=globalSelectedSubtree;
                globalRootTree.parenttree=null;
                new MyWalker().posNodes(globalRootTree,true);
                globalGraphicParameter.scrollx=0;
                globalGraphicParameter.scrolly=0;
            }
            break;
        case 'x':
        case 'X':
            if(globalSelectedSubtree && globalSelectedSubtree.node.goal.str!="true" && globalSelectedSubtree.node.goal.str!="-")
            {
                globalSelectedSubtree.subtrees=new Tree[0];
                new Tree(new Node(-1,"-",0,"variant(true)",[],[],[],globalGraphicParameter),null,globalGraphicParameter,globalSelectedSubtree);
                new MyWalker().posNodes(globalRootTree,true);
                globalGraphicParameter.scrollx=0;
                globalGraphicParameter.scrolly=0;
            }
            break;
        case '+':
            dozoom(1);
            break;
        case '-':
            dozoom(-1);
            break;
        case 'j':
            globalGraphicParameter.scrollx+=10;
            break;
        case 'k':
            globalGraphicParameter.scrollx-=10;
            break;
        case 'i':
            globalGraphicParameter.scrolly+=10;
            break;
        case 'm':
            globalGraphicParameter.scrolly-=10;
            break;
        case 'J':
            globalGraphicParameter.scrollx+=100;
            break;
        case 'K':
            globalGraphicParameter.scrollx-=100;
            break;
        case 'I':
            globalGraphicParameter.scrolly+=100;
            break;
        case 'M':
            globalGraphicParameter.scrolly-=100;
            break;
        case 'o':
        case 'O':
            globalGraphicParameter.scrollx=0;
            globalGraphicParameter.scrolly=0;
            break;
        case 'f':
        case 'F':
            findSelctedNode();
            break;
        case 'h':
        case 'H':
            show_help();
            break;
        case 'p':
        case 'P':
            edit_program();
            break;
        case 's':
        case 'S':
            show_settings();
            break;
    }
    globalGraphicParameter.iwin.visible=false;
}

void dozoom(int s)
{
    globalGraphicParameter.iwin.visible=false;
    globalGraphicParameter.scale*=1+0.1*s;
    globalGraphicParameter.scale=max(0.1,min(10,globalGraphicParameter.scale));
    if(globalRootTree)new MyWalker().posNodes(globalRootTree,false);
}

//Keyboard input (special keys)
void keyPressed()
{
    globalGraphicParameter.iwin.visible=false;
    
    if(key==CODED)
    {
        switch(keyCode)
        {
            case UP:
                if(!globalSelectedSubtree.parenttree)
                {
                    askProlog("jsonParentTree",null);
                }
                else
                {
                    globalSelectedSubtree.moveup();
                }
                break;
            case DOWN:
                if(globalSelectedSubtree.node.goal.str=="-")
                {
                    askProlog("jsonSubTree",null);
                }
                else
                {
                    globalSelectedSubtree.movedown();
                }
                break;
            case LEFT:
                globalSelectedSubtree.moveleft();
                break;
            case RIGHT:
                globalSelectedSubtree.moveright();
                break;
        }
		findSelctedNode();
    }
    else if(keyCode==ENTER || keyCode==RETURN)
    {
        onKeyEnter();
    }
}

void findSelctedNode()
{
	if(globalSelectedSubtree)
	{
		if(globalSelectedSubtree.node.getX()+globalGraphicParameter.scrollx+globalSelectedSubtree.node.width>screenx-rframew)
		{
			globalGraphicParameter.scrollx-=globalSelectedSubtree.node.getX()+globalGraphicParameter.scrollx+globalSelectedSubtree.node.width-screenx+rframew+5;
		}
		else if(globalSelectedSubtree.node.getX()+globalGraphicParameter.scrollx<0)
		{
			globalGraphicParameter.scrollx+=-(globalSelectedSubtree.node.getX()+globalGraphicParameter.scrollx)+5;
		}
		if(globalSelectedSubtree.node.getY()+globalGraphicParameter.scrolly+globalSelectedSubtree.node.getH()>screeny-120)
		{
			globalGraphicParameter.scrolly-=globalSelectedSubtree.node.getY()+globalGraphicParameter.scrolly+globalSelectedSubtree.node.getH()-screeny+120;
		}
		else if(globalSelectedSubtree.node.getY()+globalGraphicParameter.scrolly<0)
		{
			globalGraphicParameter.scrolly+=-(globalSelectedSubtree.node.getY()+globalGraphicParameter.scrolly)+5;
		}
	}
}

void onKeyEnter()
{
    globalSelectedSubstSubtree=null;
    if(globalSelectedSubtree.node.goal.str=="-")
    {
        askProlog("jsonSubTree",null);
    }
    else
    {
		globalGraphicParameter.iwin.visible=true;
        askProlog("prologAnswer",null);
    }
}
