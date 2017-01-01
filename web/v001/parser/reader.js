/*******************************************************************************
*                                                                              *
*  reader.js                                                                   *
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
// Eine einfache Klasse um Zeichen aus einem String einzulesen,
// wobei unterschiedliche Zeilenumbrueche (in Unix, Windows,
// Mac, ...) einheitlich behandelt werden.

function Reader(a,ln)
{
    this.ahead=0;
    this.currentChar;
    this.charType=0;
    this.currline=1;
    this.currcolumn=0;
    this.str=a;
    this.readPos=0;
    this.strLength=ln;
    this.get=function()
    {
        if(this.ahead==1)
        {
            this.ahead=0;
            this.moveCursorPos();
            this.charType=0;
            return this.currentChar;
        }
        if(this.getNext())
        {
            if(this.charType==0)
            {
                return this.currentChar;
            }
            return '\n';
        }
        else
        {
            return -1;
        }
    }
    this.getChar=function()
    {
        if(this.getNextChar())return this.currentChar;
        return -1;
    }
    this.getNext=function()
    {
        this.moveCursorPos();
        
        var n=this.getNextChar();

        if(n && this.currentChar=='\n')
        {
            n+=this.getNextChar();
            if(n==2 && this.currentChar=='\r')
            {
                this.charType=3;
                this.ahead=0;
            }
            else
            {
                this.charType=1;
                this.ahead=1;
            }
        }
        else if(n && this.currentChar=='\r')
        {
            n+=this.getNextChar();
            if(n==2 && this.currentChar=='\n')
            {
                this.charType=4;
                this.ahead=0;
            }
            else
            {
                this.charType=2;
                this.ahead=1;
            }
        }
        else if(n)
        {
            this.charType=0;
            this.ahead=0;
        }
        else
        {
            this.charType=-1;
            this.ahead=0;
        }
        
        return n;
    }
    this.getNextChar=function()
    {
        if(this.readPos<this.strLength)
        {
            this.currentChar=this.str.charAt(this.readPos);
            this.readPos++;
            return 1;
        }
        return 0;
    }
    this.moveCursorPos=function()
    {
        //Zeilen und Spalten zaehlen.
        this.currcolumn++;
        if(this.charType!=0)
        {
            this.currline++;
            this.currcolumn=1;
        }
    }
}
