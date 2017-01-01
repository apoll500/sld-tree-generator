/*******************************************************************************
*                                                                              *
*  properties.pde                                                              *
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
class AnimPosition<T extends Number>
{
    AnimatedParameterG<T> x;
    AnimatedParameterG<T> y;
    AnimPosition(T xx,T yy)
    {
        x=new AnimatedParameterG<T>(xx);
        y=new AnimatedParameterG<T>(yy);
    }
    AnimPosition(T xx,T yy,AnimationFunction func)
    {
        x=new AnimatedParameterG<T>(xx,func);
        y=new AnimatedParameterG<T>(yy,func);
    }
    T getX()
    {
        return x.getParameter();
    }
    T getY()
    {
        return y.getParameter();
    }
    T getX0()
    {
        return x.getStartParameter();
    }
    T getY0()
    {
        return y.getStartParameter();
    }
    void setAnim(T xx,T yy,T duration)
    {
        x.startAnim(duration,xx);
        y.startAnim(duration,yy);
    }
    void setAnimX(T xx,T duration)
    {
        x.startAnim(duration,xx);
    }
    void setAnimY(T yy,T duration)
    {
        y.startAnim(duration,yy);
    }
    void set(T xx,T yy)
    {
        x.setStartParameter(xx);
        y.setStartParameter(yy);
    }
    void setX(T xx)
    {
        x.setStartParameter(xx);
    }
    void setY(T yy)
    {
        y.setStartParameter(yy);
    }
}

class AnimColor
{
	AnimatedParameterG<char> r;//red
	AnimatedParameterG<char> g;//green
	AnimatedParameterG<char> b;//blue
	AnimatedParameterG<char> a;//alpha
    AnimColor()
    {
        r=new AnimatedParameterG<char>();
        g=new AnimatedParameterG<char>();
        b=new AnimatedParameterG<char>();
        a=new AnimatedParameterG<char>(255);
    }
    AnimColor(char gg)
    {
        r=new AnimatedParameterG<char>(gg);
        g=new AnimatedParameterG<char>(gg);
        b=new AnimatedParameterG<char>(gg);
        a=new AnimatedParameterG<char>(255);
    }
    AnimColor(char rr,char gg,char bb)
    {
        r=new AnimatedParameterG<char>(rr);
        g=new AnimatedParameterG<char>(gg);
        b=new AnimatedParameterG<char>(bb);
        a=new AnimatedParameterG<char>(255);
    }
    AnimColor(char rr,char gg,char bb,char aa)
    {
        r=new AnimatedParameterG<char>(rr);
        g=new AnimatedParameterG<char>(gg);
        b=new AnimatedParameterG<char>(bb);
        a=new AnimatedParameterG<char>(aa);
    }
	void setColor(){r.setParameter(0);g.setParameter(0);b.setParameter(0);a.setParameter(255);}
	void setColor(char gg){r.setParameter(gg);g.setParameter(gg);b.setParameter(gg);a.setParameter(255);}
	void setColor(char rr,char gg,char bb){r.setParameter(rr);g.setParameter(gg);b.setParameter(bb);a.setParameter(255);}
	void setColor(char rr,char gg,char bb,char aa){r.setParameter(rr);g.setParameter(gg);b.setParameter(bb);a.setParameter(aa);}
    char getR()
    {
        return r.getParameter();
    }
    char getG()
    {
        return g.getParameter();
    }
    char getB()
    {
        return b.getParameter();
    }
    char getA()
    {
        return a.getParameter();
    }
    void setAnim(char rr,char gg,char bb,char aa,int duration)
    {
        r.startAnim(duration,rr);
        g.startAnim(duration,gg);
        b.startAnim(duration,bb);
        a.startAnim(duration,aa);
    }
}
