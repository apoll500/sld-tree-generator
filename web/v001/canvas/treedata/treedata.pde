/*******************************************************************************
*                                                                              *
*  treedata.pde                                                                *
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
class PrologTerm
{
    String str;
    PrologTerm()
    {
        str=null;
    }
    PrologTerm(String t)
    {
        str=t;
    }
    void printHTML()
    {
    }
}

class InfoWin
{
    boolean visible=false;
    int content=1;
    Term answer=null;
    float posX=200,posY=200,width=200,height=200;
    float refX=500,refY=500;
    void draw()
    {
        fill(globalGraphicParameter.infotext_bgcolor);
        stroke(globalGraphicParameter.infotext_bordercolor);
        strokeWeight(3);
        rect(posX,posY,width,height,globalGraphicParameter.scale*10);
        strokeWeight(1);
        
        //Text

        fill(globalGraphicParameter.infotext_bordercolor);
        if(refX<posX)
        {
            triangle(refX,refY,
                     posX,posY+globalGraphicParameter.scale*20,
                     posX,posY+globalGraphicParameter.scale*50);
        }
        else if(refX>posX+width)
        {
            triangle(refX,refY,
                     posX+width,posY+globalGraphicParameter.scale*20,
                     posX+width,posY+globalGraphicParameter.scale*50);
        }
        else
        {
            if(refY<posY)
            {
                triangle(refX,refY,
                         posX+globalGraphicParameter.scale*20,posY,
                         posX+globalGraphicParameter.scale*50,posY);
            }
            else if(refY>posY+height)
            {
                triangle(refX,refY,
                         posX+globalGraphicParameter.scale*20,posY+height,
                         posX+globalGraphicParameter.scale*50,posY+height);
            }
        }
        if(globalSelectedSubstSubtree)
        {
            fill(globalGraphicParameter.infotext_color);
            text(gttext["info_subs"]+":",posX+3,posY+globalGraphicParameter.fontSize());
            float w=globalSelectedSubstSubtree.node.draw_subs_i(posX+3,posY+globalGraphicParameter.fontSize()*2);
            height=max(globalGraphicParameter.scale*70,globalGraphicParameter.fontSize()*(globalSelectedSubstSubtree.node.unificator.length+2));
            width=max(textWidth(gttext["info_subs"]+":"),w)+6;
        }
        else if(globalSelectedSubtreeRequest && answer)
        {
            fill(globalGraphicParameter.infotext_color);
            text(gttext["info_answ"]+":",posX+3,posY+globalGraphicParameter.fontSize());
            float w=answer.draw(posX+3,posY+globalGraphicParameter.fontSize()*2)-posX-3;
            height=max(globalGraphicParameter.scale*70,globalGraphicParameter.fontSize()*(globalSelectedSubtreeRequest.node.unificator.length+2));
            width=max(textWidth(gttext["info_answ"]+":"),w)+6;
        }
    }
    boolean inside(int x,int y)
    {
        return x>posX && x<posX+width && y>posY && y<posY+height;
    }
}

class GlobalParameter
{
    //Abstaende und Skalierung
    int left=100;
    int top=100;
    float levelh=100.0;
    float scale=1.0;
    float xpos_scale=1.0;
    float xspacing=10.0;
    float textSize=16;
    
    //Elemente aus-/einblenden.
    boolean draw_goal_box=true;
    boolean draw_nodeid=false;
    boolean draw_clauseid=true;
    boolean draw_subst=true;
    
    //Darstellungsoptionen
    boolean rotate_substext=false;
    
    //Animierbare Farben
    AnimColor color_goal_box=new AnimColor(0,0,0,255);
    AnimColor color_goal_box_border=new AnimColor(255,255,255,255);
    
    //Restliche Farben
    color main_bgcolor=color(33,121,184);
    color edge_color=color(255,255,255,255);
    color infotext_color=color(255,255,255,255);//color(0,0,0,255);
    color infotext_bordercolor=color(255,255,255,155);
    color infotext_bgcolor=color(10,90,160,205);//color(255,255,200,155);
    color nodetxt_color=color(255,255,255);
    color nodelit_color=color(255,200,100);
    color nodefun_color=color(200,255,100);
    color nodevar_color=color(100,200,255);
    color mark_color=color(255,0,0,255);
    color mark_bgcolor=color(160,0,0,255);
    
    //Scrolling
    float scrollx=0;
    float scrolly=0;
    
    InfoWin iwin=new InfoWin();
    
    //Font Parameter
    PFont fontA;
    int sizep=0;
    float fontSize()
    {
        if(sizep!=0)return min(22,max(12,textSize*scale));
        return textSize*scale;
    }
    void setTextSize()
    {
        sizep=0;
        textFont(fontA,fontSize());
    }
    void setTextSize2()
    {
        sizep=2;
        textFont(fontA,fontSize());
    }
    
    //Optionen fuer die Interaktion
    boolean allow_xdrag=false;
    boolean subst_click=true;
    
    //Presets
    void set_standard()
    {
        color_goal_box.setAnim(0,0,0,255,500);
        color_goal_box_border.setAnim(255,255,255,255,500);
        main_bgcolor=color(33,121,184);
        edge_color=color(255,255,255,255);
        infotext_color=color(255,255,255,255);
        infotext_bordercolor=color(255,255,255,155);
        infotext_bgcolor=color(10,90,160,205);//color(255,255,200,155);
        nodetxt_color=color(255,255,255);
        nodelit_color=color(255,200,100);
        nodefun_color=color(200,255,100);
        nodevar_color=color(100,200,255);
        mark_color=color(255,0,0,255);
        mark_bgcolor=color(160,0,0,255);
        draw_subst=true;
    }
    void set_simple()
    {
        color_goal_box.setAnim(255,255,255,255,500);
        color_goal_box_border.setAnim(0,0,0,255,500);
        main_bgcolor=color(255,255,255);
        edge_color=color(0,0,0,255);
        infotext_color=color(0,0,0,255);
        infotext_bordercolor=color(0,0,0,255);
        infotext_bgcolor=color(255,255,255,205);
        nodetxt_color=color(0,0,0);
        nodelit_color=color(200,100,0);
        nodefun_color=color(50,100,0);
        nodevar_color=color(0,50,255);
        mark_color=color(0,0,0,255);
        mark_bgcolor=color(200,200,200,255);
        draw_subst=true;
    }
    void set_black()
    {
        set_standard();
        color_goal_box.setAnim(0,0,0,255,500);
        color_goal_box_border.setAnim(0,0,0,255,500);
        main_bgcolor=color(0,0,0);
        draw_subst=true;
    }
    void set_black2()
    {
        set_standard();
        color_goal_box.setAnim(255,255,255,255,500);
        color_goal_box_border.setAnim(0,0,0,255,500);
        main_bgcolor=color(0,0,0);
        nodetxt_color=color(0,0,0);
        nodelit_color=color(200,100,0);
        nodefun_color=color(50,100,0);
        nodevar_color=color(0,50,255);
        infotext_color=color(0,0,0,255);
        infotext_bordercolor=color(255,255,255,255);
        infotext_bgcolor=color(255,255,255,205);
        draw_goal_box=true;
        draw_subst=false;
    }
}

class Element
{
    String str;
    int lines=0;
    void printHTML();
    int draw(int x,int y);
    void setLines()
    {
        lines=split(str,"\n").length;
    }
    String export_svg(int x,int y)
    {
        return str;
    }
}

class Variable extends Element
{
    int index;
    //AnimPosition local;
    Variable(String n,int i)
    {
        str=n;
        index=i;
        setLines();
    }
    Variable(String n)
    {
        str=n;
        index=0;
        setLines();
    }
    void printHTML()
    {
    }
    void prompt()
    {
        alert("Variable: "+str+"_"+index);
    }
    int draw(int x,int y)
    {
        fill(globalGraphicParameter.nodevar_color);
        text(str,x,y);
        int w=textWidth(str);
        if(index!=0)
        {
            text(index,x+w,y+5);
            w+=textWidth(index);
        }
        return w;
    }
}

class Operator extends Element
{
    Operator(String o)
    {
        str=o;
        setLines();
    }
    void printHTML()
    {
    }
    int draw(int x,int y)
    {
        fill(globalGraphicParameter.nodetxt_color);
        text(str,x,y);
        int e=0;if(str=="," || str==".")e=textWidth(" ");
        return textWidth(str)+e;
    }
}

class Predicate extends Element
{
    Predicate(String a)
    {
        str=a;
        setLines();
    }
    void printHTML()
    {
    }
    int draw(int x,int y)
    {
        text(str,x,y);
        return textWidth(str);
    }
}

class Functor extends Element
{
    Functor(String a)
    {
        str=a;
        setLines();
    }
    void printHTML()
    {
    }
    int draw(int x,int y)
    {
        fill(globalGraphicParameter.nodefun_color);
        text(str,x,y);
        return textWidth(str);
    }
}

class Text extends Element
{
    Text(String a)
    {
        str=a;
        setLines();
    }
    void printHTML()
    {
    }
    int draw(int x,int y)
    {
        fill(200);
        text(str,x,y);
        return textWidth(str);
    }
}

class Literal extends Element
{
    Literal(String a)
    {
        str=a;
        setLines();
    }
    void printHTML()
    {
    }
    int draw(int x,int y)
    {
        fill(globalGraphicParameter.nodelit_color);
        text(str,x,y);
        return textWidth(str);
    }
}

class CNumber extends Element
{
    int id;
    CNumber(String a)
    {
        str=a;
        id=int(a);
        setLines();
    }
    void printHTML()
    {
    }
    int draw(int x,int y)
    {
        float r=globalGraphicParameter.fontSize()/2;
        y-=r;
        x+=r;
        fill(255);
        stroke(255);
        ellipse(x,y,2*r,2*r)
        fill(0);
        if(id<10)text(str,x-r*.66,y+r*.78);
        else if(id<100000)text(str,x-r*1.16,y+r*.78);
        else text("0",x-r*.66,y+r*.78);
        return 0;
        //return textWidth(str);
    }
}

class Term
{
    String str;
    Element[] elements=[];
    float lasty=100;
	float max_x=100;
    float left=10;
    Term(String g)
    {
        str=g;
        parseString(createDfa_TermParse(),str+".",this);
    }
    void addFunctor(String name)
    {
        append(elements,new Functor(name));
    }
    void addVariable(String name)
    {
        append(elements,new Variable(name));
    }
    void addVariable(String name,int index)
    {
        append(elements,new Variable(name,index));
    }
    void addLiteral(String name)
    {
        append(elements,new Literal(name));
    }
    void addCNumber(String name)
    {
        append(elements,new CNumber(name));
    }
    void addText(String name)
    {
        append(elements,new Text(name));
    }
    void addOperator(String name)
    {
        append(elements,new Operator(name));
    }
    float draw(float x,float y)
    {
        fill(globalGraphicParameter.nodetxt_color);
        for(int i=0;i<elements.length;i++)
        {
            x+=elements[i].draw(x,y);
			max_x=max(max_x,x+25);
            if(elements[i].lines>1)
            {
                y+=(elements[i].lines-1)*globalGraphicParameter.fontSize();
                x=left;
            }
        }
        lasty=y;
        return x;
    }
    String export_svg(int x,int y)
    {
        return str;
    }
}

class Substitution
{
    Variable variable;
    Term term;
    Substitution(String name,int index,String t)
    {
        variable=new Variable(name,index);
        term=new Term(t);
    }
    void prompt()
    {
        alert(gttext["info_subs"]+": "+variable.name+"_"+variable.index+"="+term);
    }
    int draw(int x,int y)
    {
        x+=variable.draw(x,y);
        fill(globalGraphicParameter.nodetxt_color);
        text("=",x,y);
        x+=textWidth("=");
        x=term.draw(x,y);
        return x;
    }
    String export_svg(int x,int y)
    {
        String a=variable.export_svg(x,y);
        a+="=";
        a+=term.export_svg(x,y);
        return a;
    }
}

interface Option
{
}

class PathOption implements Option
{
    String path;
}

class Goal extends Term
{
    Goal(String g)
    {
        str=g;
        parseString(createDfa_TermParse(),str+".",this);
    }
    float draw(float x,float y)
    {
        fill(globalGraphicParameter.nodetxt_color);
        int w=textWidth("?- ");
        text("?- ",x-w,y);
        for(int i=0;i<elements.length;i++)
        {
            x+=elements[i].draw(x,y);
        }
        return x;
    }
    String export_svg(float x,float y)
    {
        return "<text x=\""+x+"\" y=\""+y+"\" xml:space=\"preserve\" style=\"font-size:28px;font-style:normal;font-weight:normal;text-align:left;line-height:125%;letter-spacing:0px;word-spacing:0px;text-anchor:middle;fill:#000000;fill-opacity:1;stroke:none;font-family:Sans\">?- "+str+"</text>\n";
    }
}

class Clause
{
    int id;
    Term clause;
    Clause(int cid,String cl)
    {
        id=cid;
        clause=new Term(cl);
    }
    void draw(float fontsize)
    {
        fill(globalGraphicParameter.infotext_color);
        int x=10;
        int y=screeny-100+fontsize;
        
        text(gttext["info_clau"]+": ",x,y);
        x+=textWidth(gttext["info_clau"]+": ");
        if(id)text(id,x,y);
        
        x=10;
        y+=fontsize;
        text(gttext["info_vari"]+": ",x,y);
        x+=textWidth(gttext["info_vari"]+": ");
        if(id)x+=clause.draw(x,y);
        
        //x=10;
        //y+=fontsize;
    }
}

class Node
{
    int id;
    Goal goal;
    Clause clause;
    
    Tree t;
    
    Substitution[] unificator=[];
    float uposX=0,uposY=0,uwidth=0;
    
    Option[] options;
    Variable[] variables;
    AnimPosition<float> pos=new AnimPosition<float>(0.0,0.0);
    GlobalParameter g;
    float width=0;
    float height=1;
    float new_x,old_x,new_y,old_y;
	
	float prevRightDist;
	
    Node(int i,String gl,int cid,String c,Substitution[] s,Option[] o,Variable[] v,GlobalParameter gp)
    {
        id=i;
        goal=new Goal(gl);
        clause=new Clause(cid,c);
        if(s)unificator=s;
        options=o;
        variables=v;
        g=gp;
    }
    float getX()
    {
        return pos.getX()*globalGraphicParameter.xpos_scale+globalGraphicParameter.left-30*globalGraphicParameter.scale;
    }
    float getY()
    {
        return pos.getY()*globalGraphicParameter.levelh*globalGraphicParameter.scale+globalGraphicParameter.top-20*globalGraphicParameter.scale;
    }
    float getH()
    {
        return height*30*globalGraphicParameter.scale;
    }
    void setX(float x)
    {
        pos.setX(x/globalGraphicParameter.xpos_scale-globalGraphicParameter.left+30*globalGraphicParameter.scale);
    }
    void setY(float y)
    {
        pos.setY(y/globalGraphicParameter.levelh/globalGraphicParameter.scale-globalGraphicParameter.top+20*globalGraphicParameter.scale);
    }
    void setL(float l)
    {
        pos.setY(l);
    }
    void anim()
    {
        int y=pos.getY();
        pos.x.setEndParameter(old_x/globalGraphicParameter.xpos_scale-globalGraphicParameter.left+30*globalGraphicParameter.scale);
        pos.y.setEndParameter(old_y);
        pos.setAnim(new_x/globalGraphicParameter.xpos_scale-globalGraphicParameter.left+30*globalGraphicParameter.scale,new_y,500);
    }
    boolean isInNode(int x,int y)
    {
        float nx=getX()+globalGraphicParameter.scrollx;
        float ny=getY()+globalGraphicParameter.scrolly;
        return x>nx && x<nx+width && y>ny && y<ny+getH();
    }
    boolean isInSubst(int x,int y)
    {
        return x>uposX &&
                x<uposX+uwidth &&
                y>uposY-globalGraphicParameter.fontSize() &&
                y<uposY+globalGraphicParameter.fontSize()*0.5;
    }
    
    void draw_info()
    {
        //Infoframe unten -------------------------------
        float fontsize=globalGraphicParameter.fontSize();
        if(fontsize>18){fontsize=18;textFont(globalGraphicParameter.fontA,fontsize);}
        if(fontsize<14){fontsize=14;textFont(globalGraphicParameter.fontA,fontsize);}
        fontsize*=1.3;

        fill(globalGraphicParameter.infotext_bgcolor);
        stroke(globalGraphicParameter.infotext_bordercolor);
        rect(-1,screeny-100-fontsize,screenx+2,100+fontsize);
        
        if(clause.id)
        {
            fill(globalGraphicParameter.infotext_color);
            
            if(t.parenttree)
            {
                text(gttext["info_prev"]+": ",10,screeny-100);
                float w=textWidth(gttext["info_prev"]+": ?- ");
                t.parenttree.node.goal.draw(10+w,screeny-100);
            }
        
            clause.draw(fontsize);
            
            float xs=10;
            float ys=screeny-100+fontsize*3;
            fill(globalGraphicParameter.infotext_color);
            text(gttext["info_subs"]+": [",xs,ys);
            xs+=textWidth(gttext["info_subs"]+": [");
            xs=draw_subs0(xs,ys);
            fill(globalGraphicParameter.infotext_color);
            text("]",xs,ys);

            text(gttext["info_next"]+": ",10,screeny-100+fontsize*4);
            w=textWidth(gttext["info_next"]+": ?- ");
            goal.draw(10+w,screeny-100+fontsize*4);
        }
        
        //-----------------------------------------------
        globalGraphicParameter.setTextSize();
    }
    
    void draw(boolean mark)
    {
        float x=getX()+globalGraphicParameter.scrollx;
        float y=getY()+globalGraphicParameter.scrolly;
        //text(id,x,y);
        if(mark)
        {
            fill(globalGraphicParameter.mark_bgcolor);
            stroke(globalGraphicParameter.mark_color);
            rect(x-3*globalGraphicParameter.scale,y-3*globalGraphicParameter.scale,width+6*globalGraphicParameter.scale,getH()+6*globalGraphicParameter.scale,8*globalGraphicParameter.scale);
        }
        if(globalGraphicParameter.draw_goal_box && width>0)
        {
            fill(globalGraphicParameter.color_goal_box.getR(),globalGraphicParameter.color_goal_box.getG(),globalGraphicParameter.color_goal_box.getB(),globalGraphicParameter.color_goal_box.getA());
            stroke(globalGraphicParameter.color_goal_box_border.getR(),globalGraphicParameter.color_goal_box_border.getG(),globalGraphicParameter.color_goal_box_border.getB(),globalGraphicParameter.color_goal_box_border.getA());
            rect(x,y,width,getH(),5*globalGraphicParameter.scale);
        }
        else
        {
            fill(globalGraphicParameter.main_bgcolor);
            stroke(globalGraphicParameter.main_bgcolor);
            rect(x,y,width,getH(),5*globalGraphicParameter.scale);
        }
        if(goal.str=="-")
        {
            fill(globalGraphicParameter.nodetxt_color);
            text("...",x+30*globalGraphicParameter.scale,y+20*globalGraphicParameter.scale);
            width=textWidth("...")+40*globalGraphicParameter.scale;
        }
        else if(goal.str=="fail")
        {
            fill(0,0,0,255);
            text("fail.",x+10*globalGraphicParameter.scale-1,y+20*globalGraphicParameter.scale-1);
            text("fail.",x+10*globalGraphicParameter.scale+1,y+20*globalGraphicParameter.scale-1);
            text("fail.",x+10*globalGraphicParameter.scale-1,y+20*globalGraphicParameter.scale+1);
            text("fail.",x+10*globalGraphicParameter.scale+1,y+20*globalGraphicParameter.scale+1);
            fill(255,0,0,255);
            text("fail.",x+10*globalGraphicParameter.scale,y+20*globalGraphicParameter.scale);
            width=textWidth("fail.")+20*globalGraphicParameter.scale;
        }
        else
        {
            float gx=x+30*globalGraphicParameter.scale;
            float gy=y+20*globalGraphicParameter.scale;
            width=goal.draw(gx,gy)-gx+40*globalGraphicParameter.scale;
            if(globalGraphicParameter.draw_nodeid)
            {
                textFont(globalGraphicParameter.fontA,globalGraphicParameter.fontSize()/2);
                text(""+id,gx-30*globalGraphicParameter.scale,gy-globalGraphicParameter.fontSize()*1.3);
                globalGraphicParameter.setTextSize();
            }
        }
    }
    float draw_subs(int x,int y)
    {
        float x0;
        x+=2;
        uwidth=0;
        uposX=x;
        uposY=y;
        
        textFont(globalGraphicParameter.fontA,globalGraphicParameter.fontSize()/1.1);
        
        for(int i=0;i<min(2,unificator.length);i++)
        {
            x0=unificator[i].draw(x,y);
            uwidth=max(uwidth,x0-x);
            y+=globalGraphicParameter.fontSize();
        }
        
        if(unificator.length>2)
        {
            text(" ...",x0,y-globalGraphicParameter.fontSize());
        }
        
        if(globalSelectedSubstSubtree && this==globalSelectedSubstSubtree.node)
        {
            fill(0,0,0,0);
            stroke(globalGraphicParameter.edge_color);
            rect(uposX,
                 uposY-globalGraphicParameter.fontSize(),
                 uwidth,
                 globalGraphicParameter.fontSize()*(0.5+min(2,unificator.length)),
                 globalGraphicParameter.fontSize()*0.5);
        }
        
        globalGraphicParameter.setTextSize();
        
        return x;
    }
    String export_subs_svg(int x,int y)
    {
        float x0;
        Struing a="";
        for(int i=0;i<unificator.length;i++)
        {
            a+=unificator[i].export_svg(x,y);
            y+=8;
        }
        return a;
    }
    float draw_subs_r(int x,int y)
    {
        for(int i=0;i<unificator.length;i++)
        {
            x+=unificator[i].draw(x,y);
        }
        return x;
    }
    float draw_subs0(int x,int y)
    {
        for(int i=0;i<unificator.length;i++)
        {
            x=unificator[i].draw(x,y);
        }
        return x;
    }
    float draw_subs_i(int x,int y)
    {
        float w=0;
        for(int i=0;i<unificator.length;i++)
        {
            w=max(w,unificator[i].draw(x,y)-x);
            y+=globalGraphicParameter.fontSize();
        }
        return w;
    }
    void draw_cid(int x,int y)
    {
        if(globalGraphicParameter.draw_clauseid && clause.id>0)
        {
            float r=globalGraphicParameter.fontSize()/2;
            fill(255);
            stroke(255);
            ellipse(x,y,2*r,2*r)
            fill(0);
            if(clause.id<10)text(clause.id,x-r*.66,y+r*.78);
            else if(clause.id<100000)text(clause.id,x-r*1.16,y+r*.78);
            else text("0",x-r*.66,y+r*.78);
        }
    }
    String export_svg()
    {
        float x=getX();
        float y=getY();
        float gx=x+30;
        float gy=y+20;
        return goal.export_svg(gx,gy);
    }
}

class Vektor
{
    float x;
    float y;
    Vektor(float a,float b)
    {
        x=a;
        y=b;
    }
    void normal()
    {
        float h;
        h=x;
        x=y;
        y=-x;
    }
    void inv()
    {
        x=-x;
        y=-y;
    }
    void unit()
    {
        float l=sqrt(x*x+y*y);
        x=x/l;
        y=y/l;
    }
    void scaley(float yy)
    {
        x=x*yy/y;
        y=yy;
    }
}

class Tree
{
    Node node;
    Tree parenttree;
    Tree[] subtrees=new Tree[0];
    
    Tree right_neighbour=null;
    Tree left_neighbour=null;
    
    float right_margin=0.0;
    float left_margin=0.0;
    
    int subTreeHeight=0;
    
    PrologTerm prologTerm;
    GlobalParameter g;
    AnimColor color=new AnimColor(255,255,255,200);
    Tree(Node n,PrologTerm t,GlobalParameter gp,Tree pt)
    {
        node=n;
        prologTerm=t;
        g=gp;
        parenttree=pt;
        if(parenttree)parenttree.addTree(this);
        node.t=this;
    }
    void addTree(Tree t)
    {
        t.subtreespos=subtrees.length;
        subtrees=append(subtrees,t);
    }
    void draw()
    {
        stroke(color.getR(),color.getG(),color.getB(),color.getA());
        if(parenttree || node.clause.id!=0)
        {
            float x=node.getX()+node.width/2+globalGraphicParameter.scrollx;
            float y=node.getY()+node.getH()/2+globalGraphicParameter.scrolly;
            float xx;
            float yy;
            if(parenttree)
            {
                xx=parenttree.node.getX()+parenttree.node.width/2+globalGraphicParameter.scrollx;
                yy=parenttree.node.getY()+parenttree.node.getH()/2+globalGraphicParameter.scrolly;
            }
            else
            {
                xx=x;
                yy=y-globalGraphicParameter.levelh;
            }
            stroke(globalGraphicParameter.edge_color);
            strokeWeight(2);
            line(x,y,xx,yy);
            strokeWeight(1);

            //Clause-ID
            Vektor v=new Vektor(x-xx,y-yy);
            v.scaley(globalGraphicParameter.fontSize()*2.2);
            node.draw_cid(xx+v.x,yy+v.y);
            
            //Substitution
            if(globalGraphicParameter.draw_subst)
            {
                if(globalGraphicParameter.rotate_substext)
                {
                    //--------------------------------------------------------
                    // Text fuer die Substitution parallel zur Kante ausgeben.
                    //--------------------------------------------------------
                    pushMatrix();
                    v.inv();
                    float a=-atan((y-yy)/(xx-x));
                    if((a>0 || a>QUARTER_PI) && a<HALF_PI)
                    {
                        v.scaley(globalGraphicParameter.fontSize()*2.9);
                        translate(xx+v.x,yy+v.y);
                        v.normal();
                        v.unit();
                        translate(v.x*globalGraphicParameter.fontSize()*0.5,v.y*globalGraphicParameter.fontSize()*0.5);
                    }
                    else
                    {
                        v.scaley(globalGraphicParameter.fontSize()*1.6);
                        v.inv();
                        translate(x+v.x,y+v.y);
                        v.normal();
                        v.unit();
                        translate(v.x*globalGraphicParameter.fontSize()*0.5,-v.y*globalGraphicParameter.fontSize()*0.5);
                    }
                    rotate(a);
                    node.draw_subs_r(0,0);
                    popMatrix();
                }
                else
                {
                    //--------------------------------------------------------
                    // Text fuer die Substitution horizontal ausgeben.
                    //--------------------------------------------------------
                    float px=x-xx;
                    float py=y-yy;
                    Vektor v=new Vektor(px,py);
                    v.scaley(globalGraphicParameter.fontSize()*3.7);
                    //falls /-Kante
                    if(v.x<0)
                    {
                        Vektor w=new Vektor(px,py);
                        w.scaley(globalGraphicParameter.fontSize());
                        v.x+=-w.x/2;
                    }
                    node.draw_subs(xx+v.x,yy+v.y,this);
                }
            }
        }
        for(int i=0;i<subtrees.length;i++)
        {
            subtrees[i].draw();
        }
    }
    void draw_nodes()
    {
        node.draw(globalSelectedSubtree==this);
        for(int i=0;i<subtrees.length;i++)
        {
            subtrees[i].draw_nodes();
        }
    }
    
    //-------------------------------
    // Bewegen durch den Baum
    //-------------------------------
    void moveup()
    {
        if(parenttree)globalSelectedSubtree=parenttree
    }
    void movedown()
    {
        if(subtrees.length)globalSelectedSubtree=subtrees[0];
    }
    void moveleft()
    {
        if(left_neighbour)globalSelectedSubtree=left_neighbour;
        else globalSelectedSubtree=rightmost();
    }
    void moveright()
    {
        if(right_neighbour)globalSelectedSubtree=right_neighbour;
        else globalSelectedSubtree=leftmost();
    }
    //-------------------------------
    // Knoten suchen an Pos.
    //-------------------------------
    Tree findFromPoint(int x,int y)
    {
        if(node.isInNode(x,y))
        {
            return this;
        }
        else
        {
            for(int i=0;i<subtrees.length;i++)
            {
                Tree b=subtrees[i].findFromPoint(x,y);
                if(b)return b;
            }
        }
        return null;
    }
    Tree findSubstFromPoint(int x,int y)
    {
        if(node.isInSubst(x,y))
        {
            return this;
        }
        else
        {
            for(int i=0;i<subtrees.length;i++)
            {
                Tree b=subtrees[i].findSubstFromPoint(x,y);
                if(b)return b;
            }
        }
        return null;
    }
    //-------------------------------
    // Knoten suchen
    //-------------------------------
    //einfacher!
    Tree firstSibling()
    {
        if(left_neighbour && parenttree==left_neighbour.parenttree)
            return left_neighbour.firstSibling();
        return this;
    }
    //einfacher!
    Tree lastSibling()
    {
        if(right_neighbour && parenttree==right_neighbour.parenttree)
            return right_neighbour.lastSibling();
        return this;
    }
    //einfacher!
    Tree leftmost()
    {
        if(left_neighbour)return left_neighbour.leftmost();
        return this;
    }
    //einfacher!
    Tree rightmost()
    {
        if(right_neighbour)return right_neighbour.rightmost();
        return this;
    }
    float widthOfBlock()
    {
        Tree a=firstSibling();
        Tree b=lastSibling();
        return b.node.getX()+b.node.width-a.node.getX();
    }
    float new_widthOfBlock()
    {
        Tree a=firstSibling();
        Tree b=lastSibling();
        return b.node.new_x+b.node.width-a.node.new_x;
    }
    //-------------------------------------------
    //Benoetigt Datenstruktur um Abstaende zu verfolgen und Zuordnung zu Teilbaeumen.
    //requires parenttree!=null
    float new_minWidthOfBlock()
    {
        float width=0;
        for(int i=0;i<parenttree.subtrees.length;i++)
        {
            width+=parenttree.subtrees[i].node.width+globalGraphicParameter.xspacing;
        }
        return width-globalGraphicParameter.xspacing;
    }
    //requires parenttree!=null
    void spread_block()
    {
        float block_width=new_widthOfBlock();
        float block_min_width=new_minWidthOfBlock();
        float spread=block_width-block_min_width;
        if(spread>1)
        {
            float s=spread/parenttree.subtrees.length;
        }
    }
    //-------------------------------------------
    float move_tree(float m)
    {
        //Check right margin
        //--TODO-- reicht so nicht es muessen alle Konturen aller nachfolgenden Baume geprueft werden.
        /*
        if(subtrees.length==0 && right_neighbour)
        {
            right_margin=right_neighbour.node.new_x-node.new_x-node.width-globalGraphicParameter.xspacing;
        }
        else if(subtrees.length!=0 && right_neighbour)
        {
            right_margin=min(subtrees[0].lastSibling().right_margin,right_neighbour.node.new_x-node.new_x-node.width-globalGraphicParameter.xspacing);
        }
        else
        {
            right_margin=0;
        }
        */
        //Move node to right.
        node.new_x+=m;
        //Move all subnodes to right.
        for(int i=0;i<subtrees.length;i++)
        {
            subtrees[i].move_tree(m);
        }
        //Adapt margin and m.
        /*
        if(right_margin>0)
        {
            if(right_margin<m)
            {
                m-=right_margin;
                right_margin=0;
            }
            else
            {
                right_margin-=m;
                m=0;
            }
        }
        */
        return m;
    }
    void move_tree_right(float m)
    {
        //move subtree to right.
        move_tree(m);
        //move all right subtrees to right.
        Tree rn=right_neighbour;
        while(rn)
        {
            m=rn.move_tree(m);
            rn=rn.right_neighbour;
        }
    }
    void move_node_right(float m)
    {
        node.new_x+=m;
        if(right_neighbour)right_neighbour.move_node_right(m);
    }
    String export_svg()
    {
        String a="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n"+
                   "<svg\n"+
                       "xmlns:dc=\"http://purl.org/dc/elements/1.1/\"\n"+
                       "xmlns:cc=\"http://creativecommons.org/ns#\"\n"+
                       "xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n"+
                       "xmlns:svg=\"http://www.w3.org/2000/svg\"\n"+
                       "xmlns=\"http://www.w3.org/2000/svg\"\n"+
                       "version=\"1.1\"\n"+
                       "width=\"210mm\"\n"+
                       "height=\"297mm\">\n"+
                     "<g>";
        a=export_svg_intern(a);
        a+="</g></svg>";
        return a;
    }
    String export_svg_intern(String a)
    {
        a+=node.export_svg();
        
        if(parenttree || node.clause.id!=0)
        {
            float x=node.getX()+node.width/2;
            float y=node.getY()+node.getH()/2;
            float xx;
            float yy;
            if(parenttree)
            {
                xx=parenttree.node.getX()+parenttree.node.width/2-x;
                yy=parenttree.node.getY()+parenttree.node.getH()/2-y;
            }
            else
            {
                xx=0;
                yy=globalGraphicParameter.levelh;
            }
            a+="<path d=\"m "+x+","+y+" "+xx+","+yy+"\" style=\"fill:none;stroke:#000000;stroke-width:2;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-opacity:1;stroke-dasharray:none\" />\n";
            
            //Substitution
            if(globalGraphicParameter.draw_subst)
            {
                Vektor v=new Vektor(x-xx,y-yy);
                a+=node.export_subs_svg(xx+v.x,yy+v.y);
            }
        }
        for(int i=0;i<subtrees.length;i++)
        {
            a=subtrees[i].export_svg_intern(a);
        }
        return a;
    }
}
