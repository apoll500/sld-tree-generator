/*******************************************************************************
*                                                                              *
*  animator.pde                                                                *
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
//Zeitlicher Verlauf der Bewegungsgeschwindigkeit
//--------------------------------------------------------
interface AnimationFunction
{
    float calc(float f);
}

class LinearAnimation implements AnimationFunction
{
    float calc(float f)
    {
        f=min(1,f);
        return f;
    }
}

class SinAnimation implements AnimationFunction
{
    float calc(float f)
    {
        f=min(1,f);
        return sin(f*HALF_PI);
    }
}

class LogarithmicAnimation implements AnimationFunction
{
    float calc(float f)
    {
        f=min(1,f);
        return logb(1+f,2);
    }
}

//--------------------------------------------------------
//Einfacher animierbarer generischer Parameter
//--------------------------------------------------------
class AnimatedParameterG<T extends Number>
{
    float startTime;
    float endTime;
    AnimationFunction animfunc;
    T parameter_start;
    T parameter_end;
    boolean animRunning=false;
    AnimatedParameterG(T p)
    {
        setParameter(p);
        animfunc=new LogarithmicAnimation();
    }
    AnimatedParameterG(T p,AnimationFunction f)
    {
        setParameter(p);
        animfunc=f;
    }
    void setParameter(T p)
    {
        parameter_start=p;
        parameter_end=p;
    }
    void setParameter(T oldp,T newp)
    {
        parameter_start=oldp;
        parameter_end=newp;
    }
    void setParameterAnim(T p)
    {
        parameter_start=parameter_end;
        parameter_end=p;
    }
    void startAnim(float duration)
    {
        startTime=millis();
        endTime=startTime+duration;
        animRunning=true;
    }
    void startAnimRev(float duration)
    {
        T p=parameter_start;
        parameter_start=parameter_end;
        parameter_end=p;
        startTime=millis();
        endTime=startTime+duration;
        animRunning=true;
    }
    void startAnim(float duration,T newp)
    {
        startTime=millis();
        endTime=startTime+duration;
        setParameterAnim(newp);
        animRunning=true;
    }
    void startAnim(float duration,T oldp,T newp)
    {
        startTime=millis();
        endTime=startTime+duration;
        setParameter(oldp,newp);
        animRunning=true;
    }
    T getEndParameter()
    {
        return parameter_end;
    }
    T setEndParameter(T p)
    {
        parameter_end=p;
    }
    T getStartParameter()
    {
        return parameter_start;
    }
    T setStartParameter(T p)
    {
        parameter_start=p;
    }
    T getParameter()
    {
        if(animRunning)
        {
            float currentTime=millis();
            if(currentTime<endTime)
            {
                return parameter_start+(parameter_end-parameter_start)*animfunc.calc((currentTime-startTime)/(endTime-startTime));
            }
            animRunning=false;
        }
        return parameter_end;
    }
    T getParameter(float currentTime)
    {
        if(animRunning)
        {
            if(currentTime<endTime)
            {
                return parameter_start+(parameter_end-parameter_start)*animfunc.calc((currentTime-startTime)/(endTime-startTime));
            }
            animRunning=false;
        }
        return parameter_end;
    }
}
